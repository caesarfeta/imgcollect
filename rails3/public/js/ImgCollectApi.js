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
		img_loaded: 'ImgCollectApi-Img',
		login_req: 'ImgCollectApi-LOGIN_REQ'
	};
	
	/**
	 * Where user data is retrieved.
	 */
	this.perseids = new ImgCollectPerseids();
	
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
			method: 'POST',
			user_req: true
		},
		'image/upload': {
			method: 'POST',
			user_req: true
		},
		'image/update': {
			method: 'POST',
			user_req: true
		},
		'image/full': {
			method: 'GET',
			pathVars: [ 'id' ]
		},
		'collection/add/image': {
			method: 'POST',
			user_req: true
		},
		'collection/dock': {
			method: 'GET',
			pathVars: ['id']
		},
		'collection/full': {
			method: 'GET',
			pathVars: [ 'id' ]
		},
		'collection/create': {
			method: 'POST',
			user_req: true
		},
		'collection/citeify': {
			method: 'POST',
			user_req: true
		},
		'subregion/create': {
			method: 'POST',
			user_req: true
		},
		'subregion/all': {
			method: 'GET',
			pathVars: [ 'cite_urn' ]
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
		
		//  What's the method? 
		var method = self.httpMethod( lookup );
		
		// Only Perseidslogged-in users have access to POST.
		if ( self.userReq( lookup ) ) {
			_data.user = self.perseids.user;
		}
		
		//  Append path data
		var pathVars = self.pathVars( lookup );
		for ( var i=0; i<pathVars.length; i++ ) {
			if ( pathVars[i] in _data ) {
				url.push( _data[ pathVars[i] ] );
				delete _data[ pathVars[i] ];
			}
		}
		url = url.join('/');
		
		// Remember we want an absolute path
		url = '/'+url;

		$.ajax({
			url: url,
			type: method,
			data: _data,
			success: function( _data, _status ) {
				$( document ).trigger( self.events.success, { 
					context: _context, 
					data: _data } 
				);
			},
			error: function( _error ) {
				$( document ).trigger( self.events.error, { 
					context: _context, 
					data: null, 
					error: _error } 
				);
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
			return this.config[ _url ].pathVars;
		}
		return [];
	};
	
	/**
	 * Check the method type
	 *
	 * @param { String } The url
	 */
	this.httpMethod = function( _url ) {
		var method = this.config[ _url ].method;
		method = method.toUpperCase();
		if ( method == 'POST' || method == 'GET' ) {
			return method;
		}
		$( document ).trigger( self.events['error'] );
	};
	
	this.userReq = function( _url ) {
		var item = this.config[ _url ];
		if ( 'user_req' in item && item.user_req == true ) {
			return true;
		}
		return false;
	}
	
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