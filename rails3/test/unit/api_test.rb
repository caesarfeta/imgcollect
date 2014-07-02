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
  
  def test_collection_image_sequence
    rest = RestTest.new( 'http://localhost:3000' )
    params = {
      :collection_id => 1,
      :sequence => 'image.1,image.2'
    }
    response = rest.post( 'collection/image/sequence', params )
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
  
end
