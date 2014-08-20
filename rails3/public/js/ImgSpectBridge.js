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
	
	/**
	 *  TODO Retrieve subregions in triplestore
	 */
	this.get = function() {}
	
	/**
	 *  Create save button
	 */
	this.start = function() {
		var self = this;
		$( '#save' ).on( 'touchstart click', function( _e ) {
			_e.preventDefault();
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
		}, 'ImgSpectBridge' );
	}
	
	// Start things up
	this.start();
}
} ( window ) );