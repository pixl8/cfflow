component {

// CONSTRUCTOR
	public any function init() {
		_setTokenProviders( [] );

		registerTokenProvider( new WorkflowStateSubstitutionProvider() );

		return this;
	}

// PUBLIC API METHODS
	public struct function substitute( required struct args, required WorkflowInstance wfInstance ) {
		var discoveredTokens = discoverTokens( args );
		var substituted = StructCopy( args );

		if ( ArrayLen( discoveredTokens ) ) {
			var tokens = {};
			for( var provider in _getTokenProviders() ) {
				StructAppend( tokens, provider.getTokens( discoveredTokens, wfInstance ) );
			}

			if ( StructCount( tokens ) ) {
				_substituteRecursively( substituted, tokens );
			}
		}

		return substituted;
	}

	public array function discoverTokens( required struct args ) {
		var tokens     = {};
		var tokenRegex = "\$[a-zA-Z_][a-zA-Z_\-\.0-9]*\b";

		for( var key in args ) {
			var value = args[ key ];

			if ( IsSimpleValue( value ) ) {
				var matches = ReMatch( tokenRegex, value );
				for( var token in matches ) {
					tokens[ token ] = 0;
				}
			} else if ( IsStruct( value ) ) {
				var subTokens = discoverTokens( value );
				for( var subToken in subTokens ) {
					tokens[ subToken ] = 0;
				}
			}
		}

		return StructKeyArray( tokens );
	}

	public void function registerTokenProvider( required IWorkflowArgSubstitutionProvider provider ) {
		var tokenProviders = _getTokenProviders();

		ArrayAppend( tokenProviders, arguments.provider );
	}

// PRIVATE HELPERS
	private void function _substituteRecursively( substituted, tokens ) {
		var tokenRegex = "\$[a-zA-Z_][a-zA-Z_\-\.0-9]*\b";

		for( var key in substituted ) {
			var value = substituted[ key ];
			if ( IsSimpleValue( value ) && ReFind( tokenRegex, value ) ) {
				for( var token in tokens ) {
					var regexForThisToken = ReReplace( token, "([\$\-\.])", "\\1", "all" );

					value = substituted[ key ] = ReReplaceNoCase( value, regexForThisToken, tokens[ token ], "all" );
				}
			} else if ( IsStruct( value ) ) {
				substituted[ key ] = StructCopy( value );
				_substituteRecursively( substituted[ key ], tokens );
			}
		}
	}

// GETTERS AND SETTERS
	private array function _getTokenProviders() {
	    return _tokenProviders;
	}
	private void function _setTokenProviders( required array tokenProviders ) {
	    _tokenProviders = arguments.tokenProviders;
	}

}