/* require jslib/src/js/StringExt.js */

ImgCollectSearch = function() {}
ImgCollectSearch.prototype.endpoint = 'http://127.0.0.1:8080/ds/query';
ImgCollectSearch.prototype.events = {
	success: 'ImgCollectSearch-SUCCESS',
	error: 'ImgCollectSearch-ERROR',
	search: 'ImgCollectSearch-SEARCH',
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
 * 
 * @param { string } The search command as entered in the input field
 */
ImgCollectSearch.prototype.search = function( _search ) {
	var self = this;
	jQuery( document ).trigger( self.events['search'], { search: _search } );
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
 * @return { json } Simplified results
 */
ImgCollectSearch.prototype.cleanResults = function( _results ) {
	var vals = _results['results']['bindings'];
	var clean = [];
	for ( var i=0; i<vals.length; i++ ) {
		clean.push(vals[i]['s']['value'].replace("urn:sparql_model:",""));
	}
	return clean;
}

/**
 * Clean up the results
 *
 * @param { string } _model The name of model ( 'image', 'collection', etc )
 * @param { string } _pred The model's predicate/key name
 * @param { string } _search The model object search value
 * @return { string } The SPARQL endpoint query
 */
ImgCollectSearch.prototype.buildQuery = function( _model, _pred, _search ) {
	//------------------------------------------------------------
	//  TODO: better Prepare predicate value
	//------------------------------------------------------------
	//------------------------------------------------------------
	//  Determine the prefix
	//  TODO: Retrieve prefix lookup table from Rails...
	//------------------------------------------------------------
	var prefix = this.whichPrefix( _model, _pred );
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

/**
 * Escape the query uri including any # characters
 *
 * @param { string } _uri The uri
 */
ImgCollectSearch.prototype.escapeURI = function( _uri ) {
	//------------------------------------------------------------
	//  %23 is the url encoding for a hash.
	//  encodeURI ignores it.
	//------------------------------------------------------------
	return encodeURI( _uri ).replace( '#', '%23' );
}

/**
 * Which prefixes to we prepend to the SPARQL query?
 */
ImgCollectSearch.prototype.whichPrefix = function( _model ) {
	var prefix = 'PREFIX this: ';
	switch ( _model ) {
		case 'image':
		case 'img':
			prefix += '<http://localhost/sparql_model/image#>';
			return prefix;
		case 'collection':
		case 'coll':
		case 'col':
			prefix += '<http://localhost/sparql_model/collection#>';
			return prefix;
		default:
			jQuery( document ).trigger( this.events['error'] );
			return;
	}
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