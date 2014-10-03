/* require jslib/src/js/StringExt.js */

ImgCollectSearch = function() {
	this.utils = new ImgCollectUtils();
	this.build();
}
ImgCollectSearch.prototype.history = [];
ImgCollectSearch.prototype.historyIndex = 0;
ImgCollectSearch.prototype.events = {
	success: 'ImgCollectSearch-SUCCESS',
	error: 'ImgCollectSearch-ERROR',
	search: 'ImgCollectSearch-SEARCH',
}
ImgCollectSearch.prototype.results = [];
ImgCollectSearch.prototype.config = {}

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
	jQuery( 'body' ).prepend( searchbox );
	this.start();
}

/**
 * Build the search hints
 *
 * @param { String } _input
 */
ImgCollectSearch.prototype.autocomplete = function( _input ) {
	var val = _input.val();
	if ( val == null ) {
		this.autocompleteRemove();
		return;
	}
	var arr = val.shellArgs();
	if ( arr.length < 2 ) {
		this.autocompleteRemove();
		return;
	}
	var model = this.modelSlack( arr[0] );
	var attr = ImgCollectConfig.config[ model ].attributes;
	var matches = [];
	for ( var key in attr ) {
		if ( key.indexOf( arr[1] ) == 0 ) {
			matches.push( key );
		}
	}
	this.autocompleteDisplay( matches );
}

/**
 * Autocomplete display
 *
 * @param { Array } _matches
 */
ImgCollectSearch.prototype.autocompleteDisplay = function( _matches ) {
	this.autocompleteRemove();
	jQuery( '#imgcollect_search #input' ).before( '\
		<div id="autocomplete"></div>\
		<div class="clearfix"></div>' 
	);
	for ( var i=0; i<_matches.length; i++ ) {
		this.autocompleteDisplayItem( _matches[i] );
	}
}

/**
 * Remove autocomplete element
 */
ImgCollectSearch.prototype.autocompleteRemove = function() {
	jQuery( '#imgcollect_search #autocomplete' ).remove();
}

/**
 * Autocomplete display item
 *
 * @param { String } _item
 */
ImgCollectSearch.prototype.autocompleteDisplayItem = function( _item ) {
	var item = '<div>'+_item+'</div>'.smoosh();
	jQuery( '#imgcollect_search #autocomplete' ).prepend( item );
}

/**
 * Start the search box UI event listeners
 */
ImgCollectSearch.prototype.start = function() {
	var self = this;
	var input = jQuery( '#imgcollect_search #input' );

	//  Enter key is as good as pressing Go! button
	input.keydown( function( _e ) {
		switch ( _e.which ) {
			case 13: // Enter key
				self.search( input.val() );
				_e.preventDefault();
				break;
			case 38: // Up key
				self.navHistory('up');
				_e.preventDefault();
				break;
			case 40: // Down key
				self.navHistory('down'); 
				_e.preventDefault();
				break;
		}
	});

	//  Auto complete search
	input.keyup( function( _e ) {
		switch ( _e.which ) {
			case 13:
			case 38:
			case 40:
				break;
			default:
				self.autocomplete( input );
				break;
		}
	});

	//  Click the Go! button?
	jQuery( '#imgcollect_search #click').on( 'touchstart click', function( _e ) {
		_e.preventDefault();
		self.search( input.val() );
	});
}

/**
 * Browse navigation history
 */
ImgCollectSearch.prototype.navHistory = function( _dir ) {
	switch( _dir ) {
		case 'down':
			this.historyIndex++;
			this.historyIndex = ( this.historyIndex >= this.history.length ) ? this.history.length-1 : this.historyIndex;
			break;
		case 'up':
			this.historyIndex--;
			this.historyIndex = ( this.historyIndex < 0 ) ? 0 : this.historyIndex;
			break;
	}
	var search = this.history[ this.historyIndex ];
	var input = jQuery( '#imgcollect_search #input' );
	input.focus();
	input.val( search );
}

/**
 * Update history
 */
ImgCollectSearch.prototype.historyUpdate = function( _search ) {
	this.history.push( _search );
	this.historyIndex = this.history.length-1;
}

/**
 * Query the SPARQL endpoint
 * 
 * @param { string } The search command as entered in the input field
 */
ImgCollectSearch.prototype.search = function( _search ) {
	var self = this;
	
	// Clear previous search results
	self.utils.clearResults();

	//  Remove the autocomplete element
	self.autocompleteRemove();

	//  Update the history
	self.historyUpdate( _search );

	//  Mark the search
	// self.utils.mark( 'search', _search );

	//  Do a bit of validation
	//  There should be three distinct groups
	if ( _search == null ) {
		jQuery( document ).trigger( self.events.error );
	}
	var args = _search.shellArgs()
	if ( args.length < 3 ) {
		jQuery( document ).trigger( self.events.error );
	}
	var query = self.buildQuery( args[0], args[1], args[2] );
	jQuery.ajax({
		dataType: "json",
		url: query,
		timeout: 10*1000, // 10 second timeout
		success: function( data ) {
			self.results.push( self.utils.sparql_results( data ) );
			jQuery( document ).trigger( self.events.success );
		},
		error: function( e ) {
			jQuery( document ).trigger( self.events.error );
		}
	});
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
	
	//  Determine the prefix
	var prefixes = this.searchPrefixes( _model );

	//  Get the predicate value
	var pred = this.fullPred( _model, _pred );

	//  Build the query
	var query = prefixes+'\
		SELECT ?s\
		WHERE {\
			?s '+pred+' ?o;\
			FILTER regex( ?o, "'+_search+'", "i" )\
		}\
	';
	return this.utils.sparql_query( query );
}

/**
 * Get the appropriate predicate value
 *
 * @param { string } _model
 * @param { string } _pred
 */
ImgCollectSearch.prototype.fullPred = function( _model, _pred ) {
	var model = this.modelSlack( _model );
	var attr = ImgCollectConfig.config[ model ].attributes;
	return attr[_pred.keyMe()][0];
}

/**
 * Which prefixes to we prepend to the SPARQL query?
 *
 * @param { string } _model
 */
ImgCollectSearch.prototype.searchPrefixes = function( _model ) {
	var model = this.modelSlack( _model );
	var output = [];
	var prefixes = ImgCollectConfig.config[ model ].prefixes;
	for ( var key in prefixes ) {
		output.push( "PREFIX "+key+": "+prefixes[key] );
	}
	return output.join("\n");
}

/**
 *  Cut the user some slack when deciding the model
 *
 * @param { string } _model
 */
ImgCollectSearch.prototype.modelSlack = function( _model ) {
	switch ( _model ) {
		case 'image':
		case 'img':
		case 'i':
			return 'image';
		case 'collection':
		case 'coll':
		case 'col':
		case 'c':
			return 'collection';
		case 'subregion':
		case 'subreg':
		case 'sub':
		case 's':
			return 'subregion';
		default:
			jQuery( document ).trigger( this.events.error );
			return;
	}
}