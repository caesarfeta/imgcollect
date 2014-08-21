/* require ../third-party/autosize/jquery.autosize.min.js */

ImgCollectInput = function() {
	this.api = new ImgCollectApi();
}
ImgCollectInput.prototype.events = {}

/**
 * Start up the edit button click listener.
 */
ImgCollectInput.prototype.start = function( _node ) {
	var self = this;
	jQuery( '.edit', _node ).on( 'touchstart click', function() {
		var tr = jQuery( this ).parents( 'tr' );
		var node = jQuery( '.value', tr );
		var value = node.text();

		//  Build the text area
		self.textarea( node, value );
	});
}

/**
 * Listen for changes to the textarea
 *
 * @param { DOM } _node The node containing the textarea
 */
ImgCollectInput.prototype.change = function( _node ) {
	var self = this;
	jQuery( 'textarea', _node ).on( 'keydown', function( _e ) {
		switch( _e.which ) {

			//  If "Enter" is pressed then update value using the API
			case 13:

				//  If the shift key is pressed then ignore...
				if ( window.event.shiftKey == true ) {
					return;
				}

				//  Don't write newline character to the textarea value
				_e.preventDefault();

				//  Update the value after gathering the API args
				var id = self.toId( _node );
				var key = self.toKey( _node );
				var val = jQuery( this ).val();
				var obj = { id: id };
				obj[key] = val;
				self.api.send( 'image', 'update', obj, 'ImgCollectInput' );

				//  TODO:  I should listen for the API success event.
				self.hide( _node, val );
				break;

			//  If "Escape" is pressed then return things the way they were
			case 27:
				self.hide( _node );
				break;
		}
	});
}

/**
 * Hide the textarea
 *
 * @param { DOM } _node The node containing the textarea
 * @param { String } _val The new current value
 */
ImgCollectInput.prototype.hide = function( _node, _val ) {
	if ( _val != undefined ) {
		jQuery( '.current', _node ).html( _val );
	}
	jQuery( '.current', _node ).show();
	jQuery( 'textarea', _node ).remove();
}

/**
 * Create the edit input textarea
 *
 * @param { DOM } _node The node containing the textarea
 * @param { String } _val The new current value
 */
ImgCollectInput.prototype.textarea = function( _node, _value ) {

	//  Don't build two textareas.
	if ( jQuery( 'textarea', _node ).length > 0 ) {
		this.hide( _node );
		return;
	}

	//  Build a single textarea
	jQuery( '.current', _node ).hide();
	_node.append('\
		<textarea rows="1">'+_value.smoosh()+'</textarea>\
	');
	this.change( _node );
	jQuery( 'textarea', _node ).autosize();
}

/**
 * Get the urn of the instance currently being edited
 *
 * @param { DOM } _node The node containing the textarea
 */
ImgCollectInput.prototype.toId = function( _node ) {
	var urn = jQuery( _node ).parents( '.image-full' ).attr( 'data-urn' );
	return urn.lastInt();
}

/**
 * Get the key of the textarea currently being edited
 *
 * @param { DOM } _node The node containing the textarea
 */
ImgCollectInput.prototype.toKey = function( _node ) {
	var tr = jQuery( _node ).parents( 'tr' );
	return jQuery( '.key', tr ).text().replace(':','').keyMe();
}

/*
>> CONSOLE TESTING <<
search.search( 'img original 3' );
input = new ImgCollectInput();
input.start();
*/