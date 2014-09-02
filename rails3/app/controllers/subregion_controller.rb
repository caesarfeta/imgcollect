class SubregionController < ActionController::Base
  
  # Create a new subregion
  #
  #   Bare bones testing:
  #
  #   rest = RestTest.new( 'http://localhost:3000' )
  #   rest.post( 'subregion/create', { :cite_urn => 'urn:cite:perseus:memtwo.2', :x => 0.25, :y => 0.6, :width => 0.4, :height => 0.25, :caption => 'Some green stuff.', :user => 'http://data.perseus.org/sosol/users/RestTest' })
  #
  #   Using imgspect UI:
  
  def create
    if request.post? == false
      render :json => { :message => "Error" }
      return
    end
    vals = ControllerHelper.cleanParams( params )

    # Crop the image
    src = CiteHelper.toImgPath( vals[:cite_urn], 'path', true )
    vals[:cropped] = ImgSize.subregion( src, vals[:x], vals[:y], vals[:width], vals[:height] )
    
    # Store the subregion triples
    sub = Subregion.new
    sub.create( vals )
    render :json => { :subregion => sub }
  end
  
  # Delete a subregion
  def delete
  end
  
  # Get all subregions associated with a CITE URN
  def all
    subregions = Subregions.all( params[:urn] )
    render :json => { :subregions => subregions }
  end
  
end
