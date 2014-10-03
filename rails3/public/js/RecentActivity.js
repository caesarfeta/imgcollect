function RecentActivity() {
	if ( arguments.callee.me ) {
		return arguments.callee.me;
	}
	arguments.callee.me = this;
	this.utils = new ImgCollectUtils();
	this.results = [];
	this.events = {
		success: 'RecentActivity-SUCCESS',
		error: 'RecentActivity-ERROR'
	};
	this.error = null;
	this.results = [];
	this.shown = false;
	this.perseids = new ImgCollectPerseids();
	
	this.start = function() {
		var self = this;
		$.ajax({
			dataType: "json",
			url: self.utils.sparql_query( self.query ),
			timeout: 10*1000,
			success: function( data ) {
				self.results.push( self.utils.sparql_results( data ) );
				self.error = null;
				$( document ).trigger( self.events['success'] );
			},
			error: function( e ) {
				self.error = e;
				$( document ).trigger( self.events['error'] );
			}
		})
	},
	
	this.query = "\
		PREFIX image: <http://localhost/sparql_model/image#>\
		PREFIX col: <http://localhost/sparql_model/collection#>\
		PREFIX users: <http://data.perseus.org/sosol/users/>\
		SELECT ?s\
		WHERE { \
			{ ?s image:edited ?o.\
			  ?s ?p users:"+this.perseids.short_user+" }\
			UNION \
			{ ?s col:edited ?o.\
			  ?s ?p users:"+this.perseids.short_user+" }\
		} ORDER BY DESC( ?o )"
}