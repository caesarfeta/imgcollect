require_relative "../../../../sparql_model/lib/sparql_quick.rb"
include ControllerHelper

# This class contains methods for converting SparqlModel collection triples into CITE collection triples
module CiteHelper
  
  @prefixes = {
    :hmt => "<http://www.homermultitext.org/hmt/rdf/>",
    :cite => "<http://www.homermultitext.org/cite/rdf/>",
    :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
    :crm => "<http://www.cidoc-crm.org/cidoc-crm/>",
    :rdfs => "<http://www.w3.org/2000/01/rdf-schema#>"
  }
  
  # Does a cite collection exist?
  # col { Collection }
  def self.exists?( col )
    sparql = self.sparql
    if col.class == Hash
      cite_urn = col[:cite_urn].tagify
    else
      cite_urn = col.cite_urn.tagify
    end
    id_triple = [ cite_urn, "rdf:type", "cite:ImageArchive" ];
    if sparql.count( id_triple ) != 0
      return true
    end
    false
  end
  
  # Take a SparqlModel collection and write CITE collection triples from it
  # col { Collection }
  def self.create( col )
    
    # Make sure you have what you need to to CITE-ify a collection
    self.check( col )
    
    # Does a cite collection exist?
    if self.exists?( col )
      raise 'This collection has already been CITE-ified'
    end
    
    # This could point at a different sparql_endpoint if need be
    sparql = self.sparql
    cite_urn = col.cite_urn.tagify
    id_triple = [ cite_urn, "rdf:type", "cite:ImageArchive" ];
    
    # First things first... mark the collection as a CITE collection
    # and add all the necessary metadata
    sparql.insert( id_triple )
    sparql.insert([ cite_urn, "rdf:label", col.label ])
    
    # Now loop through the images and add their triples
    col.images.each_with_index do | image, i |
      cite_img = "#{col.cite_urn.detagify}.#{i+1}".tagify
      sparql.insert([ cite_img, "rdfs:isDefinedBy", image.tagify ])
      sparql.insert([ cite_img, "cite:belongsTo", cite_urn  ])
      sparql.insert([ cite_urn, "cite:possesses", cite_img  ])
    end
  end
  
  # Delete CITE collection triples reference Collection.
  # col { Collection }
  def self.delete( col )
    
    # Make sure you have a CITE-ified collection
    self.check( col )
    
    # This could point at a different sparql_endpoint if need be
    sparql = self.sparql
    citecol = col.cite_urn.tagify
    
    # Get the associated images
    images = sparql.get_objects([ citecol, "cite:possesses" ])
    
    # Delete the related images
    images.each do | image |
      sub = image[:o].to_s.tagify
      sparql.delete([ sub, :p, :o ])
    end
    
    # Delete the collections
    sparql.delete([ citecol, :p, :o ])
  end
  
  # Take a cite urn and retrieve an img path
  def self.toImgPath( urn, size, cite=false )
    ok = [ "path", "thumb", "basic", "advanced" ]
    
    # We need a urn
    if urn == nil
      raise "urn cannot be nil"
    end
    
    # Default size
    if ok.include?( size ) == false
      urn += ".#{size}"
      size = "path"
    end
    
    # sparql_model urn?
    if urn.include?( 'cite' )
      urn = ControllerHelper.colonUrn( urn )
      urn = self.sparqlImage( urn )
    else
      if cite == true
        raise "cite urn required"
      end
    end
    
    # return that file.
    img = Image.new
    img.byId( urn.just_i )
    img.all[ size.to_sym ]
  end
  
  # Get the URN to the SPARQL image
  # urn { String } The cite urn to an image
  def self.sparqlImage( urn )
    sparql = self.sparql
    images = sparql.get_objects([ urn, "rdfs:isDefinedBy" ])
    if images.length > 1
      raise "Something is fishy. Query should return only one urn."
    end
    images[0][:o].to_s
  end
  
  private
  
  # Make sure you're dealing with a SparqlModel Collection
  # col { Collection }
  def self.check( col )
    if col.class != Collection
      raise "Argument must be an instance of Collection"
    end
    if col.cite_urn == nil
      raise "Collection cite_urn cannot be null"
    end
  end
  
  # Return a SparqlQuick instance
  def self.sparql
    SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
  end

end