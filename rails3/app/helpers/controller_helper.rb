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
  
  def self.colonUrn( urn )
    urn.colonize('/').add_urn.tagify
  end
  
end