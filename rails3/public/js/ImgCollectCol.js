ImgCollectCol = function() {
	this.button = "#collectionModal .button";
	this.start();
	this.api = new ImgCollectApi();
	this.urn = null;
	this.utils = new ImgCollectUtils();
}

/**
 * Start collection event handlers
 */
ImgCollectCol.prototype.start = function() {
	var self = this;
	
	// Cite form handler
	$( '#citeModal .button' ).on( 'touchstart click', function( e ) {
		e.preventDefault();
		self.utils.clearResults();
		self.citeify();
	});
	
	//  When image previews are loaded
	$( document ).on( 'ImgsLoaded-START', function( e ) {
		
		// Add button
		$( '.image-full .button.new.add' ).each( function() {
			$( this ).removeClass( 'new' );
			$( this ).on( 'touchstart click', function( e ) {
				e.preventDefault();
				var img_urn = $( this ).parents( '.image-full' ).attr( 'data-urn' );
				var col_urn = $( '#activeDock' ).attr( 'data-urn' );
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
	$( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
		switch ( _data['context'] ) {

			//  After creating a new collection
			case 'ImgCollectCol-CREATE':
				self.clearCreate();
				self.utils.clearResults();
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
				self.clearCiteify();
				self.api.get( 'collection', _data['data']['collection']['urn'].lastInt() );
				break;
		}
	});
	
	//  Click the Create button?
	$( this.button ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var data = {};
		data['name'] = $( '#collectionName' ).val();
		data['cite_urn'] = $( '#collectionURN' ).val();
		data['label'] = $( '#collectionLabel' ).val();
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
	$( '.button.citeify', _elem ).on( 'touchstart click', function( _e ) {
		self.urn = $( this ).attr( 'data-urn' );
		$( '#citeModal' ).foundation( 'reveal', 'open' );
	});
}

/**
 * "Activate" the collection activate button
 *
 * @param { Dom } _elem
 */
ImgCollectCol.prototype.activateTouch = function( _elem ) {
	var self = this;
	$( '.button.activate', _elem ).on( 'touchstart click', function( _e ) {
		$( '.collection-box .button.activate' ).removeClass( 'active' );
		var urn = $( this ).attr( 'data-urn' );
		var dock_urn = $( '#activeDock' ).attr( 'data-urn' );
		if ( dock_urn != undefined && dock_urn == urn ) {
			self.deactivate();
			return;
		}
		$( this ).addClass( 'active' );
		self.dock( urn );
	});
}

/**
 * CITEify a collection
 */
ImgCollectCol.prototype.citeify = function() {
	var self = this;
	var prefix = 'urn:cite:';
	var cite_urn = $( '#citeModal input#citeUrn').val();
	if ( cite_urn.indexOf( prefix ) != 0 ) {
		cite_urn = prefix + cite_urn;
	}
	self.api.send( 'collection', 'citeify', { 
		'collection_id': self.urn.lastInt(),
		'cite_urn': cite_urn }, 
		'ImgCollectCol-CITEIFY' 
	);
}

/**
 * "Deactivate" the collection
 */
ImgCollectCol.prototype.deactivate = function() {
	$( '#activeDock').remove();
	$( '.collection-box .button.activate.active' ).removeClass( 'active' );
	$( '#results' ).removeClass( 'active' );
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
 * Clear the inputs of the collection create form
 */
ImgCollectCol.prototype.clearCreate = function() {
	this.clearInputs( '#collectionModal' );	
}

/**
 * Clear the inputs of the collection citeify form
 */
ImgCollectCol.prototype.clearCiteify = function() {
	this.clearInputs( '#citeModal' );
}

/**
 * Clear form inputs
 */
ImgCollectCol.prototype.clearInputs = function( form ) {
	$( form + ' input' ).each( function() {
		$( this ).val('');
	});
}

/**
 * Build the dock
 *
 * @param { JSON } _data
 */
ImgCollectCol.prototype.buildDock = function( _data ) {
	var self = this;
	$( '#activeDock' ).remove();
	$( 'body' ).append( _data['data'] );

	//  Start 
	$( '#activeDock .close' ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.deactivate();
	});
	$( '#results' ).addClass( 'active' );
}

