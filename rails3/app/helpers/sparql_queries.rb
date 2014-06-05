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
    results = @sparql.select([ :s, "rdf:keyword", :o ])
  end
  
  def collections
    results = @sparql.select([ :s, "rdf:type", "cite:ImageArchive" ])
  end
  
end