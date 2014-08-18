require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Subregion < SparqlModel

  def initialize( _key=nil )
    @endpoint = Rails.configuration.sparql_endpoint
    @attributes = {
      :cite_urn => [ "this:cite_urn", ::URN, SINGLE, REQUIRED ],
      :x => [ "this:x", ::Integer, SINGLE, REQUIRED ],
      :y => [ "this:y", ::Integer, SINGLE, REQUIRED ],
      :width => [ "this:width", ::Float, SINGLE, REQUIRED ],
      :height => [ "this:height", ::Float, SINGLE, REQUIRED ],
      :caption => [ "this:caption", ::String, SINGLE ]
    }
    super( _key )
  end
end
