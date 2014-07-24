ImgCollectUpload = function() {
	this.api = new ImgCollectApi();
	this.input = '#uploader_url input';
	this.start();
}

/**
 * Listen for upload related events
 */
ImgCollectUpload.prototype.start = function() {
	var self = this;
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
		//------------------------------------------------------------
		//  Close the Reveal modal window
		//------------------------------------------------------------
		jQuery('.reveal-modal').trigger('reveal:close');
		//------------------------------------------------------------
		//  Load the uploaded images
		//------------------------------------------------------------
		self.latest( _data );
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
	for ( var i=0; i<_data['data'].length; i++ ) {
		if ( _data['data'][i]['message'] == 'Success' ) {
			urns.push( _data['data'][i]['urn'] );
		}
	}
	//------------------------------------------------------------
	//  Loop through the urns and download 'em!
	//------------------------------------------------------------
	for ( var i=0; i<urns.length; i++ ) {
		self.api.get( 'image', urns[i].lastInt() );
	}
}
