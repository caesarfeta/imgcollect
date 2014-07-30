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
		if ( _data['context'] != 'ImgCollectCol' ) {
			return;
		}
		self.api.get( 'collection', _data['data']['collection']['urn'].lastInt() );
	});
	//------------------------------------------------------------
	//  Click the Create button?
	//------------------------------------------------------------
	jQuery( this.button ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var data = {};
		data['name'] = jQuery( '#collectionName' ).val();
		data['cite_urn'] = jQuery( '#collectionURN' ).val();
		self.api.send( 'collection', 'create', data, 'ImgCollectCol')
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
			var urn = jQuery( this ).attr( 'data-urn' );
			self.dockActive( urn );
		});
	}
}

ImgCollectCol.prototype.dockActive = function( _urn ) {
	jQuery('#activeDock').remove();
}

