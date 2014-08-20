class ImgbitController < ActionController::Base
  
  # Create a new subregion
  def show
    path = params[:urn] + '.' + params[:format]
    item = path.split(/\//)
    dim = { :height => item.pop, :width => item.pop, :y => item.pop, :x => item.pop }
    n = item.pop
    src = CiteHelper.toImgPath( item.join('/')+".#{n}", 'path', true )
    @img = { :src => src, :item => item, :dim => dim }
    render 'imgbit/show'
  rescue
    render :status => 404
  end
  
end
