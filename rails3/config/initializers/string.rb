class String
  
  # Clip the first and last characters from a string
  # @return { String }
  def clip
    self[1..-2]
  end
  
  # Check to see if we're looking at an integer in string's clothing
  def is_i?
     !!( self =~ /\A[-+]?[0-9]+\z/ )
  end
  
  # Return integer
  def just_i
    /\d+/.match( self ).to_s.to_i
  end
  
  # Wrap <>
  def tagify
    this = self
    if this[0] != "<"
      this = "<#{this}"
    end
    if this[-1,1] != ">"
      this = "#{this}>"
    end
    this
  end
  
end