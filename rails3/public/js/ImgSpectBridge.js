// require ImgCollectApi.js

( function( global ) {
ImgSpectBridge = function( spect ) {
	
	/**
	 *  There should be only one API object.
	 */ 
	if ( ImgSpectBridge.prototype.me ) {
		return ImgSpectBridge.prototype.me;
	}
	ImgSpectBridge.prototype.me = this;
	
	// Store reference to imgspect instance
	this.spect = spect;
	this.api = new ImgCollectApi();
	this.events = {
		save: 'ImgSpectBridge-SAVE',
		get: 'ImgSpectBridge-GET'
	}
	
	/**
	 *  Create save button
	 */
	this.start = function() {
		var self = this;
		self.saveClick();
		
		// API event handling
		$( document ).on( 'ImgCollectApi-SUCCESS', function( e, result ) {
			switch ( result.context ) {
				case self.events['get']:
					self.loadData( result['data'] );
					break;
				case self.events['save']:
					break;
			}
		});
		
		// Get the subregions
		self.get();
	}

	/**
	 *  Load the subregion data into Imgspect
	 */	
	this.loadData = function( data ) {
		var subs = data['subregions'];
		spect.load( subs );
	}
	
	/**
	 *  When the save button is clicked
	 */
	this.saveClick = function() {
		var self = this;
		$( '#save' ).on( 'touchstart click', function( e ) {
			e.preventDefault();
			var bits = self.spect.imgbits;
			for ( var i=0; i<bits.length; i++ ) {
				var cap = bits[i].caption;
				var c = bits[i].relative();
				self.save( c[0], c[1], c[2], c[3], cap );
			}
		});
	}
	
	/**
	 *  Save the subregion
	 */
	this.save = function( x, y, w, h, caption ) {
		var self = this;
		self.api.send( 'subregion', 'create', {
			x: x,
			y: y,
			width: w,
			height: h,
			caption: caption,
			cite_urn: $( '#urn' ).val()
		}, self.events['save'] );
	}
	
	/**
	 *  Retrieve subregions in triplestore
	 */
	this.get = function() {
		var self = this;
		var cite_urn = $( '#urn' ).val();
		self.api.send( 'subregion', 'all', {
			cite_urn: cite_urn.urnToPath()
		}, self.events['get'] );
	}
	
	// Start things up
	this.start();
}
} ( window ) );