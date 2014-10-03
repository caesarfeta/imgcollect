/* require jslib/src/js/TimeStamp.js */

function ImgCollectUtils() {
	if ( arguments.callee.me ) {
		return arguments.callee.me;
	}
	arguments.callee.me = this;
	this.timestamp = new TimeStamp();
	this.wall = $( '#results' );
	
	/**
	 * "Clear" the results
	 */
	this.clearResults = function() {
		$( '#results > *' ).hide();
	}
	
	/**
	 * Build the sparql query
	 *
	 * @param { string } SPARQL query string
	 * @return { string } fuseki query URL
	 */
	this.sparql_query = function( query ) {
		return this.escapeURI( ImgCollectConfig.config.endpoint+"?query="+query+"&format=json" )
	}
	
	/**
	 * Clean up the results
	 *
	 * @param { json } results Values returned by jQuery ajax call
	 * @return { json } Simplified results
	 */
	this.sparql_results = function( results ) {
		var vals = results.results.bindings;
		var clean = [];
		for ( var i=0; i<vals.length; i++ ) {
			clean.push(vals[i].s.value.replace("urn:sparql_model:",""));
		}
		return clean;
	}
	
	/**
	 * Escape the query uri including any # characters
	 *
	 * @param { string } _uri The uri
	 */
	this.escapeURI = function( _uri ) {
		//  %23 is the url encoding for a hashmark.
		//  encodeURI ignores it.
		return encodeURI( _uri ).replace( /#/g, '%23' );
	}
}