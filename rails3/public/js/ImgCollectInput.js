ImgCollectInput = function() {}
ImgCollectInput.prototype.events = {}
ImgCollectInput.prototype.start = function() {
	jQuery( ).on( 'touchstart click', function() {
		console.log( this );
	});
}