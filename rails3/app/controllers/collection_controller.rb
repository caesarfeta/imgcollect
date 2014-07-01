class CollectionController < ActionController::Base

  def create
    #-------------------------------------------------------------
    #  If no form has been submitted
    #-------------------------------------------------------------
    if request.post? == false
      render :file => 'app/views/collection/form.haml'
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
  end
  
  def add_subcollection
  end
  
  def add_keywords
  end
  
  def show
    collection = Collection.new( params[ :name ] )
    render :text => collection.name
  end

end