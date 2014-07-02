class CollectionController < ActionController::Base

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
  
  def show
    collection = Collection.new( params[ :name ] )
    render :text => collection.name
  end

end