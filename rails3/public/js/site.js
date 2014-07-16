jQuery(document).ready( function() {
	image_full_resize();
});
jQuery(document).on( 'ImgCollectApi-SUCCESS', function() {
	image_full_resize();
})
jQuery(window).resize( function(){
	image_full_resize()
});
function image_full_resize() {
	jQuery( '.image-full' ).each( function(){
		var h = jQuery( 'img', this ).height();
		h = ( h < 300 ) ? 300 : h;
		jQuery( this ).height( h );
		jQuery( '.metadata', this ).css({
			'max-height': h
		});
	});
}
