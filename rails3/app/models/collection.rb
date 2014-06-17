require 'sparql_model'
class Collection < SparqlModel
  
  # Constructor...
  # _url { String } The URL to the image
  def initialize( _url=nil )
    
    @prefixes = {
      :this => "<http://localhost/imgcollect/collection#>"
    }
    
    #  attribute => [ predicate, variable-type, value-per-predicate, create-required? ]
    @attributes = {
      :name => [ "this:name", ::String, SINGLE, REQUIRED, UNIQUE ],
      :keywords => [ "this:keywords", ::String, MULTI ],
      :images => [ "this.images", ::String, MULTI ]
    }
    
    @template = "<urn:imgcollect:collection.%>"
    @sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    
    #-------------------------------------------------------------
    #  If image URL is supplied get it
    #-------------------------------------------------------------
    if _url != nil
      get( _url )
    end
    
  end
  
  # _name { String } The URL to the image
  def get( _name )
    results = @sparql.select([ :s, pred( :name ), _name ])
    if results.length == 0
      raise "Record could not be found for #{ _name }"
    end
    @urn = "<"+results[0][:s].to_s+">"
  end
    
end
