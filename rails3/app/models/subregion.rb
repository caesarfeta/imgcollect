require 'sparql_model'
class Subregion < SparqlModel

  def initialize( _key=nil )
    @endpoint = Rails.configuration.sparql_endpoint
    @attributes = {
      :cite_urn => [ "this:cite_urn", ::URN, SINGLE, REQUIRED ],
      :user => [ "this:user", ::URN, SINGLE, REQUIRED ],
      :cropped => [ "this:cropped", ::String, SINGLE, REQUIRED ],
      :x => [ "this:x", ::Float, SINGLE, REQUIRED ],
      :y => [ "this:y", ::Float, SINGLE, REQUIRED ],
      :width => [ "this:width", ::Float, SINGLE, REQUIRED ],
      :height => [ "this:height", ::Float, SINGLE, REQUIRED ],
      :caption => [ "this:caption", ::String, SINGLE ],
      :color => [ "this:color", ::String, SINGLE ]
    }
    super( _key )
  end
end
