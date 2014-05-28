class Image
  # To test:
  # img = Image.new
  # img.test
  def test
    data = %Q(
      PREFIX dc: <http://purl.org/dc/elements/1.1/>
      INSERT DATA {
        <http://example/book1> dc:title    "An oldish book" ;
                               dc:creator  "Dog McBug" .
      }
    )
    res = Net::HTTPSession.post_form( URI('http://localhost:8080/ds/update'), 'update' => data )
    puts res.body
  end
end