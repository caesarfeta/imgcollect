/* require jslib/src/js/TimeStamp.js */

function ImgCollectUtils() {
	if ( arguments.callee._me ) {
		return arguments.callee._me;
	}
	arguments.callee._me = this;
	this.timestamp = new TimeStamp();
	
	/**
	 * Mark what you've done.
	 */
	this.mark = function( _type, _search ) {
		jQuery( '#results' ).append( '\
			<div class="row">\
				<div class="columns small-12">\
					<h2 class="search_string">\
						<span class="smaller time_of_day">'+this.timestamp.timeOfDay()+'</span>\
						<span class="smaller">'+_type+':</span> '+_search+'\
					</h2>\
				</div>\
			</div>' 
		);
	}
}