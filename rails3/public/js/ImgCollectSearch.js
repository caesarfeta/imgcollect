/* require jslib/src/js/StringExt.js */

ImgCollectSearch = function() {}
ImgCollectSearch.prototype.endpoint = 'http://127.0.0.1:8080/ds/query';
ImgCollectSearch.prototype.events = {
	success: 'ImgCollectSearch-SUCCESS',
	error: 'ImgCollectSearch-ERROR'
}
ImgCollectSearch.prototype.results = [];

/**
 * Build the search box
 */
ImgCollectSearch.prototype.build = function() {
	var searchbox = '\
	<div id="imgcollect_search">\
		<div class="wrapper">\
			<input id="input" type="text" placeholder="search">\
			<a class="button dark tiny" href="" id="click">Go!</a>\
		</div>\
	</div>';
	jQuery( 'body' ).append( searchbox );
	this.start();
}

/**
 * Start the search box UI event listeners
 */
ImgCollectSearch.prototype.start = function() {
	var self = this;
	var input = jQuery( '#imgcollect_search #input' );
	input.keyup( function( _e ) {
		if ( _e.keyCode == 13 ) {
			self.search( input.val() );
		}
	});
	jQuery( '#imgcollect_search #click').on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.search( input.val() );
	});
}

/**
 * Query the SPARQL endpoint
 */
ImgCollectSearch.prototype.search = function( _search ) {
	var self = this;
	//------------------------------------------------------------
	//  Do a bit of validation.  
	//  There should be three distinct groups.
	//------------------------------------------------------------
	var args = _search.shellArgs()
	if ( args.length < 3 ) {
		console.log( 'TODO: trigger an error')
	}
	var query = self.buildQuery( args[0], args[1], args[2] );
	jQuery.ajax({
		dataType: "jsonp",
		url: query,
		timeout: 10*1000, // 10 second timeout
		success: function( _data ) {
			self.results.push( self.cleanResults( _data ) );
			jQuery( document ).trigger( self.events['success'] );
		},
		error: function( _e ) {
			jQuery( document ).trigger( self.events['error'] );
		}
	});
}

/**
 * Clean up the results
 *
 * @param { json } _results Values returned by jQuery ajax call.
 * @return { json } Cleaned up results
 */
ImgCollectSearch.prototype.cleanResults = function( _results ) {
	return _results;
}

ImgCollectSearch.prototype.buildQuery = function( _model, _pred, _search ) {
	//------------------------------------------------------------
	//  Determine the prefix
	//  TODO: Retrieve prefix lookup table from Rails...
	//------------------------------------------------------------
	var prefix = 'PREFIX this: ';
	switch ( _model ) {
		case 'image':
		case 'img':
			prefix += '<http://localhost/sparql_model/image#>';
			break;
		case 'collection':
		case 'coll':
		case 'col':
			prefix += '<http://localhost/sparql_model/collection#>';
			break;
		default:
			jQuery( document ).trigger( self.events['error'] );
			return;
	}
	//------------------------------------------------------------
	//  TODO: better Prepare predicate value
	//------------------------------------------------------------
	
	//------------------------------------------------------------
	//  Build the query
	//------------------------------------------------------------
	var query = prefix+'\
		SELECT ?s\
		WHERE {\
			?s this:'+_pred+' ?o;\
			FILTER regex( ?o, "'+_search+'", "i" )\
		}\
	';
	return this.escapeURI( this.endpoint+"?query="+query+"&format=json" );
}

ImgCollectSearch.prototype.escapeURI = function( _uri ) {
	//------------------------------------------------------------
	//  %23 is the url encoding for a hash.
	//  encodeURI ignores it.
	//------------------------------------------------------------
	return encodeURI( _uri ).replace( '#', '%23' );
}
/*

//------------------------------------------------------------
//  Sparql Queries and search bar equivalents
//------------------------------------------------------------
[ collection name "des" ]

	@prefix this: <http://localhost/sparql_model/collection>
	SELECT ?s 
	WHERE { 
		?s this:name ?o
		FILTER regex( ?o, "des", "i" )
	}
*/