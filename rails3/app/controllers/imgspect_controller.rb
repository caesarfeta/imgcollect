class ImgspectController < ActionController::Base
  
  # Create a new subregion
  def load
    # Make sure an image exists
    urn = params[:urn]
    size = params[:size]
    src = CiteHelper.toImgPath( urn, size, true )
    if src == nil || src == ''
      raise "Not found"
    end
    @img = { :src => src, :urn => CiteHelper.imgUrn( urn, size ) }
    render 'imgspect/app'
  rescue
    render :status => 404
  end
  
end
