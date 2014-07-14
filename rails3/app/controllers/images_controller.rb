class ImagesController < ActionController::Base
  def all
    sparql = SparqlQuick.new( 'http://localhost:8080/ds', { :this => "<http://localhost/sparql_model/image#>" } )
  end
end
