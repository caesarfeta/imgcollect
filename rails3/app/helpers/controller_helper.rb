module ControllerHelper
  
  # Remove unnecessary stuff from controller method parameters
  def self.cleanParams( params )
    ignore = [ 'id', 'controller', 'action' ]
    clean = {}
    params.each do |key,val|
      if ignore.include?( key ) == false
        clean[ key.to_sym ] = val
      end
    end
    clean
  end
  
  # Take a path and turn it into a colon separated URN
  def self.colonUrn( urn )
    urn.colonize('/').add_urn.tagify
  end

  # Retrieve a full path
  def self.fullPath( params )
    format = ''
    if params[:format] != nil
      format = ".#{ params[:format] }"
    end
    return params[:urn] + format
  end
  
end