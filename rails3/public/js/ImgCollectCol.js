ImgCollectCol = function() {
	this.button = "#collectionModal .button";
	this.start();
	this.api = new ImgCollectApi();
}

/**
 * Start collection event handlers
 */
ImgCollectCol.prototype.start = function() {
	var self = this;
	//------------------------------------------------------------
	//  When image previews are loaded
	//------------------------------------------------------------
	jQuery( document ).on( 'ImgsLoaded-START', function( _e ) {
		jQuery( '.image-full .button.new' ).each( function() {
			jQuery( this ).removeClass( 'new' );
			jQuery( this ).on( 'touchstart click', function( _e ) {
				_e.preventDefault();
			
				console.log( 'done it' );
			});
		});
	})
	
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
				self.buildDock( _data );
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
 * "Activate" the collection activate button.
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.activate = function( _elem ) {
	var self = this;
	if ( _elem.hasClass('collection-box') ) {
		jQuery( '.button.activate', _elem ).on( 'touchstart click', function( _e ) {
			jQuery( '.collection-box .button.activate' ).removeClass( 'active' );
			var urn = jQuery( this ).attr( 'data-urn' );
			var dock_urn = jQuery( '#activeDock' ).attr( 'data-urn' );
			if ( dock_urn != undefined && dock_urn == urn ) {
				self.deactivate();
				return;
			}
			jQuery( this ).addClass( 'active' );
			self.dock( urn );
		});
	}
}

/**
 * "Deactivate" the collection
 */
ImgCollectCol.prototype.deactivate = function() {
	jQuery( '#activeDock').remove();
	jQuery( '.collection-box .button.activate.active' ).removeClass( 'active' );
}

/**
 * Dock the active collection.
 */
ImgCollectCol.prototype.dock = function( _urn ) {
	self.api.send( 'collection', 'dock', { 'id': _urn.lastInt() }, 'ImgCollectCol-DOCK' );
}

/**
 * Build the dock
 */
ImgCollectCol.prototype.buildDock = function( _data ) {
	var self = this;
	jQuery( '#activeDock' ).remove();
	jQuery( 'body' ).append( _data['data'] );
	//------------------------------------------------------------
	//  Start 
	//------------------------------------------------------------
	jQuery( '#activeDock .close' ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.deactivate();
	});
}

