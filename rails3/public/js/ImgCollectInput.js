ImgCollectInput = function() {
	this.api = new ImgCollectApi();
}
ImgCollectInput.prototype.events = {}
ImgCollectInput.prototype.start = function() {
	var self = this;
	jQuery( '.edit' ).on( 'touchstart click', function() {
		var tr = jQuery( this ).parents( 'tr' );
		var node = jQuery( '.value', tr );
		var value = node.text();
		//------------------------------------------------------------
		//  Build the text area
		//------------------------------------------------------------
		self.textarea( node, value );
	});
}
ImgCollectInput.prototype.change = function( _node ) {
	var self = this;
	jQuery( 'textarea', _node ).on( 'keydown', function( _e ) {
		//------------------------------------------------------------
		//  If "Enter" is pressed then update value using the API
		//------------------------------------------------------------
		if ( _e.which == 13 ) {
			//------------------------------------------------------------
			//  Don't write newline character to the textarea value
			//------------------------------------------------------------
			_e.preventDefault();
			//------------------------------------------------------------
			//  Update the value after gathering the API args
			//------------------------------------------------------------
			var id = self.toId( _node );
			var key = self.toKey( _node );
			var val = jQuery( this ).val();
			var obj = { id: id };
			obj[key] = val;
			self.api.send( 'image', 'update', obj, 'ImgCollectInput' );
			//------------------------------------------------------------
			//  TODO:  I should listen for the API success event.
			//------------------------------------------------------------
			self.default( _node, val );
		}
	});
}
ImgCollectInput.prototype.default = function( _node, _val ) {
	jQuery( '.current', _node ).text( _val );
	jQuery( '.current', _node ).show();
	jQuery( 'textarea', _node ).remove();
}
ImgCollectInput.prototype.textarea = function( _node, _value ) {
	jQuery( '.current', _node ).hide();
	_node.append('\
		<textarea rows="1">'+_value.smoosh()+'</textarea>\
	');
	this.change( _node );
}
ImgCollectInput.prototype.toId = function( _node ) {
	var urn = jQuery( _node ).parents( '.image-full' ).attr( 'data-urn' );
	return urn.lastInt();
}
ImgCollectInput.prototype.toKey = function( _node ) {
	var tr = jQuery( _node ).parents( 'tr' );
	return jQuery( '.key', tr ).text().replace(':','').keyMe();
}

/*
search.search( 'img original 3' );
input = new ImgCollectInput();
input.start();
*/