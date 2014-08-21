class SearchController < ActionController::Base
  
  # Return the search configuration
  def config
    col = Collection.new
    img = Image.new
    sub = Subregion.new
    config = {
      'endpoint' => Rails.configuration.sparql_endpoint+"/query",
      'image' => {
        'prefixes' => img.prefixes,
        'attributes' => img.attributes
      },
      'collection' => {
        'prefixes' => col.prefixes,
        'attributes' => col.attributes
      }
      'subregion' => {
        'prefixes' => sub.prefixes,
        'attributes' => sub.attributes
      }
    }
    render :json => config.to_json
  end
  
end