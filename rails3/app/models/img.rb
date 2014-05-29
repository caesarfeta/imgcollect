include Fuseki
class Image
  def initialize
  end
  
  def add
  end
  
  def remove
  end
  
  def name
  end
  
  # To test:
  # img = Image.new
  # img.test
  def test
    sparql = Fuseki::Update.new( 'http://localhost:8080/ds/update')
    sparql.insert( 'http://example/book100', [ 'key' => 'value' ] )
  end
end