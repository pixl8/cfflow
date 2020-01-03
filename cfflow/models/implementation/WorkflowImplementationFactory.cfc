component singleton {

	variables._implementations = {};

	public any function init( required any coldbox ) {
		_setWirebox( arguments.coldbox.getWirebox() );

		return this;
	}

	public IWorkflowImplementation function getImplementation( required string className ) {
		if ( !StructKeyExists( _implementations, arguments.className ) ) {
			_implementations[ arguments.className ] = _getInstance( arguments.className );
		}

		return _implementations[ arguments.className ];
	}

// PRIVATE HELPERS
	private any function _getInstance( required string className ) {
		var isDsl = arguments.className contains ":";

		try {
			if ( isDsl ) {
				return _getWirebox().getInstance( dsl=arguments.className );
			} else {
				return _getWirebox().getInstance( name=arguments.className );
			}
		} catch( "Injector.InstanceNotFoundException" e ) {
			return _getWirebox().getInstance( name="defaultWorkflowImplementation@cfflow" );
		}
	}

// GETTERS AND SETTERS
	private any function _getWirebox() {
	    return _wirebox;
	}
	private void function _setWirebox( required any wirebox ) {
	    _wirebox = arguments.wirebox;
	}
}