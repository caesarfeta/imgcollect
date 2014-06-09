class SparqlQueries
  
  def initialize
    prefixes = {
      :hmt => "<http://www.homermultitext.org/hmt/rdf/>", 
      :cite => "<http://www.homermultitext.org/cite/rdf/>",
      :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
      :crm => "<http://www.cidoc-crm.org/cidoc-crm/>",
      :dc => "<http://dublincore.org/documents/dces/>",
      :exif => "<http://www.kanzaki.com/ns/exif#>"
    }
    @sparql = SparqlQuick.new( 'http://localhost:8080/ds', prefixes )
  end
  
  def keywords
    return @sparql.select([ :s, "rdf:keyword", :o ])
  end
  
  def collections
    return @sparql.select([ :s, "rdf:type", "cite:ImageArchive" ])
  end
  
  def collection_images( _name )
    images = []
    results = @sparql.select([ "<urn:cite:perseus:#{_name}>", "cite:possesses", :o ])
    results.each do | result |
      images.push( image_meta( result[:o] ) )
    end
    return images
  end
  
  def image_meta( _image )
    return @sparql.select([ "<"+_image+">", :p, :o ])
  end
  
  #-------------------------------------------------------------
  #  Quick tests
  #-------------------------------------------------------------
  def insert()
    return @sparql.insert([ "<urn:cite:perseus:insects.2>", "rdf:smelly", "gladbag" ])
  end
  
  def delete()
    return @sparql.delete([ "<urn:cite:perseus:insects.2>", "rdf:smelly", "gladbag" ])
  end
  
  def update()
    return @sparql.update([ "<urn:cite:perseus:insects.2>", "rdf:order", 3 ])
  end
  
  def insert2()
    return @sparql.insert([ "<urn:cite:perseus:insects.2>", "rdf:smelly", "huzzah" ])
  end
  
  def delete2()
    return @sparql.delete([ "<urn:cite:perseus:insects.2>", "rdf:smelly", :o ])
  end
  
  def delete3()
    return @sparql.delete([ "<urn:cite:perseus:insects.2>", "rdf:keyword", :o ])
  end
  
  def nextIndex()
    return @sparql.nextIndex([ "<urn:cite:perseus:insects>", "cite:possesses" ])
  end
  
end