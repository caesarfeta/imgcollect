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
  
  # Turn delimiters into colons
  # _char { String } The character
  def colonize( char )
    self.gsub!( char, ':' ) || self
  end
  
  # Turn a URN into a path
  def urn_to_path()
    out = self.detagify
    out.gsub!( /:|\./, '/' ) || out
  end
  
  # Return integer
  def just_i
    /\d+/.match( self ).to_s.to_i
  end
  
  # Add urn
  def add_urn
    urn = "urn:"
    this = self
    if this[0,4] != urn
      this = "#{urn}#{this}"
    end
    this
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
  
  # Unwrap <>
  def detagify
    this = self
    if this[0] == "<"
      this = this[1..-1]
    end
    if this[-1,1] == ">"
      this = this[0..-2]
    end
    this
  end
  
end