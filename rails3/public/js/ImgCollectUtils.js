/* require jslib/src/js/TimeStamp.js */

function ImgCollectUtils() {
	if ( arguments.callee.me ) {
		return arguments.callee.me;
	}
	arguments.callee.me = this;
	this.timestamp = new TimeStamp();
	
	/**
	 * Mark what you've done.
	 */
	this.mark = function( type, search ) {
		$( '#results' ).append( '\
			<div class="row">\
				<div class="columns small-12">\
					<h2 class="search_string">\
						<span class="smaller time_of_day">'+this.timestamp.timeOfDay()+'</span>\
						<span class="smaller">'+type+':</span> '+search+'\
					</h2>\
				</div>\
			</div>' 
		);
		$.scrollToBottom( .5 );
	}
	
	/**
	 * "Clear" the results
	 */
	this.clearResults = function() {
		$( '#results > *' ).hide();
	}
}