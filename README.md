# imgcollect
imgcollect is used for organizing images.  Can be used in conjunction with imgspect.  Metadata about image

## Built upon...
Rails 3
Apache Jena Fuseki

## Installation
See INSTALL.md





# Planning...
## Lib
* ImageSearch
* CollectionSearch
* ImageUpload

## Models
* Image << RDF
	* attributes
		* id ( int )
		* batch ( bool )
		* name ( string )
		* directory ( string )
		* url ( string )
		* original_filename ( string )
		* filename ( string )
		* uploaded_by ( User )
		* upload_date ( date )
		* license ( License )
		* keywords [] ( Keyword )
		* latitude ( float )
		* longitude ( float )
		** All that other EXIF data I can extract **
	* methods
		* create
		* update
		* delete
		
		* addKeyword
		* removeKeyword
	
* Collection << RDF
	* attributes
		* id ( int )
		* created_by ( User )
		* creation_date ( date )
		* name ( string )
		* images [] ( Image )
		* group ( Group )
		* parent ( Collection )
		* children ( Collection )
	* methods
		* create
		* update
		* delete
		
		* addImg
		* removeImg
		
		* addGroup
		* removeGroup
		
		* addSubcollection
		* removeSubcollection

* Keyword << RDF
	* attributes
		* id ( int )
		* keyword ( string )
	* methods
		* create
		* update
		* delete

* Group << SQL
	* attributes
		* id ( int )
		* name ( string )
		* users [] ( User )
	* methods
		* create
		* update
		* delete
	
* User << SQL
	* attributes
		* id ( int )
		* name ( string )
	* methods
		* create
		* update
		* delete
	
* License << RDF
	* attributes
		* id ( int )
		* name ( string )
		* content ( string )
	* methods
		* create
		* update
		* delete

## Actions
	[] Upload image.
		[] filesystem
			[] single
			[] batch
		[] URL

	[] Create a collection.
	[] Delete a collection.
	[] Add image to collection.
	[] Remove image from collection.
	[] Reorder images in a collection.

	[] Create a group.
	[] Delete a group.

	[] Give groups access to a collection.

	[] Search for images by keyword
	[] Search images by name

## Fuseki -- Ruby RDF connection
How to best update a triplestore served from Fuseki using SPARQL with Ruby?
I would like to use SPARQL update to add triples.
There are other methods but they aren't as flexible and don't necessarily work over HTTP.  It would definitely be nice to use a remote triplestore if I wanted.  SPARQL it is...

Here's the basics.

    data = %Q(
      PREFIX dc: <http://purl.org/dc/elements/1.1/>
      INSERT DATA {
        <http://example/book1> dc:title    "An oldish book" ;
                               dc:creator  "Dog McBug" .
      }
    )
    res = Net::HTTPSession.post_form( URI('http://localhost:8080/ds/update'), 'update' => data )
    puts res.body

I'm thinking the update class will accept a URI.  Prefixes can be added one by one using some method or another.  So it'd work like this.

	sparql = SPARQL::Update.new( 'http://localhost:8080/ds/update' )
	sparql.prefix.add( 'dc' => 'http://purl.org/dc/elements/1.1/' )
	sparql.prefix.list()
	sparql.prefix.remove( 'dc' )
	sparql.insert( 'http://domain/object', {'dc:title' => 'An oldish book', 'dc:creator' => 'Dog McBug' } )





## Configuration
	Fuseki port ex. 8080, 3030
		fuseki_port: 8080
		
	Fuseki url ex. http://localhost
		fuseki_url: http://localhost
		
	Image library root path
		lib_root: /usr/local/imgcollect





# Resources
## URLs
https://github.com/datagraph/spira

	Spira -- use RDF.rb repositories as model objects.
	See rails3/app/models/image.rb

http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals

	Ruby syntax reference
