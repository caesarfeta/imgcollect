ImgCollectApi = function() {}

ImgCollectApi.prototype.events = {
	success: 'ImgCollectApi-SUCCESS',
	error: 'ImgCollectApi-ERROR'
}

ImgCollectApi.prototype.map = {
	'image/add': {
		method: 'POST'
	},
	'image/update': {
		method: 'POST'
	},
	'image/preview': {
		method: 'GET',
		pathVars: [ 'id' ]
	}
};

/**
 * Make the request
 *
 * @param { String } _model The model name
 * @param { String } _action The action name
 * @param { Obj } _data The data object to send
 */
ImgCollectApi.prototype.send = function( _model, _action, _data ) {
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
		context: document.body,
		type: method,
		data: _data,
		success: function( _data, _status ) {
			self.data = _data;
			jQuery( document ).trigger( self.events['success'] );
		},
		error: function( _error ) {
			self.error = _error;
			jQuery( document ).trigger( self.events['error'] );
		}
	});
}

/**
 * Append path variables
 *
 * @param { String } The url
 */
ImgCollectApi.prototype.pathVars = function( _url ) {
	if ( 'pathVars' in this.map[ _url ] ) {
		return this.map[ _url ]['pathVars'];
	}
	return [];
}

/**
 * Check the method type
 *
 * @param { String } The url
 */
ImgCollectApi.prototype.httpMethod = function( _url ) {
	var method = this.map[ _url ]['method']
	method = method.toUpperCase();
	if ( method == 'POST' || method == 'GET' ) {
		return method;
	}
	jQuery( document ).trigger( self.events['error'] );
}