class CollectionController < ActionController::Base

  #  Create a new collection
  def create
    #-------------------------------------------------------------
    #  If no form has been submitted
    #-------------------------------------------------------------
    if request.post? == false
      render :json => { :message => "Error" }
      return
    end
    #-------------------------------------------------------------
    #  Clean up the parameters
    #-------------------------------------------------------------
    vals = ControllerHelper.cleanParams( params )
    #-------------------------------------------------------------
    #  Build a new collection
    #-------------------------------------------------------------
    collection = Collection.new
    collection.create({
      :name => vals[ :name ],
      :cite_urn => vals[ :cite_urn ].ltgt
    });
    #-------------------------------------------------------------
    #  Output
    #-------------------------------------------------------------
    render :json => { :message => "Success", :collection => collection.all }
  end
  
  #  Add an image to a collection
  def add_image
    if request.post? == false
      render :json => { :message => "Error" }
      return
    end
    #-------------------------------------------------------------
    #  Add an image to a collection
    #-------------------------------------------------------------
    collection = Collection.new()
    collection.byId( params[ :collection_id ] )
    image = Image.new()
    image.byId( params[ :image_id ] )
    collection.add( :images, image.urn )
    render :json => { :message => "Success", :collection => collection.all }
  end
  
  #  Add a subcollection
  def add_collection
    if request.post? == false
      render :json => { :message => "Error" }
      return
    end
    #-------------------------------------------------------------
    #  Add a subcollection to a collection
    #-------------------------------------------------------------
    collection = Collection.new()
    collection.byId( params[ :collection_id ] )
    subcollection = Collection.new()
    subcollection.byId( params[ :subcollection_id ] )
    collection.add( :subcollections, subcollection.urn )
    render :json => { :message => "Success", :collection => collection.all }
  end
  
  #-------------------------------------------------------------
  #                         GETS
  #-------------------------------------------------------------
  
  # Get a full collection
  def full
    col = Collection.new
    col.byId( params[:id] )
    @col = col.all
    render 'collection/full'
  end

  # Get a collection dock  
  def dock
    col = Collection.new
    puts params[:id]
    col.byId( params[:id] )
    @col = col.all
    render 'collection/dock'
  end
  
  #  Get all images belonging to a collection
  def images
    collection = Collection.new()
    collection.byId( params[ :id ] )
    images = image_dig( collection, [], [ collection.urn ] )
    render :text => images.join(',')
  end
  
  #  Recursively retrieve subcollection images
  def image_dig( _collection, _images, _check )
    puts _collection
    puts _check.inspect
    #-------------------------------------------------------------
    #  No sequence just exit...
    #-------------------------------------------------------------
    images = _collection.images
    if images
      images.each do | image |
        _images.push( image )
      end
    end
    #-------------------------------------------------------------
    #  Recurse subcollection to get associated images.
    #  If they exist of course.
    #-------------------------------------------------------------
    subs = _collection.subcollections
    if subs
      subs.each do | sub |
        collection = Collection.new()
        collection.byId( sub.tagify )
        #-------------------------------------------------------------
        #  Avoid circular subcollection referencing.
        #-------------------------------------------------------------
        if _check.include?( collection.urn ) == false
          _check.push( collection.urn )
          _images = image_dig( collection, _images, _check )
        end
      end
    end
    #-------------------------------------------------------------
    #  Return those images.
    #-------------------------------------------------------------
    _images
  end

end