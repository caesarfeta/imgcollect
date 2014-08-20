class ImgspectController < ActionController::Base
  
  # Create a new subregion
  def load
    # Make sure an image exists
    src = CiteHelper.toImgPath( params[:urn], params[:size], true )
    @img = { :src => src, :urn => params[:urn] }
    render 'imgspect/app'
  rescue
    render :status => 404
  end
  
end
