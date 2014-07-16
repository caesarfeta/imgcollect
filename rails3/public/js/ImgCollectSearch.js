ImgCollectSearch = function() {}

ImgCollectSearch.prototype.build = function() {
	var searchbox = '\
	<div id="imgcollect_search">\
		<div class="wrapper">\
			<input id="input" type="text" placeholder="search terms">\
			<a class="button dark tiny" href="" id="searchClick">Go!</a>\
		</div>\
	</div>';
	jQuery( 'body' ).append( searchbox );
}

/*
//------------------------------------------------------------
//  Sparql Queries
//------------------------------------------------------------

*/