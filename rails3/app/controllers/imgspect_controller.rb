class ImgspectController < ActionController::Base
  
  # Create a new subregion
  def load
    # Make sure an image exists
    img = CiteHelper.toImgPath( params[:urn], params[:size], true )
    @img = { :src => img }
    render 'imgspect/app'
  rescue
    render :status => 404
  end
  
end
