var api = null;
var search = null;
var input = null;

var wait = 0;
var loaded = 0;

/**************************
 * Get ready...
 **************************/
jQuery( document ).on( 'ImgCollectConfig-READY', function() {
	search = new ImgCollectSearch();
	api = new ImgCollectApi();
	input = new ImgCollectInput();
	uploadPop();
});

jQuery( document ).ready( function(){
	new ImgCollectConfig();
});

jQuery( window ).resize( function(){
	imageFullResize();
});

/**************************
 * API event listeners
 **************************/
jQuery( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {
	//------------------------------------------------------------
	//  Check the context of the API call
	//------------------------------------------------------------
	if ( _data['context'] != 'ImgCollectSearch' ) {
		return;
	}
	//------------------------------------------------------------
	//  Append the search results data
	//------------------------------------------------------------
	var data = jQuery( api.data );
	jQuery('#results').append( data );
	//------------------------------------------------------------
	//  Create an input listener
	//------------------------------------------------------------
	input.start( data );
	loaded++;
	//------------------------------------------------------------
	//  When all the results and images are loaded...
	//------------------------------------------------------------
	if ( loaded == wait ) {
		var imageloads = [];
		jQuery('#results').find("img").each(function () {
			var dfd = jQuery.Deferred();
				jQuery(this).on('load', function () {
				    dfd.resolve();
				});
				//------------------------------------------------------------
				// Is image  cached?
				//------------------------------------------------------------
				if ( this.complete ) {
				    jQuery( this ).trigger('load');
				}
				imageloads.push(dfd);
		});
	    jQuery.when.apply(undefined, imageloads).done( function () {
			imageFullResize();
			jQuery.scrollToBottom(.5);
		});
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
		api.send( arr[0], 'full', { 'id': arr[1] }, 'ImgCollectSearch' );
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
		var height = jQuery( '.display', this ).height();
		height = ( height < 300 ) ? 300 : height;
		jQuery( this ).height( height );
		jQuery( '.metadata', this ).css({
			'height': height
		});
	});
}

/**
 * Upload pop-up
 */
function uploadPop() {
	jQuery( '#uploader' ).on( 'touchstart click', function( _e ) {
		$('#myModal').foundation('reveal', 'open');
	});
	//$('#myModal').foundation('reveal', 'close');
}

/* Playing with update
api.send( 'image', 'update', { id: 5, name: 'North American Desert' });
api.send( 'image', 'add', { id: 5, keywords: 'desert' });
*/