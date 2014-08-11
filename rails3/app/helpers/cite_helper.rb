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
  
  # Does a cite collection exist?
  # _col { Collection }
  def self.exists?( _col )
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    if _col.class == Hash
      cite_urn = _col[:cite_urn].tagify
    else
      cite_urn = _col.cite_urn.tagify
    end
    id_triple = [ cite_urn, "rdf:type", "cite:ImageArchive" ];
    if sparql.count( id_triple ) != 0
      return true
    end
    false
  end
  
  # Take a SparqlModel collection and write CITE collection triples from it
  # _col { Collection }
  def self.create( _col )
    
    # Make sure you have what you need to to CITE-ify a collection
    self.check( _col )
    
    # Does a cite collection exist?
    if self.exists?( _col )
      raise 'This collection has already been CITE-ified'
    end
    
    # This could point at a different sparql_endpoint if need be
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    cite_urn = _col.cite_urn.tagify
    id_triple = [ cite_urn, "rdf:type", "cite:ImageArchive" ];
    
    # First things first... mark the collection as a CITE collection
    # and add all the necessary metadata
    sparql.insert( id_triple )
    sparql.insert([ cite_urn, "rdf:label", _col.label ])
    
    # Now loop through the images and add their triples
    _col.images.each_with_index do | image, i |
      cite_img = "#{_col.cite_urn}.#{i+1}".tagify
      sparql.insert([ cite_img, "rdfs:isDefinedBy", image.tagify ])
      sparql.insert([ cite_img, "cite:belongsTo", cite_urn  ])
      sparql.insert([ cite_urn, "cite:possesses", cite_img  ])
    end
  end
  
  # Delete CITE collection triples reference Collection.
  # _col { Collection }
  def self.delete( _col )
    
    # Make sure you have a CITE-ified collection
    self.check( _col )
    
    # This could point at a different sparql_endpoint if need be
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    cite_col = _col.cite_urn.tagify
    
    # Get the associated images
    images = sparql.get_objects([ cite_col, "cite:possesses" ])
    
    # Delete the related images
    images.each do | image |
      sub = image[:o].to_s.tagify
      sparql.delete([ sub, :p, :o ])
    end
    
    # Delete the collections
    sparql.delete([ cite_col, :p, :o ])
  end
  
  private
  
  # Make sure you're dealing with a SparqlModel Collection
  # _col { Collection }
  def self.check( _col )
    if _col.class != Collection
      raise "Argument must be an instance of Collection"
    end
    if _col.cite_urn == nil
      raise "Collection cite_urn cannot be null"
    end
  end

end