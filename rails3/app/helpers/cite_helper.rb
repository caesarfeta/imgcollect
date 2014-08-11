require_relative "../../../../sparql_model/lib/sparql_quick.rb"

# This class contains methods for converting SparqlModel collection triples into CITE collection triples
module CiteHelper
  
  @prefixes = {
    :hmt => "<http://www.homermultitext.org/hmt/rdf/>",
    :cite => "<http://www.homermultitext.org/cite/rdf/>",
    :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
    :crm => "<http://www.cidoc-crm.org/cidoc-crm/>",
    :rdfs => "<http://www.w3.org/2000/01/rdf-schema#>"
  }
  
  # Take a SparqlModel collection and write CITE collection triples from it
  # _col { Collection }
  def self.make( _col )
    
    # Make sure you have what you need to to CITE-ify a collection
    self.check( _col )
    
    # This could point at a different sparql_endpoint if need be
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    
    # First things first... mark the collection as a CITE collection
    # and add all the necessary metadata
    sparql.insert([ _col.cite_urn.ltgt, "rdf:type", "cite:ImageArchive" ])
    sparql.insert([ _col.cite_urn.ltgt, "rdf:label", _col.label ])
    
    # Now loop through the images and add their triples
    _col.images.each_with_index do | image, i |
      cite_img = "#{_col.cite_urn}.#{i+1}".ltgt
      cite_col = _col.cite_urn.ltgt
      sparql.insert([ cite_img, "rdfs:isDefinedBy", image.ltgt ])
      sparql.insert([ cite_img, "cite:belongsTo", cite_col  ])
      sparql.insert([ cite_col, "cite:possesses", cite_img  ])
    end
  end
  
  # Delete CITE collection triples reference Collection.
  # _col { Collection }
  def self.delete( _col )
    
    # Make sure you have a CITE-ified collection
    self.check( _col )
    
    # This could point at a different sparql_endpoint if need be
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    cite_col = _col.cite_urn.ltgt
    
    # Get the associated images
    images = sparql.get_objects([ cite_col, "cite:possesses" ])
    
    # Delete the related images
    images.each do | image |
      sub = image[:o].to_s.ltgt
      sparql.delete([ sub, :p, :o ])
    end
    
    # Delete the collections
    sparql.delete([ cite_col, :p, :o ])
  end
  
  private
  
  # Make sure you're dealing with a SparqlModel Collection
  def self.check( _col )
    if _col.class != Collection
      raise "Argument must be an instance of Collection"
    end
    if _col.cite_urn == nil
      raise "Collection cite_urn cannot be null"
    end
  end

end