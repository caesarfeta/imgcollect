# imgcollect
Use imgcollect for organizing your images into citeable collections for collaborative research.
It is integrated with imgspect, an image annotation transcription tool.
All image metadata & transcriptions are stored as an RDF graph, which can be queried & analyzed using a variety of tools, both custom to imgcollect & third-party.

## Features
* Drag & drop files or copy & paste urls to upload images.
* Images are saved in several sizes automatically.
* Upload several images at once with a zip file.
* Many image formats are supported.
* Metadata is extracted from images at upload time.
* Annotate images with imgspect.
* Easily search image metadata  & transcriptions with a simple, custom, query language.

## Built upon...
* Rails 3
* Apache Jena Fuseki

## Installation
See INSTALL.md

## How to use

* Add an image
	* Click the add image button in the top-right corner
	* An upload form pops-up
	* Drag and drop image or zip files over the "Drop files here to upload" area
	* Or copy &amp; past a url to an image and click "Upload"

* Update image metadata
	* If you see an edit icon near an item click it
	* Update the item text and press "Enter"
		* To enter a newline hold "Shift" &amp; press "Enter"
	* Note: not every item is editable

* Add a collection
	* Click the add collection button in the top-right corner
	* A create collection form pops-up
	* Fill out the form and click "Create"

* Search
	* There are three types of searchable items
		* image
		* collection
		* subregion
	* Here's the structure of a query
		* \[item\] \[key\] \[search\]
	* \[item\] can be abbreviated
		* i == img == image
		* c == col == collection
		* s == sub == subregion
	* When entering \[key\] you will see hints
	* Here are some example queries
		* i original file_name
		* c name 'manuscripts'

* Add an image to a collection
	* Create or search for a collection
	* Click "Select" button to activate collection
		* Notice the pink box in the upper left corner with the collection name
	* Now when image search results are returned they will have a pink "Add" button
	* Click the "Add" button to add an image to a collection

* CITEify a collection
	* Before images can be annotated they must be in a collection which has been given a CITE urn.
	* Search for a collection.
	* Click the collection's "CITEify" button.

* Annotate an image
	* TODO...
