ImgCollectUpload = function() {
	this.api = new ImgCollectApi();
}

ImgCollectUpload.prototype.start = function() {
	var self = this;
	jQuery( '#uploader_url #url' ).on( 'keydown', function( _e ) {
		switch( _e.which ) {
			case 13:
				self.api.send( 'image', 'upload', { file: this.val() }, 'ImgCollectUpload' )
				break;
		}
	});
}
