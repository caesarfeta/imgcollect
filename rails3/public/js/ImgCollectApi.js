( function( global ) {
ImgCollectApi = function() {
	
	/**
	 *  There should be only one API object.
	 */ 
	if ( ImgCollectApi.prototype._me ) {
		return ImgCollectApi.prototype._me;
	}
	ImgCollectApi.prototype._me = this;
	
	/**
	 * Events
	 */
	this.events = {
		success: 'ImgCollectApi-SUCCESS',
		error: 'ImgCollectApi-ERROR',
		img_loaded: 'ImgCollectApi-Img'
	};
	
	/**
	 * API Config
	 * Here's what a configuration object looks like.
	 *
	 *	'url': {
	 *		method: ImgCollectApi.prototype.GET,
	 *		pathVars: [ 'data', 'to', 'append', 'to', 'url' ]
	 *	}
	 */
	this.config = {
		'image/add': {
			method: 'POST'
		},
		'image/upload': {
			method: 'POST'
		},
		'image/update': {
			method: 'POST'
		},
		'image/full': {
			method: 'GET',
			pathVars: [ 'id' ]
		},
		'collection/full': {
			method: 'GET',
			pathVars: [ 'id' ]
		},
		'collection/create': {
			method: 'POST'
		}
	};
	
	/**
	 * Make the request
	 *
	 * @param { String } _model The model name
	 * @param { String } _action The action name
	 * @param { Obj } _data The data object to send
	 * @param { String } _context A string for marking the context of the send method call
	 */
	this.send = function( _model, _action, _data, _context ) {
		var self = this;
		var url = [ _model, _action ];
		lookup = url.join('/');
		//------------------------------------------------------------
		//  What's the method? 
		//------------------------------------------------------------
		var method = self.httpMethod( lookup );
		//------------------------------------------------------------
		//  Append path data
		//------------------------------------------------------------
		var pathVars = self.pathVars( lookup );
		for ( var i=0; i<pathVars.length; i++ ) {
			if ( pathVars[i] in _data ) {
				url.push( _data[ pathVars[i] ] );
				delete _data[ pathVars[i] ];
			}
		}
		url = url.join('/');
		//------------------------------------------------------------
		//  TODO: make sure _data is key value pairs
		//------------------------------------------------------------
		jQuery.ajax({
			url: url,
			type: method,
			data: _data,
			success: function( _data, _status ) {
				jQuery( document ).trigger( self.events['success'], { context: _context, data: _data } );
			},
			error: function( _error ) {
				jQuery( document ).trigger( self.events['error'], { context: _context, data: null, error: _error } );
			}
		});
	};
	
	/**
	 * Append path variables
	 *
	 * @param { String } The url
	 */
	this.pathVars = function( _url ) {
		if ( 'pathVars' in this.config[ _url ] ) {
			return this.config[ _url ]['pathVars'];
		}
		return [];
	};
	
	/**
	 * Check the method type
	 *
	 * @param { String } The url
	 */
	this.httpMethod = function( _url ) {
		var method = this.config[ _url ]['method']
		method = method.toUpperCase();
		if ( method == 'POST' || method == 'GET' ) {
			return method;
		}
		jQuery( document ).trigger( self.events['error'] );
	};
	
	/**
	 * Get an image or collection
	 *
	 * @param { String }  The model
	 * @param { Integer } The id
	 */
	this.get = function( _model, _id, _context ) {
		_context = ( _context == undefined ) ? 'LoadFull' : _context;
		this.send( _model, 'full', { 'id': _id }, _context );
	};
};
} ( window ) );