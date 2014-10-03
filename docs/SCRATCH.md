# 2014-08-26
Fix subregion saving.

To open an image in imgspect.
	http://localhost:3000/imgspect/urn/cite/perseus/memory/1

## 2014-10-03
Build recent-activity page.

First get the user's recent-activity...

http://127.0.0.1:4321/sparql.tpl

PREFIX image: <http://localhost/sparql_model/image#>
PREFIX col: <http://localhost/sparql_model/collection#>
PREFIX users: <http://data.perseus.org/sosol/users/>
SELECT ?s
WHERE { 
	{ ?s image:user users:Adam%20Tavares }
	UNION 
	{ ?s col:user users:Adam%20Tavares }
}

Or expressed more succinctly...

PREFIX users: <http://data.perseus.org/sosol/users/>
SELECT ?s 
WHERE { 
	{ ?s ?p users:Adam%20Tavares }
}

With a SELECT...

PREFIX image: <http://localhost/sparql_model/image#>
PREFIX users: <http://data.perseus.org/sosol/users/>
SELECT ?s ?p ?o
WHERE { 
	SELECT ?s WHERE { ?s ?p users:Adam%20Tavares . }
}

Get Edit in order...

PREFIX image: <http://localhost/sparql_model/image#>
PREFIX col: <http://localhost/sparql_model/collection#>
PREFIX users: <http://data.perseus.org/sosol/users/>
SELECT ?s ?p ?o
WHERE { 
	{ ?s image:edited ?o.
	  ?s ?p users:Adam%20Tavares }
	UNION 
	{ ?s col:edited ?o.
	  ?s ?p users:Adam%20Tavares}
} ORDER BY DESC( ?o )

This can probably be rewritten...

PREFIX image: <http://localhost/sparql_model/image#>
PREFIX col: <http://localhost/sparql_model/collection#>
PREFIX users: <http://data.perseus.org/sosol/users/>
SELECT ?s
WHERE { 
	{ ?s image:edited ?o.
	  ?s ?p users:Adam%20Tavares }
	UNION 
	{ ?s col:edited ?o.
	  ?s ?p users:Adam%20Tavares }
} ORDER BY DESC( ?o )

I think this will work...