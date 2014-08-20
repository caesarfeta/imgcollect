class ImgbitController < ActionController::Base
  
  # Create a new subregion
  def show
    
    # Get the urn to the image and the subregion coordinates
    path = ControllerHelper.fullPath( params )
    item = path.split(/\//)
    d = { :h => item.pop.to_f, :w => item.pop.to_f, :y => item.pop.to_f, :x => item.pop.to_f }
    n = item.pop
    
    # Make sure everything we need is there
    d.each do | key, value |
      if value < 0 || value > 1
        raise "value #{value} out of range"
      end
    end

    # Get the local path to the image
    src = CiteHelper.toImgPath( item.join('/')+".#{n}", 'path', true )
    @img = { :src => src, :item => item, :d => d }
    render 'imgbit/show'

  end
  
end
