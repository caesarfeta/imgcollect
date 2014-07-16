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
		//------------------------------------------------------------
		//  Set the height
		//------------------------------------------------------------
		var height = jQuery( 'img', this ).height();
		height = ( height < 300 ) ? 300 : height;
		jQuery( this ).height( height );
		jQuery( '.metadata', this ).css({
			'height': height
		});
		//------------------------------------------------------------
		//  Set the width
		//------------------------------------------------------------
		var width = jQuery( 'img', this ).width() + jQuery( '.metadata', this ).width();
		var win_width = jQuery( window ).width();
		if ( width > win_width ) {
			var img_width = jQuery( 'img', this ).width();
			jQuery( '.metadata', this ).css({
				'width': img_width
			});
		}
	});
}
function startSearch() {
	search = new ImgCollectSearch();
	search.build();
}