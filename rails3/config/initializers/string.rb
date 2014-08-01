class String
  
  # Check to see if we're looking at an integer in string's clothing
  def is_i?
     !!( self =~ /\A[-+]?[0-9]+\z/ )
  end
  
  # Return integer
  def just_i
    /\d+/.match( self ).to_s.to_i
  end
end