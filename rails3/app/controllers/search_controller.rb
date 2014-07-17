class SearchController < ActionController::Base
  
  # Get the search configuration
  def config
    col = Collection.new
    img = Image.new
    config = {
      'Image' => {
        'prefixes' => img.prefixes,
        'attributes' => img.attributes
      },
      'Collection' => {
        'prefixes' => col.prefixes,
        'attributes' => col.attributes
      }
    }
    render :json => config.to_json
  end
  
end