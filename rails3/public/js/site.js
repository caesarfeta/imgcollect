var api = null;
var search = null;
var input = null;
var wait = 0;
var loaded = 0;

/**************************
 * Get ready...
 **************************/
//------------------------------------------------------------
//  Set Dropzone options
//------------------------------------------------------------
Dropzone.autoDiscover = false;
Dropzone.options.dropzone = {
	createImageThumbnails: false
}

//------------------------------------------------------------
//  Get the config.
//------------------------------------------------------------
jQuery( document ).ready( function(){
	new ImgCollectConfig();
});

//------------------------------------------------------------
//  When the config is ready.
//------------------------------------------------------------
jQuery( document ).on( 'ImgCollectConfig-READY', function() {
	search = new ImgCollectSearch();
	api = new ImgCollectApi();
	input = new ImgCollectInput();
	new ImgCollectUpload();
	new ImgCollectCol();
	uploadPop();
});

//------------------------------------------------------------
//  Whoop there's an error
//------------------------------------------------------------
jQuery( document ).on( 'ImgCollectConfig-ERROR', function() {
	alert( 'Could not contact ImgCollect server.' );
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
	if ( _data['context'] != 'LoadFull' ) {
		return;
	}
	//------------------------------------------------------------
	//  Hide the upload window if its open
	//------------------------------------------------------------
	uploadHide();
	//------------------------------------------------------------
	//  Append the search results data
	//------------------------------------------------------------
	var data = jQuery( _data['data'] );
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

jQuery( document ).on( 'ImgCollectApi-ERROR', function( _e, _data ) {
	console.log( _data['error'] );
});

/**************************
 * Search event listeners
 **************************/
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
		api.get( arr[0], arr[1] );
	}
});

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
	jQuery( '.modal' ).on( 'touchstart click', function( _e ) {
		var selector = jQuery( this ).attr('data-reveal-id');
		jQuery('#'+selector).foundation('reveal', 'open');
	});
}

/**
 * Upload hide
 */
function uploadHide() {
	jQuery('#imageModal').foundation('reveal', 'close');
	jQuery('#collectionModal').foundation('reveal', 'close');
}

/* 
>> Playing with update <<
api.send( 'image', 'update', { id: 5, name: 'North American Desert' });
api.send( 'image', 'add', { id: 5, keywords: 'desert' });
*/