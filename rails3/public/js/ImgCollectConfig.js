ImgCollectConfig = function() {
	this.get();
}
ImgCollectConfig.config = null;
ImgCollectConfig.prototype.configUrl = $("input[name='configurl']").val();
ImgCollectConfig.prototype.events = {
	ready: 'ImgCollectConfig-READY',
	error: 'ImgCollectConfig-ERROR'
}
ImgCollectConfig.prototype.get = function() {
	var self = this;
	$.ajax({
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
