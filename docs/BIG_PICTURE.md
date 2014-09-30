# Big Picture
* Images are harder to host than text.
* Byte size is the primary factor.
	* Size in bytes == byte size.
* TIFF file format is preferred by archivists and librarians.
* TIFF has problems when it comes to usability.
* It is not natively supported by most web browsers.
* Web browsers prefer compressed file formats like JPEG.
	* They are easier to transmit over a network because of their reduced byte size.
* An image file is more than the image.
	* Many image file formats store associated metadata.
* Lots of image capture devices store useful metadata about images in the image file as EXIF metadata.
* EXIF metadata
	* GPS coordinates
	* Timestamp
	* Technical data about camera make and model and its settings.
* EXIF metadata should be extracted and made searchable.

## Suggestion
* Store TIFF files for archive purposes.
	* There are lossless JPEG formats which produce the same quality with fewer bytes.
	* TIFF flexibility is also a liability.
		* The TIFF format is actually a wrapper for a variety of compressed and uncompressed image formats.
		
## Use JPEGs of various sizes in browser UIs.
* Searches of collections of images are most useful when images can be reviewed side-by-side or in a grid at a meaningful resolution.
* Not having this limits UIs for working with images.
* Image conversion, resizing, and hosting service needs to be created.
	* Allows for UI innovation.
	
## Even compressed JPEGs can be expensive to host.
### Imgcollect to the rescure!
* Academic institutions need a more distributed image hosting system.
	* Lightweight servers, we'll call them "drones", are created to support a specific project or research group.
		* Drones must be publicly accessible and easily deployed.
	* Images and metadata are stored on drone server.
		* They handle image conversion, resizing, and metadata extraction.
	* Images can be grouped together into collections on drone server.
	* Images and collections are published when their metadata is sent to the "Mother-Brain"
		* The Mother-Brain is a graph database.
			* SPARQL queryable endpoint
		* Mother-Brain holds searchable metadata.
		* Mother-Brain should be managed by library.
	* Images continue to be hosted by a drone.

* What do we do when a drone is decommisioned?
	* Their images and complete metadata must be hosted somewhere.
	* Mother-Brain must be updated.

	All data produced by imgcollect must be easily machine readable!

## Prominent Image Hosting/Archiving Applications
Google Image Search
Flickr
Facebook
Pinterest

## Peer-to-peer CDNs
Most commercial applications use peer-to-peer CDNs ( Content delivery networks ).



## Replacing
http://sosol.perseids.org/collections/

Controls the mapping in Sosol.
https://github.com/caesarfeta/imgcollect/blob/deployment/rails3/public/js/ImgCollectPerseids.js