ImgCollectConfig = function() {
	this.get();
}
ImgCollectConfig.config = null;
ImgCollectConfig.prototype.configUrl = '/search/config';
ImgCollectConfig.prototype.events = {
	ready: 'ImgCollectConfig-READY',
	error: 'ImgCollectConfig-ERROR'
}
ImgCollectConfig.prototype.get = function() {
	var self = this;
	jQuery.ajax({
		dataType: "json",
		url: self.configUrl,
		timeout: 10*1000, // 10 second timeout
		success: function( _data ) {
			ImgCollectConfig.config = _data;
			jQuery( document ).trigger( self.events['ready'] );
		},
		error: function( _e ) {
			jQuery( document ).trigger( self.events['error'] );
		}
	});
}
