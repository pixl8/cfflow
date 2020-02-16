component implements="IWorkflowArgSubstitutionProvider" {

	public struct function getTokens( required array requiredTokens, required WorkflowInstance wfInstance ) {
		var tokens = {};
		var state  = wfInstance.getState();

		for( var key in state ) {
			var allTokens = _getTokensWithRecursion( key, state );
			for( var token in allTokens ) {
				if ( ArrayFindNoCase( requiredTokens, token ) ) {
					tokens[ token ] = allTokens[ token ];
				}
			}
		}

		return tokens;
	}

// HELPERS
	private struct function _getTokensWithRecursion( required string key, required struct state ) {
		var value = state[ key ];

		if ( IsSimpleValue( value ) ) {
			return { "$#key#" = value };
		}

		if ( IsStruct( value ) ) {
			var tokens    = {};
			var subTokens = {};
			for( var subKey in value ) {
				StructAppend( subTokens, _getTokensWithRecursion( subKey, value ) );
			}

			for( var subToken in subTokens ) {
				tokens[ ReReplace( subToken, "^\$", "$#key#." ) ] = subTokens[ subToken ];
			}

			return tokens;
		}

		return {};
	}
}