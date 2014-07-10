$(document).ready( function() {
	img_metadata_resize();
});
$(window).resize( function(){
	img_metadata_resize()
});
function img_metadata_resize() {
	$( '.img-metadata' ).each( function(){
		var h = $( 'img', this ).height();
		$( this ).height( h );
		$( '.metadata', this ).css({
			'max-height': h
		});
	});
}
