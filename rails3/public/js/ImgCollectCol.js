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
			self.dockActive( jQuery( _elem ) );
		});
	}
}

/**
 * Dock the active collection.
 */
ImgCollectCol.prototype.dockActive = function( _elem ) {
	var urn = jQuery( _elem ).attr( 'data-urn' );
	jQuery('#activeDock').remove();
	jQuery('body').append('\
		<div id="activeDock" data-urn="'+urn+'">\
			<div class="row">\
				<div class="column small-12">\
					<div class="name">Collection</div>\
					<div class="cite_urn">urn:cite:perseus:collectionection</div>\
				</div>\
			</div>\
			<div class="row">\
				<div class="column small-12">\
					<div class="smaller item images"><span class="amount">0</span> images</div>\
					<div class="smaller item subcollections"><span class="amount">0</span> subcollections</div>\
				</div>\
			</div>\
		</div>\
	');
}

