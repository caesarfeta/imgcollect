var api = null;
var search = null;

/**************************
 * Get ready...
 **************************/
jQuery( document ).ready( function(){
	search = new ImgCollectSearch();
	api = new ImgCollectApi();
	imageFullResize();
});
jQuery( window ).resize( function(){
	imageFullResize()
});

/**************************
 * API event listeners
 **************************/
jQuery( document ).on( 'ImgCollectApi-SUCCESS', function() {
	jQuery('#results').append( api.data );
	imageFullResize();
});
jQuery( document ).on( 'ImgCollectApi-ERROR', function() {
	console.log( api.error );
});

/**************************
 * Search event listeners
 **************************/
/**
 * Mark the search results
 */
jQuery( document ).on( 'ImgCollectSearch-SEARCH', function( _e, _data ) {
	var search = _data['search'];
	jQuery( '#results' ).append( '<h2 class="search_string"><span class="smaller">search:</span> '+search+'</h2>' );
});

/**
 * If search results are returned retrieve them!
 */
jQuery( document ).on( 'ImgCollectSearch-SUCCESS', function() {
	//------------------------------------------------------------
	//  Retrieve the search results
	//------------------------------------------------------------
	var results = search.results[ search.results.length-1 ];
	for ( var i=0; i<results.length; i++ ) {
		var arr = results[i].split('.');
		api.send( arr[0], 'full', { 'id': arr[1] });
	}
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