class CollectionController < ActionController::Base

  #-------------------------------------------------------------
  # POSTS
  #-------------------------------------------------------------
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
      :nickname => params[ :nickname ]
    });
    #-------------------------------------------------------------
    #  Output
    #-------------------------------------------------------------
    render :text => "#{ collection.name } : #{ collection.nickname } has been created successfully"
  end
  
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
  
  def image_sequence
    if request.post? == false
      render :file => 'app/views/collection/image_sequence.haml'
      return
    end
    #-------------------------------------------------------------
    #  Reorder images
    #-------------------------------------------------------------
    collection = Collection.new
    collection.byId( params[ :id ] )
    collection.sequence = params[ :sequence ].join(',')
    render :text => params.inspect
  end
  
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
  # GETS
  #-------------------------------------------------------------
  def show
    collection = Collection.new( params[ :name ] )
    render :text => collection.name
  end
  
  def images
    collection = Collection.new()
    collection.byId( params[ :id ] )
    images = image_dig( collection, [], [ collection.urn ] )
    render :text => images.join(',')
  end
  
  
  def image_dig( _collection, _images, _check )
    sequence = _collection.sequence
    #-------------------------------------------------------------
    #  No sequence just exit...
    #-------------------------------------------------------------
    if sequence == nil
      return _images
    end
    #-------------------------------------------------------------
    #  Get the associated images
    #-------------------------------------------------------------
    sequence.split(',').each do | val |
      if val.include? _collection.model.clip
        collection = Collection.new()
        collection.byId( val.tagify )
        #-------------------------------------------------------------
        #  Avoid infinite loop
        #-------------------------------------------------------------
        if _check.include?( collection.urn ) == false
          _check.push( collection.urn )
          _images = image_dig( collection, _images, _check )
        end
      else
        _images.push( val.tagify )
      end
    end
    _images
  end

end

class String
  # Check to see if we're looking at an integer in string's clothing
  def is_i?
     !!( self =~ /\A[-+]?[0-9]+\z/ )
  end
end