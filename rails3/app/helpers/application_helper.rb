require_relative "../../../../sparql_model/lib/sparql_quick.rb"
require 'fileutils'
module ApplicationHelper
  
  #-------------------------------------------------------------
  #  Wipeout all custom images and metadata
  #-------------------------------------------------------------
  def self.wipeout
    FileUtils.rm_rf( "#{ Rails.configuration.img_dir }/.", secure: true )
    FileUtils.rm_rf( "#{ Rails.configuration.upload_dir }/.", secure: true )
    SparqlQuick.new( Rails.configuration.sparql_endpoint ).empty( :all )
  end
  
  #-------------------------------------------------------------
  #  Load test instance
  #-------------------------------------------------------------
  def self.loadtest
    rest = RestTest.new( 'http://localhost:3000' )
    #-------------------------------------------------------------
    #  Forests
    #-------------------------------------------------------------
    forests = [
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/forest1.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/forest2.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/forest3.JPG', 'rb' ) }
    ]
    forests.each do | params |
      response = rest.post( 'image/upload', params )
    end
    
    params = { 
      :name => 'Forests', 
      :cite_urn => '<urn:cite:perseus:forests>'
    }
    rest.post( 'collection/create', params )

    add_images = [
      { :collection_id => 1, :image_id => 1 },
      { :collection_id => 1, :image_id => 2 },
      { :collection_id => 1, :image_id => 3 }
    ]
    add_images.each do | params |
      rest.post( 'collection/add/image', params )
    end
    
    # add_keywords = [
    #   { :image_id => 1, :keyword => 'log' },
    #   { :image_id => 1, :keyword => 'moss' },
    #   { :image_id => 1, :keyword => 'leaves' }
    # ]
    # add_keywords.each do | params |
    #   rest.post( 'image/add/keyword', params )
    # end
    
    #-------------------------------------------------------------
    #  Deserts
    #-------------------------------------------------------------
    deserts = [
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/desert1.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/desert2.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/desert3.JPG', 'rb' ) }
    ]
    deserts.each do | params |
      response = rest.post( 'image/upload', params )
    end
    
    params = { 
      :name => 'Deserts', 
      :cite_urn => '<urn:cite:perseus:deserts>'
    }
    rest.post( 'collection/create', params )
    
    add_images = [
      { :collection_id => 2, :image_id => 4 },
      { :collection_id => 2, :image_id => 5 },
      { :collection_id => 2, :image_id => 6 }
    ]
    add_images.each do | params |
      rest.post( 'collection/add/image', params )
    end
    
    #-------------------------------------------------------------
    #  Insects
    #-------------------------------------------------------------
    insects = [
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/insects1.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/insects2.JPG', 'rb' ) },
      { :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/insects3.JPG', 'rb' ) }
    ]
    insects.each do | params |
      response = rest.post( 'image/upload', params )
    end

    params = { 
      :name => 'Insects', 
      :cite_urn => '<urn:cite:perseus:insects>'
    }
    rest.post( 'collection/create', params )
    
    add_images = [
      { :collection_id => 3, :image_id => 7 },
      { :collection_id => 3, :image_id => 8 },
      { :collection_id => 3, :image_id => 9 }
    ]
    add_images.each do | params |
      rest.post( 'collection/add/image', params )
    end
    
    #-------------------------------------------------------------
    #  A collection to rule them all!
    #-------------------------------------------------------------
    params = {
      :name => 'All',
      :cite_urn => '<urn:cite:perseus:all>'
    }
    rest.post( 'collection/create', params )
    
    #-------------------------------------------------------------
    #  Add the subcollection
    #-------------------------------------------------------------
    subrepos = [
      { :collection_id => 4, :subcollection_id => 1 },
      { :collection_id => 4, :subcollection_id => 2 },
      { :collection_id => 4, :subcollection_id => 3 }
    ]
    subrepos.each do | params |
      rest.post( 'collection/add/collection', params )
    end
  end
  
end
