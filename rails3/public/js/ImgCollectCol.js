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
	
	//  When image previews are loaded
	jQuery( document ).on( 'ImgsLoaded-START', function( _e ) {
		jQuery( '.image-full .button.new' ).each( function() {
			jQuery( this ).removeClass( 'new' );
			jQuery( this ).on( 'touchstart click', function( _e ) {
				_e.preventDefault();
				var img_urn = jQuery( this ).parents( '.image-full' ).attr( 'data-urn' );
				var col_urn = jQuery( '#activeDock' ).attr( 'data-urn' );
				var img_id = img_urn.lastInt();
				var col_id = col_urn.lastInt();
				
				// Make the API call
				self.api.send( 'collection', 'add/image', { 
					collection_id: col_id, 
					image_id: img_id }, 
					'ImgCollectCol-ADDIMG' 
				);
				
			});
		});
	});
	

	//  API event handlers
	jQuery( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
		switch ( _data['context'] ) {

			//  After creating a new collection
			case 'ImgCollectCol-CREATE':
				self.api.get( 'collection', _data['data']['collection']['urn'].lastInt() );
				break;

			//  Dock a collection
			case 'ImgCollectCol-DOCK':
				self.buildDock( _data );
				break;

			//  After adding an image to a collection
			case 'ImgCollectCol-ADDIMG':
				self.dock( _data['data']['collection']['urn'] );
				break;

			//  What happens after a citeify button gets clicked?
			case "ImgCollectCol-CITEIFY":
				// TODO Do something here?
				break;
		}
	});
	
	//  Click the Create button?
	jQuery( this.button ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var data = {};
		data['name'] = jQuery( '#collectionName' ).val();
		data['cite_urn'] = jQuery( '#collectionURN' ).val();
		data['label'] = jQuery( '#collectionLabel' ).val();
		self.api.send( 'collection', 'create', data, 'ImgCollectCol-CREATE' );
	});
}

/**
 * "Activate" the collection buttons
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.activate = function( _elem ) {
	var self = this;
	if ( _elem.hasClass('collection-box') ) {
		self.activateTouch( _elem );
		self.citeTouch( _elem );
	}
}

/**
 * "Activate" the CITEify button
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.citeTouch = function( _elem ) {
	var self = this;
	jQuery( '.button.citeify', _elem ).on( 'touchstart click', function( _e ) {
		var urn = jQuery( this ).attr( 'data-urn' );
		self.citeify( urn );
	});
}

/**
 * "Activate" the collection activate button
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.activateTouch = function( _elem ) {
	var self = this;
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

/**
 * CITEify a collection
 *
 * @param { String } _urn
 */
ImgCollectCol.prototype.citeify = function( _urn ) {
	var self = this;
	self.api.send( 'collection', 'citeify', { 
		'collection_id': _urn.lastInt() }, 
		'ImgCollectCol-CITEIFY' 
	);
}

/**
 * "Deactivate" the collection
 */
ImgCollectCol.prototype.deactivate = function() {
	jQuery( '#activeDock').remove();
	jQuery( '.collection-box .button.activate.active' ).removeClass( 'active' );
	jQuery( '#results' ).removeClass( 'active' );
}

/**
 * Dock the active collection
 *
 * @param { String } _urn
 */
ImgCollectCol.prototype.dock = function( _urn ) {
	var self = this;
	self.api.send( 'collection', 'dock', { 
		'id': _urn.lastInt() }, 
		'ImgCollectCol-DOCK' 
	);
}

/**
 * Build the dock
 *
 * @param { JSON } _data
 */
ImgCollectCol.prototype.buildDock = function( _data ) {
	var self = this;
	jQuery( '#activeDock' ).remove();
	jQuery( 'body' ).append( _data['data'] );

	//  Start 
	jQuery( '#activeDock .close' ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.deactivate();
	});
	jQuery( '#results' ).addClass( 'active' );
}

