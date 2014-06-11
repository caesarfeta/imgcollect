class SparqlBase
  
  #-------------------------------------------------------------
  #  Configuration constants are more readable than contextless
  #  true & false values
  #-------------------------------------------------------------
  SINGLE = true
  MULTI = false
  REQUIRED = true
  
  #-------------------------------------------------------------
  #  These two methods need to be defined by child classes
  #-------------------------------------------------------------
  def initialize
    @prefixes = {}
    @attributes = {}
    @template = nil
    @sparql = nil # SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
  end
  
  def get
  end
  
  
  
  
  # Create a new image
  # _values { Hash }
  def create( _values )
    @urn = new_urn()
    required_check( _values )
    change( _values )
  end
  
  # Change values in mass with a hash
  # _values { Hash }
  def change( _values )
    _values.each do | key, value |
      check = single_or_multi( key )
      case check
      when SINGLE
        update( key, value )
      when MULTI
        if value.class == ::Array
          value.each do | subval |
            add( key, subval )
          end
        else
          add( key, value )
        end
      end
    end
  end
  
  # Add a record
  # _key { Symbol }
  # _value { String, Other }
  def add( _key, _value )
    urn?()
    key = _key.to_sym
    attr?( key )
    type?( key )
    type_class?( key, _value )
    multi?( key )
    @sparql.insert([ @urn, pred( key ), _value ])
  end
  
  # Delete an attribute
  # _key { Symbol }
  # _value { String, Other }
  def delete( _key, _value=nil )
    urn?()
    key = _key.to_sym
    attr?( key )
    if _value == nil
      @sparql.delete([ @urn, pred( key ), :o ])
      return
    end
    @sparql.delete([ @urn, pred( key ), _value ])
  end
  
  # ActiveRecord style trickery
  def method_missing( _key, *_value )
    #-------------------------------------------------------------
    #  Get attribute object key
    #-------------------------------------------------------------
    key = /^[^\=]*/.match( _key ).to_s.to_sym
    #-------------------------------------------------------------
    #  Return current value if no value assigned
    #-------------------------------------------------------------
    value = _value[0]
    update( key, value )
  end
  
  
  
  
  
  private
  
  # Check if required values are included
  # _values { Hash }
  def required_check( _values )
    to_check = []
    @attributes.each do | key, val |
      if val[3] == REQUIRED
        to_check.push( key )
      end
    end
    missing = []
    to_check.each do | val |
      if _values.has_key?( val ) == false
        missing.push( val )
      end
    end
    if missing.length > 0
      raise "Required values missing ( #{ missing.join(",") } )"
    end
  end
  
  # Update an attribute
  # _key { Symbol }
  # _value { Array, String }
  def update( _key, _value )
    urn?()
    attr?( _key )
    if _value == nil
      return @sparql.value([ @urn, pred( _key ) ])
    end
    type?( _key )
    type_class?( _key, _value )
    single?( _key )
    #-------------------------------------------------------------
    #  Update the value
    #-------------------------------------------------------------
    @sparql.update([ @urn, pred( _key ), _value ])
  end
  
  # Does attribute key exist?
  # _key { Symbol } 
  def attr?( _key )
    if @attributes.has_key?( _key ) == false
      raise "Attribute #{ _key } not found."
    end
  end
  
  # Has an attribute type been specified
  # _key { Symbol }
  def type?( _key )
    if @attributes[ _key ][1] == nil
      raise "Type not specified."
    end
  end
  
  # Get the triple predicate
  # _key { Symbol }
  # @return { String }
  def pred( _key )
    p = @attributes[ _key ][0]
    if p == nil
      raise "Triple predicate not specified."
    end
    return p
  end
  
  # _key { Symbol }
  def single?( _key )
    check = single_or_multi( _key )
    if check != SINGLE
      raise "#{ _key } is not a SINGLE attribute. Use add( :#{ _key }, 'value' ) instead."
    end
  end
  
  # _key { Symbol }
  def multi?( _key )
    check = single_or_multi( _key )
    if check != MULTI
      raise "#{ _key } is not a MULTI attribute."
    end
  end
  
  # Make sure URN is defined
  def urn?
    if @urn == nil
      raise "Error @URN is null"
    end
  end
  
  # _key { Symbol }
  def single_or_multi( _key )
    return @attributes[ _key ][2]
  end
  
  # _type { Symbol }
  # _value { String, Other }
  def type_class?( _key, _value )
    type = @attributes[ _key ][1]
    check = _value.class
    if check != type
      raise "Type mismatch: \"#{ check }\" passed but  \"#{ type }\" is needed."
    end
  end
  
  # Get a new URN
  # @return { String }
  def new_urn
    index = @sparql.next_index([ pred( :path ), :o ], :s )
    return @template.sub( /%/, index.to_s )
  end
    
end