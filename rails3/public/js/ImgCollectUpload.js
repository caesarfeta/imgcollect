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
	
	try {
    	this.dropzone = new Dropzone( '.dropzone' );
		this.dropzone.on( 'sending', function( e, data ) {
			self.wait();
		});
		this.dropzone.on( 'success', function( e, data ) {
			self.success( data );
		});
	}
	catch( error ) {
		console.log( error );
	}
	
	//  A successful upload!
	$( document ).on( 'ImgCollectApi-SUCCESS', function( e, data ) {
		if ( data.context != 'ImgCollectUpload' ) {
			return;
		}
		self.success( data.data );
	});
	
	$( document ).on( 'ImgCollectApi-ERROR', function( e, data ) {
		if ( data.context != 'ImgCollectUpload' ) {
			return;
		}
		self.error( data.data );
	});

	//  Listen for the enter key press
	$( self.input ).on( 'keydown', function( e ) {
		switch( e.which ) {
			case 13:
				e.preventDefault();
				self.upload( $( self.input ).val() );
				break;
		}
	});

	//  You can also click a button...
	$( '#uploader_url .button' ).on( 'touchstart click', function( e ) {
		e.preventDefault();
		self.upload( $( self.input ).val() );
	});
}

/**
 * Upload a file
 */
ImgCollectUpload.prototype.upload = function( file ) {
	var self = this;
	self.wait();
	self.api.send( 'image', 'upload', { file: file }, 'ImgCollectUpload' );
}

/**
 * Display wait image
 */
ImgCollectUpload.prototype.wait = function() {
	$( '#uploader_message' ).html( '<img src="/img/loader.gif" />' );
}

/**
 * Remove wait image
 */
ImgCollectUpload.prototype.waitOver = function() {
	$( '#uploader_url input' ).val('');
	$( '#uploader_message' ).empty();
}

/**
 * Retrieve recently uploaded images
 */
ImgCollectUpload.prototype.latest = function( data ) {
	var self = this;

	//  Retrieve the new records
	var urns = [];
	for ( var i=0; i<data.length; i++ ) {
		if ( data[i].message == 'Success' ) {
			urns.push( data[i].urn );
		}
	}

	//  Mark the upload
//	self.utils.mark( 'uploaded', urns.join(',').escapeHtml().smoosh() );

	//  Loop through the urns and download 'em!
	for ( var i=0; i<urns.length; i++ ) {
		self.api.get( 'image', urns[i].lastInt() );
	}
}

/**
 * Display error
 */
ImgCollectUpload.prototype.error = function ( data ) {
	var self = this;
	self.waitOver();
	
	// Something went wrong how will it be handled?
	$( '#uploader_message' ).html( data.error );
}

/**
 * File was uploaded
 */
ImgCollectUpload.prototype.success = function ( data ) {
	var self = this;
	
	// Close the Reveal modal window
	self.waitOver();
	$('.reveal-modal').trigger( 'reveal:close' );

	// Load the uploaded images
	self.latest( data );
}