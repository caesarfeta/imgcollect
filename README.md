# imgcollect
imgcollect is used for organizing images.  Can be used in conjunction with imgspect.  Metadata about image

## Built with...
Rails 3
Apache Jena Fuseki

## Installation
See INSTALL.md

## Models
* Image
	* attributes
		* id ( int )
		* batch ( bool )
		* name ( string )
		* directory ( string )
		* url ( string )
		* original_filename ( string )
		* filename ( string )
		* uploaded_by ( int )
		* upload_date ( date )
		* license ( int )
		* keywords [] ( int )
		* latitude ( float )
		* longitude ( float )
	* methods
	
* Keyword
	* attributes
		* id
		* keyword ( string )
		* first_instance
	* methods
	
* Collection
	* attributes
		* id
		* created_by
		* creation_date
		* name ( string )
		* images
		* group
	* methods
	
* Group
	* attributes
		* id
		* name ( string )
		* users [] ( int )
	* methods
	
* User
	* attributes
		* id
		* name ( string )
	* methods
	
* License
	* attributes
		* id
		* name ( string )
		* content ( string )
	* methods

## Features
	Upload image.
		filesystem
			single
			batch
		URL

	Create a collection.

	Add image to collection.

## Configuration
	Fuseki port ex. 8080, 3030
		fuseki_port: 8080
		
	Fuseki url ex. http://localhost
		fuseki_url: http://localhost
		
	Image library root path
		lib_root: /usr/local/imgcollect

## Debugging Testing
Bring up the Rails console.

	cd /usr/local/imgcollect/rails3
	rails console development

## Resources
https://github.com/datagraph/spira

	Spira -- use RDF.rb repositories as model objects.
	See rails3/app/models/image.rb

http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals

	Ruby syntax reference
