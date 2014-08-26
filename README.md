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
 
	My start...
	rails generate model Image name:text path:text original:text thumb:text license:integer copyright:integer uploaded_by:integer

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



## Brainstorming
When a parameter is set the triple-store needs to update.

Triplestore | Ruby Class
predicates  |  attribute

Ruby Class becomes the one point of entry...

Collection < ActiveTriple < SPARQL:Client

### Image Conversion
Image conversion

### Metadata
Metadata extraction from the image file
EXIF
XMP

### Collections
Collections should be nestable.





### Upload Testing
UploadUtils.upload( "/usr/local/imgcollect/rails3/test/fixtures/collection_images/desert1.JPG", "http://localhost:3000/image/upload" )

### Exif Testing
ImgMeta.exif( "/usr/local/imgcollect/rails3/test/fixtures/collection_images/desert1.JPG" )
ImgMeta.xmp( "/usr/local/imgcollect/rails3/test/fixtures/collection_images/desert1.JPG" )
ImgMeta.triples( "<urn:imgcollect:img.3>", "/usr/local/imgcollect/rails3/test/fixtures/collection_images/desert1.JPG" )

### Sparql Queries
s = SparqlQueries.new
s.keywords
s.collections



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


http://infolab.stanford.edu/~stefan/daml/order.html

	Representing Order in RDF


# Quickie Presentation

## Imgcollect

Rails3 >> Apache Jena Fuseki >> Filesystem

1. Rails3 supplies the interface GUI and API.
2. Jena-Fuseki stores the image metadata.
3. Image files are stored on some filesystem.
For flexibility the three components can be on different hosts.

Doesn't have an interface.

Upload
	PNG, JPEG, GIF, TIFF, ZIP

It will unzip a file and pull out all relevant formats.
It saves uploaded files to the filesystem.
Converts images like TIFFs to a more usable format.
Builds thumbnails to make any search interface a bit more pleasant.
Pulls EXIF data
	* GPS
	* Camera settings
	* Group images into collections.
		* and collections into collections into collections.

Outstanding issues && Points of concern
	* How do we make images usable by other systems and services while respecting copyright and access restrictions
	* Integrating a shared login to use the system
	* If it ever gets popular hosting costs could get expensive




    
# Alex - Library meeting

MIRA >> Homegrown 
extends Fedora

Required fields
	* Title
	* Displays in Portal

Image sizes
	* thumb 120
	* basic 600
	* advanced 2816
	* original

Ontology
	dc: http://dublincore.org/documents/dces/
	mira: https://wikis.uit.tufts.edu/confluence/display/MIRADataDictionary/Element+Quick+Sheet
	exif: http://www.kanzaki.com/ns/exif#





# Unit testing

	cd /usr/local/imgcollect/rails3

Run a single test class.

	rake test test/unit/api_test.rb

Run a single test.

	ruby -I "lib:test" test/unit/api_test.rb -n test_collection_image_sequence



# Load Quality Test Data



# How do I secure fuseki?

http://www.epimorphics.com/web/wiki/simple-security-fuseki



# Crop mini_magick

mini_magick

http://maxivak.com/crop-and-resize-an-image-using-minimagick-ruby-on-rails/


# Running this error
SocketError (getaddrinfo: nodename nor servname provided, or not known):
  app/controllers/image_controller.rb:131:in `block in upload'
  app/controllers/image_controller.rb:121:in `each'
  app/controllers/image_controller.rb:121:in `upload'

