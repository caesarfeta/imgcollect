var api = null;
var search = null;
var input = null;
var perseids = null;
var utils = null;
var recent = null;
var upload = null;

var per_page = 10;
var results = [];

/**************************
 * Get ready...
 **************************/

//  Set Dropzone options
Dropzone.autoDiscover = false;
Dropzone.options.dropzone = {
	createImageThumbnails: false
}

//  Get the config.
$( document ).ready( function(){
	new ImgCollectConfig();
});

//  When the config is ready.
$( document ).on( 'ImgCollectConfig-READY', function() {
	welcome();
	utils = new ImgCollectUtils();
	search = new ImgCollectSearch();
	api = new ImgCollectApi();
	input = new ImgCollectInput();
	col = new ImgCollectCol();
	upload = new ImgCollectUpload();
	uploadPop();
	
	// Get Perseids user
	perseids = new ImgCollectPerseids();
	perseids.start();
	
});

$( document ).on( 'ImgCollectConfig-ERROR', function() {
	console.log( 'Could not contact ImgCollect server.' );
});
$( document ).on ('ImgCollectPerseids-SUCCESS', function() {
	// Get recent user activity
	recent = new RecentActivity();
	
	// Home button is clicked recent activity shows up
	$( '#homeButton' ).on( 'touchstart, click', function() {
		utils.clearResults();
		recent.start();
	})
});

/**************************
 * API event listeners
 **************************/
$( document ).on( 'ImgCollectApi-ERROR', function( e, data ) {
	console.log( data['error'] );
});

$( document ).on( 'ImgCollectApi-SUCCESS', function( e, data ) {

	//  Check the context of the API call
	if ( data['context'] != 'LoadFull' ) {
		return;
	}

	//  Hide the upload window if its open
	uploadHide();

	//  Append the search results data
	data = $( data['data'] );
	utils.wall.append( data );

	//  Create an input listener
	input.start( data );
	col.activate( data );
	
	$( document ).trigger( 'ImgsLoaded-START' );
});

/**************************
 * Search event listeners
 **************************/
/**
 * If search results are returned retrieve them!
 */
$( document ).on( 'ImgCollectSearch-SUCCESS', function() {
	get_items( search.results[ search.results.length-1 ] );
});
$( document ).on( 'RecentActivity-SUCCESS', function() {
	get_items( recent.results[ recent.results.length-1 ] );
})

function get_items( search_results ) {
	// Clear the old results
	utils.clearResults();
	
	// Retrieve the search results
	results = search_results;
	
	// Add pagination
	var p = pages( results, per_page );
	
	// Reset wait load and current_page schtuff.
	current_page = 0;
	
	// Remove paginator UI
	paginator_remove();
	if ( p > 1 ) {
		// Add paginator UI
		paginator_add( p );
	}
	search_get( current_page );
}

function paginator_remove() {
	$('#paginator').remove();
}

function paginator_add( pages ) {
	$('body').append('\
		<div id="paginator">\
			<div class="smaller">pages</div>\
			<div class="inner"></div>\
		</div>'
	);	
	for (var i=1; i<= pages; i++) {
		$('#paginator .inner').append('<a data-pageid="'+i+'" href="">'+i+'</a>');
	}
	$('#paginator a[data-pageid="1"]').addClass('selected');
	$('#paginator a').on('touchstart click', function(e) {
		e.preventDefault();
		$('#paginator a').removeClass('selected');
		$(this).addClass('selected');
		var page = parseInt($(this).attr('data-pageid'))-1;
		utils.clearResults();
		search_get( page );
	});
}

function search_get( page ) {
	var start = page*per_page;
	var end = start+per_page-1;
	var items = results.slice(start,end);
	for ( var i=0; i<items.length; i++ ) {
		var arr = items[i].split('.');
		api.get( arr[0], arr[1] );
	}
}

function pages( results, per_page ) {
	return Math.ceil( results.length / per_page );
}

/**
 * Welcome screen pop-up
 */
function welcome() {
	$( '#welcomeModal' ).foundation( 'reveal', 'open' );
	$( document ).on( 'closed.fndtn.reveal', '[data-reveal]', function() {
		if ( recent.shown == false ) {
			recent.start();
			recent.shown = true;
		}
	});
}

/**
 * Upload pop-up
 */
function uploadPop() {
	$( '.modal' ).on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		var selector = $( this ).attr( 'data-reveal-id' );
		$( '#'+selector ).foundation( 'reveal', 'open' );
	});
}

/**
 * Upload hide
 */
function uploadHide() {
	$( '#imageModal' ).foundation( 'reveal', 'close' );
	$( '#collectionModal' ).foundation( 'reveal', 'close' );
}