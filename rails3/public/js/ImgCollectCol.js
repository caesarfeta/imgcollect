ImgCollectCol = function() {
	this.button = "#collectionModal .button";
	this.start();
	this.api = new ImgCollectApi();
}

ImgCollectCol.prototype.start = function() {
	var self = this;
	jQuery( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
		if ( _data['context'] != 'ImgCollectCol' ) {
			return;
		}
		//------------------------------------------------------------
		//  Otherwise add some goodness!
		//------------------------------------------------------------
	});
	jQuery( this.button ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var data = {};
		data['name'] = jQuery( '#collectionName' ).val();
		data['urn'] = jQuery( '#collectionURN' ).val();
		self.api.send( 'collection', 'create', data, 'ImgCollectCol')
	})
}