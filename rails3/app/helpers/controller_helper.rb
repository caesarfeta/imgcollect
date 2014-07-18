module ControllerHelper
  
  # Remove unnecessary stuff from controller method parameters
  def self.cleanParams( _params )
    ignore = [ 'id', 'controller', 'action' ]
    clean = {}
    _params.each do |key,val|
      if ignore.include?( key ) == false
        clean[ key.to_sym ] = val
      end
    end
    clean
  end
  
end