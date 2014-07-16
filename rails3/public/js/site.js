jQuery(document).ready( function() {
	imageFullResize();
	startSearch();
});
jQuery(document).on( 'ImgCollectApi-SUCCESS', function() {
	imageFullResize();
})
jQuery(window).resize( function(){
	imageFullResize()
});
function imageFullResize() {
	jQuery( '.image-full' ).each( function(){
		var h = jQuery( 'img', this ).height();
		h = ( h < 300 ) ? 300 : h;
		jQuery( this ).height( h );
		jQuery( '.metadata', this ).css({
			'max-height': h
		});
	});
}
function startSearch() {
	search = new ImgCollectSearch();
	search.build();
}