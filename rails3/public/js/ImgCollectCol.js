ImgCollectCol = function() {
	this.button = "#collectionModal .button";
	this.start();
	this.api = new ImgCollectApi();
}

/**
 * Start the create collection button.
 */
ImgCollectCol.prototype.start = function() {
	var self = this;
	//------------------------------------------------------------
	//  Collection has been created... get it.
	//------------------------------------------------------------
	jQuery( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
		switch ( _data['context'] ) {
			//------------------------------------------------------------
			//  After creating a new collection
			//------------------------------------------------------------
			case 'ImgCollectCol-CREATE':
				self.api.get( 'collection', _data['data']['collection']['urn'].lastInt() );
				break;
			//------------------------------------------------------------
			//  Dock a collection
			//------------------------------------------------------------
			case 'ImgCollectCol-DOCK':
				jQuery('#activeDock').remove();
				jQuery('body').append( _data['data'] );
				break;
		}
	});
	//------------------------------------------------------------
	//  Click the Create button?
	//------------------------------------------------------------
	jQuery( this.button ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var data = {};
		data['name'] = jQuery( '#collectionName' ).val();
		data['cite_urn'] = jQuery( '#collectionURN' ).val();
		self.api.send( 'collection', 'create', data, 'ImgCollectCol-CREATE')
	})
}

/**
 * "Activate" the collection-box activate button.
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.activate = function( _elem ) {
	var self = this;
	if ( _elem.hasClass('collection-box') ) {
		jQuery( '.button.activate', _elem ).on( 'touchstart click', function( _e ) {
			jQuery( '.collection-box .button.activate' ).removeClass( 'active' );
			jQuery( this ).addClass( 'active' );
			self.dock( jQuery( this ) );
		});
	}
}

/**
 * Dock the active collection.
 */
ImgCollectCol.prototype.dock = function( _elem ) {
	var urn = jQuery( _elem ).attr( 'data-urn' );
	self.api.send( 'collection', 'dock', { 'id': urn.lastInt() }, 'ImgCollectCol-DOCK')
}

