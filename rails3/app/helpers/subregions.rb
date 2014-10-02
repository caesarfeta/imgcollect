require_relative "../../../../sparql_model/lib/sparql_quick.rb"
include ControllerHelper
class Subregions
  
  @prefixes = {
    :subregion => "<http://localhost/sparql_model/subregion#>"
  }
  
  # Return all subregion urns associated with a cite_urn
  # @return { Array } An array of Subregion
  def self.all( urn )
    sparql = self.sparql
    urn = ControllerHelper.colonUrn( urn )
    urn = ControllerHelper.lastDot( urn )
    urns = sparql.select([ :s, 'subregion:cite_urn', urn ])
    subregions = []
    urns.each do | urn |
      sub = Subregion.new()
      sub.byId( urn[:s].to_s.just_i )
      subregions.push( sub.all )
    end
    subregions
  end
  
  # Return a SparqlQuick instance
  def self.sparql
    SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
  end
  
end