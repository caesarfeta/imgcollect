class CollectionController < ActionController::Base

  def create
    render :file => 'app/views/collection/form.haml'
  end

  def report
    #-------------------------------------------------------------
    #  TODO: Validate params
    #-------------------------------------------------------------
    #-------------------------------------------------------------
    #  Build a new collection
    #-------------------------------------------------------------
    collection = Collection.new
    collection.create( params )
  end

  def add_img
  end

  def showall
  end
  
  def show
    collection = Collection.get( params )
    puts collection
  end

end