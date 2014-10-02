require 'rest_client'
class RestTest
  
  # Basic Use
  #   load 'rest_test.rb'
  #   rest = RestTest.new( 'http://localhost:3000' )
  #   report = rest.post( 'collection/add/keyword', { :collection_id => 1, :keyword => 'blue' } )
  
  #-------------------------------------------------------------
  #  Getters & Setters
  #-------------------------------------------------------------
  attr_accessor :base
  
  # _base { String } Base URL
  def initialize( _base='' )
    @base = _base
  end
  
  # _url { String } URL
  # _params { Hash } Parameter
  def post( _url, _params )
    url = File.join( @base, _url )
    response = RestClient.post( url, _params )
    report( response )
  end
  
  # _url { String } URL
  # _params { Hash } Parameter
  def get( _url )
    url = File.join( @base, _url )
    response = RestClient.get( url )
    report( response )
  end
  
  # _response { RestClient } RestClient response object
  def report( _response )
    if _response.code > 399
      raise "Error: #{ _response.code }: #{ status( _response.code ) } #{ _response.to_str }"
    end
    return {
      :code => _response.code,
      :status => status( _response.code ),
      :content => _response.to_str
    }
  end
  
  # _code { Integer } HTTP Response Code
  def status( _code )
    status = {
      100 => 'Continue',
      101 => 'Switching Protocols',
      102 => 'Processing', #WebDAV
      
      200 => 'OK',
      201 => 'Created',
      202 => 'Accepted',
      203 => 'Non-Authoritative Information', # http/1.1
      204 => 'No Content',
      205 => 'Reset Content',
      206 => 'Partial Content',
      207 => 'Multi-Status', #WebDAV
      
      300 => 'Multiple Choices',
      301 => 'Moved Permanently',
      302 => 'Found',
      303 => 'See Other', # http/1.1
      304 => 'Not Modified',
      305 => 'Use Proxy', # http/1.1
      306 => 'Switch Proxy', # no longer used
      307 => 'Temporary Redirect', # http/1.1
      
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Resource Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Long',
      415 => 'Unsupported Media Type',
      416 => 'Requested Range Not Satisfiable',
      417 => 'Expectation Failed',
      418 => 'I\'m A Teapot',
      421 => 'Too Many Connections From This IP',
      422 => 'Unprocessable Entity', #WebDAV
      423 => 'Locked', #WebDAV
      424 => 'Failed Dependency', #WebDAV
      425 => 'Unordered Collection', #WebDAV
      426 => 'Upgrade Required', 
      449 => 'Retry With', #Microsoft
      450 => 'Blocked By Windows Parental Controls', #Microsoft
      
      500 => 'Internal Server Error',
      501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
      505 => 'HTTP Version Not Supported',
      506 => 'Variant Also Negotiates',
      507 => 'Insufficient Storage', #WebDAV
      509 => 'Bandwidth Limit Exceeded', #Apache
      510 => 'Not Extended'
    }
    status[ _code ]
  end
  
end