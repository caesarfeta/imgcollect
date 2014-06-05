class SparqlQueries
  
  def initialize
    @sparql = SparqlQuick.new
  end
  
  def keywords
    results = @sparql.select([ :s, "<http://www.w3.org/1999/02/22-rdf-syntax-ns#keyword>", :o ])
  end
  
  def collections
    results = @sparql.select([ :s, "<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>", "<http://www.homermultitext.org/cite/rdf/ImageArchive>" ])
  end
  
end