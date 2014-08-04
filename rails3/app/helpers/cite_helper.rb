require_relative "../../../../sparql_model/lib/sparql_quick.rb"

# This class contains methods for converting SparqlModel collections into CITE collections.
module CiteHelper
  
  @prefixes = {
    :hmt => "<http://www.homermultitext.org/hmt/rdf/>",
    :cite => "<http://www.homermultitext.org/cite/rdf/>",
    :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
    :crm => "<http://www.cidoc-crm.org/cidoc-crm/>"
  }
  
  # Take a SparqlModel collection and write CITE collection triples from it.
  def self.make( _col )
    
    # Make sure you have what you need to to CITE-ify a collection
    if _col.class != Collection
      raise "Argument must be an instance of Collection"
    end
    if _col.cite_urn == nil
      raise "Collection cite_urn cannot be null"
    end
    
    # Okay let's get started.
    # Note that this could point at a different sparql_endpoint if need be.
    sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    
    # First things first... mark the collection as a CITE collection
    sparql.insert([ col.cite_urn, 'rdf:type', 'cite:ImageArchive' ]);
  end
  
end