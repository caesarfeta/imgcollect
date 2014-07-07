require 'test_helper'
require 'rest_test'
class ApiTest < ActiveSupport::TestCase
  #-------------------------------------------------------------
  #  API Test POSTS
  #-------------------------------------------------------------
  #-------------------------------------------------------------
  #  Collection
  #-------------------------------------------------------------
  def test_collection_create
    rest = RestTest.new( 'http://localhost:3000' )
    params = { 
      :name => 'Collection Test', 
      :nickname => 'Collection Test Nickname' 
    }
    response = rest.post( 'collection/create', params )
    assert_equal( response[:code], 200 )
  end
  
  def test_collection_add_keyword
    rest = RestTest.new( 'http://localhost:3000' )
    params = { 
      :collection_id => 1, 
      :keyword => 'yellow' 
    }
    response = rest.post( 'collection/add/keyword', params )
    assert_equal( response[:code], 200 )
  end
  
  def test_collection_add_image
    rest = RestTest.new( 'http://localhost:3000' )
    params = {
    }
    response = rest.post( 'collection/add/image', params )
    assert_equal( response[:code], 200 )
  end
  
  def test_collection_image_sequence
    rest = RestTest.new( 'http://localhost:3000' )
    collection_id = 1
    params = {
      :sequence => [ 
        'urn:img_collect:image.1',
        'urn:img_collect:image.2',
        'urn:img_collect:image.3',
        'urn:img_collect:collection.2'
      ]
    }
    response = rest.post( "collection/#{ collection_id }/image/sequence", params )
    assert_equal( response[:code], 200 )
  end
  
  #-------------------------------------------------------------
  #  Images
  #-------------------------------------------------------------
  def test_image_upload
    rest = RestTest.new( 'http://localhost:3000' )
    params = {
      :file => File.new( '/usr/local/imgcollect/rails3/test/fixtures/images/forest3.JPG', 'rb' )
    }
    response = rest.post( 'image/upload', params )
    assert_equal( response[:code], 200 )
  end
  
#  def test_image_meta
#    rest = RestTest.new( 'http://localhost:3000' )
#    params = {
#      :image_id => 1,
#    }
#    response = rest.post( 'image/update/meta', params )
#    assert_equal( response[:code], 200 )
#  end
  
  #-------------------------------------------------------------
  #  API Test GETS
  #-------------------------------------------------------------
  #-------------------------------------------------------------
  #  Collection
  #-------------------------------------------------------------
  def test_collection_images
    rest = RestTest.new( 'http://localhost:3000' )
    collection_id = 1
    response = rest.post( "collection/#{ collection_id }/images" )
    assert_equal( response[:code], 200 )
  end
end