class Image < Spira::Base
  configure :base_uri => "http://localhost:8080/ds/images"
  property :name, :predicate => FOAF.name, :type => String
  property :age,  :predicate => FOAF.age,  :type => Integer
end

#-------------------------------------------------------------
#  Spira.repository = RDF::Repository.new
#  bob = RDF::URI("http://localhost:8080/ds").as( Image )
#  bob.age  = 15
#  bob.name = "Bob Smith"
#  bob.save!
#
#  bob.each_statement {|s| puts s}
#
#
#  http://domain:8080/sparql.tpl
#
#  SELECT ?s ?p ?o 
#  WHERE {
#    ?s ?p ?o
#  }
#
#-------------------------------------------------------------