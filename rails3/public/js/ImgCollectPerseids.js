/* require jslib/ObjectExt.js */

( function( global ) {
ImgCollectPerseids = function() {
	
	/**
	 *  There can be only one!
	 */ 
	if ( ImgCollectPerseids.prototype.me ) {
		return ImgCollectPerseids.prototype.me;
	}
	ImgCollectPerseids.prototype.me = this;
	
	
	// this.url = "http://sosol.perseids.org/sosol/dmm_api/ping";
	this.url = "/json/user_ping.json";
	
	this.oe = new ObjectExt();
	
	this.events = {
		success: 'ImgCollectPerseids-SUCCESS',
		error: 'ImgCollectPerseids-ERROR',
		no_user: 'ImgCollectPerseids-NO_USER'
	};
	
	this.user = null;
	
	this.check = function() {
		var self = this;
		$.ajax({
			url: self.url,
			type: 'GET',
			dataType: 'json',
			success: function( data ) {
				self.data = data;
				self.user = data.user.uri;
				if ( self.oe.isEmpty( self.data ) ) {
					$( document ).trigger( self.events.no_user );
					return;
				}
				$( document ).trigger( self.events.success );
			},
			error: function( error ) {
				$( document ).trigger( self.events.error );
			}
		});
	}
	
	// TODO: Build a better alert system!
	this.start = function() {
		var self = this;
		$( document ).on( self.events.success, function() {});
		$( document ).on( self.events.error, function() {
			alert( 'Could not contact Perseids to retrieve user info!' );
		});
		$( document ).on( self.events.no_user, function() {
			alert( 'Please login to Perseids!' );
		});
		this.check();
	}
};
} ( window ) );