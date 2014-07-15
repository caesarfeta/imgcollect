$(document).ready( function() {
	image_full_resize();
});
$(window).resize( function(){
	image_full_resize()
});
function image_full_resize() {
	$( '.image-full' ).each( function(){
		var h = $( 'img', this ).height();
		$( this ).height( h );
		$( '.metadata', this ).css({
			'max-height': h
		});
	});
}
