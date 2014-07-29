class CollectionController < ActionController::Base

  #-------------------------------------------------------------
  #                          POSTS
  #-------------------------------------------------------------
  #  Create a new collection
  def create
    #-------------------------------------------------------------
    #  If no form has been submitted
    #-------------------------------------------------------------
    if request.post? == false
      render :file => 'app/views/collection/create.haml'
      return
    end
    #-------------------------------------------------------------
    #  Build a new collection
    #-------------------------------------------------------------
    collection = Collection.new
    collection.create({
      :name => params[ :name ],
      :cite_urn => params[ :cite_urn ]
    });
    #-------------------------------------------------------------
    #  Output
    #-------------------------------------------------------------
    #render :text => "#{ collection.name } : #{ collection.nickname } has been created successfully"
  end
  
  #  Add an image to a collection
  def add_image
    if request.post? == false
      render :file => 'app/views/collection/add_image.haml'
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
    render :text => "Collection #{ collection.urn }, Image #{ image.urn }"
  end
  
  #  Add a subcollection
  def add_collection
    if request.post? == false
      render :file => 'app/views/collection/add_collection.haml'
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
    render :text => "Collection #{ collection.urn }, Subcollection #{ subcollection.urn }"
  end
  
  #  Add a keyword to a collection
  def add_keyword
    if request.post? == false
      render :file => 'app/views/collection/add_keyword.haml'
      return
    end
    #-------------------------------------------------------------
    #  Add a keyword to a collection
    #-------------------------------------------------------------
    collection = Collection.new()
    collection.byId( params[ :collection_id ] )
    keyword = params[ :keyword ]
    collection.add( :keywords, keyword )
    render :text => "Collection #{ collection.urn }, Keyword #{ keyword }"
  end
  
  #-------------------------------------------------------------
  #                         GETS
  #-------------------------------------------------------------
  
  # Get a full collection report
  def full
    col = Collection.new
    col.byId( params[:id] )
    @col = col.all
    render 'collection/full'
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

#  This is an ignorance hack.
#  TODO: Find a home for this that isn't here.
class String
  # Check to see if we're looking at an integer in string's clothing
  def is_i?
     !!( self =~ /\A[-+]?[0-9]+\z/ )
  end
end