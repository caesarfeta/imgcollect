var api = null;
var search = null;
var input = null;
var perseids = null;
var utils = null;
var wait = 0;
var loaded = 0;

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
	new ImgCollectUpload();
	uploadPop();
	perseids = new ImgCollectPerseids();
	perseids.start();
	utils.masonry()
});


//  Whoop there's an error
$( document ).on( 'ImgCollectConfig-ERROR', function() {
	alert( 'Could not contact ImgCollect server.' );
});
$( document ).on( 'ImgCollectApi-ERROR', function( _e, _data ) {
	// console.log( _data['error'] );
});

/**************************
 * API event listeners
 **************************/
$( document ).on( 'ImgCollectApi-SUCCESS', function( _e, _data ) {

	//  Check the context of the API call
	if ( _data['context'] != 'LoadFull' ) {
		return;
	}

	//  Hide the upload window if its open
	uploadHide();

	//  Append the search results data
	var data = $( _data['data'] );
	utils.wall.append( data );

	//  Create an input listener
	input.start( data );
	col.activate( data );
	loaded++;
	
	//  When all the search results are loaded...
	if ( loaded == wait ) {
//		masonrify();
		var imageloads = [];
		$( '#results' ).find( 'img' ).each(function () {
			var dfd = $.Deferred();
				$( this ).on( 'load', function () {
				    dfd.resolve();
				});

				// Is image cached?
				if ( this.complete ) {
				    $( this ).trigger( 'load' );
				}
				imageloads.push( dfd );
		});

		//  Scroll to bottom again after all the images load
	    $.when.apply( undefined, imageloads ).done( function () {
			$( document ).trigger( 'ImgsLoaded-START' );
			masonrify();
		});
	}
});

/**************************
 * Search event listeners
 **************************/

/**
 * If search results are returned retrieve them!
 */
$( document ).on( 'ImgCollectSearch-SUCCESS', function() {
	
	// Retrieve the search results
	var results = search.results[ search.results.length-1 ];
	wait = results.length;
	loaded = 0;
	
	// Add pagination
	var per_page = 10;
	var p = pages( results, per_page );
	
	// Remove paginator UI
	if ( p > 1 ) {
		// Add paginator UI
	}
	search_get( results.slice(0,per_page-1) );
});

function paginator_remove() {}

function paginator_add() {}

function search_get( items ) {
	for ( var i=0; i<items.length; i++ ) {
		var arr = items[i].split('.');
		api.get( arr[0], arr[1] );
	}
}

function pages( results, per_page ) {
	return Math.ceil( results.length / per_page );
}

function masonrify() {
	utils.wall.masonry( 'reloadItems' );
	utils.wall.masonry( 'layout' );
}

/**
 * Welcome screen pop-up
 */
function welcome() {
	$( '#welcomeModal' ).foundation( 'reveal', 'open' );
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