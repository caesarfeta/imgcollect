function RecentActivity() {
	if ( arguments.callee.me ) {
		return arguments.callee.me;
	}
	arguments.callee.me = this;
	
	this.start = function() {
		$.ajax({
			dataType: "json",
			url: this.query,
			timeout: 10*1000,
			success: function( data ) {},
			error: function( e ) {}
		})
	},
	
	this.query = "\
		PREFIX image: <http://localhost/sparql_model/image#>\
		PREFIX col: <http://localhost/sparql_model/collection#>\
		PREFIX users: <http://data.perseus.org/sosol/users/>\
		SELECT ?s\
		WHERE { \
			{ ?s image:edited ?o.\
			  ?s ?p users:Adam%20Tavares }\
			UNION \
			{ ?s col:edited ?o.\
			  ?s ?p users:Adam%20Tavares }\
		} ORDER BY DESC( ?o )\
	"
}