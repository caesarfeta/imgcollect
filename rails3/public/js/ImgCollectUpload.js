ImgCollectUpload = function() {
	this.api = new ImgCollectApi();
	this.input = '#uploader_url input';
	this.utils = new ImgCollectUtils();
	this.start();
}

/**
 * Listen for upload related events
 */
ImgCollectUpload.prototype.start = function() {
	var self = this;
    var dropzone = new Dropzone(".dropzone");
	dropzone.on("success", function( _e, _data ){
		self.success( _data );
	});
	
	//------------------------------------------------------------
	//  A successful upload!
	//------------------------------------------------------------
	jQuery( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
		//------------------------------------------------------------
		//  Check the context of the API call
		//------------------------------------------------------------
		if ( _data['context'] != 'ImgCollectUpload' ) {
			return;
		}
		self.success( _data['data'] );
	});
	//------------------------------------------------------------
	//  Listen for the enter key press
	//------------------------------------------------------------
	jQuery( self.input ).on( 'keydown', function( _e ) {
		switch( _e.which ) {
			case 13:
				_e.preventDefault();
				self.upload( jQuery( self.input ).val() );
				break;
		}
	});
	//------------------------------------------------------------
	//  You can also click a button...
	//------------------------------------------------------------
	jQuery( '#uploader_url .button' ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.upload( jQuery( self.input ).val() );
	});
}

/**
 * Upload a file
 */
ImgCollectUpload.prototype.upload = function( _file ) {
	var self = this;
	self.api.send( 'image', 'upload', { file: _file }, 'ImgCollectUpload' );
}

/**
 * Retrieve recently uploaded images
 */
ImgCollectUpload.prototype.latest = function( _data ) {
	var self = this;
	//------------------------------------------------------------
	//  Retrieve the new records
	//------------------------------------------------------------
	var urns = [];
	for ( var i=0; i<_data.length; i++ ) {
		if ( _data[i]['message'] == 'Success' ) {
			urns.push( _data[i]['urn'] );
		}
	}
	//------------------------------------------------------------
	//  Mark the upload
	//------------------------------------------------------------
	self.utils.mark( 'uploaded', urns.join(',').escapeHtml().smoosh() );
	//------------------------------------------------------------
	//  Loop through the urns and download 'em!
	//------------------------------------------------------------
	for ( var i=0; i<urns.length; i++ ) {
		self.api.get( 'image', urns[i].lastInt() );
	}
}

/**
 * File was uploaded
 */
ImgCollectUpload.prototype.success = function ( _data ) {
	var self = this;
	//------------------------------------------------------------
	//  Close the Reveal modal window
	//------------------------------------------------------------
	jQuery('.reveal-modal').trigger('reveal:close');
	//------------------------------------------------------------
	//  Load the uploaded images
	//------------------------------------------------------------
	self.latest( _data );
}