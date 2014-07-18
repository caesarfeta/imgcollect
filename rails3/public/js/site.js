var api = null;
var search = null;

var wait = 0;
var loaded = 0;

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
	loaded++;
	if ( loaded == wait ) {
		jQuery.scrollToBottom(.5);
	}
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
	markSearch( _data['search'] );
});

/**
 * If search results are returned retrieve them!
 */
jQuery( document ).on( 'ImgCollectSearch-SUCCESS', function() {
	//------------------------------------------------------------
	//  Retrieve the search results
	//------------------------------------------------------------
	var results = search.results[ search.results.length-1 ];
	wait = results.length;
	loaded = 0;
	for ( var i=0; i<results.length; i++ ) {
		var arr = results[i].split('.');
		api.send( arr[0], 'full', { 'id': arr[1] });
	}
});

/**
 * Mark the search.
 */
function markSearch( _search ) {
	jQuery( '#results' ).append( '\
		<div class="row">\
			<div class="columns small-12">\
				<h2 class="search_string">\
					<span class="smaller">search:</span> '+_search+'\
				</h2>\
			</div>\
		</div>' 
	);
}

/**
 * Resize
 */
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