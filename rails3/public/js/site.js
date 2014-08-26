var api = null;
var search = null;
var input = null;
var wait = 0;
var loaded = 0;
var perseids = null;

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
	search = new ImgCollectSearch();
	api = new ImgCollectApi();
	input = new ImgCollectInput();
	col = new ImgCollectCol();
	new ImgCollectUpload();
	uploadPop();
	perseids = new ImgCollectPerseids();
	perseids.start();
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
	$( '#results' ).append( data );

	//  Create an input listener
	input.start( data );
	col.activate( data );
	loaded++;
	
	//  When all the search results are loaded...
	if ( loaded == wait ) {
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

	//  Retrieve the search results
	var results = search.results[ search.results.length-1 ];
	wait = results.length;
	loaded = 0;
	for ( var i=0; i<results.length; i++ ) {
		var arr = results[i].split('.');
		api.get( arr[0], arr[1] );
	}
});

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