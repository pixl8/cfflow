component singleton {

// CONSTRUCTOR
	public any function init() {
		_setupSchemaValidator();

		return this;
	}

// PUBLIC API METHODS
	public boolean function validate( required struct workflow ) {
		var result = _validateSchema( SerializeJson( workflow ) );

		_validateUniquenessAndReferences( workflow, result );
		if ( !result.valid ) {
			var message = result.message ?: "Your workflow definition is invalid. Please see error detail for details.";
			var type    = "preside.workflow.definition.validation.error";
			var detail  = "Validation details: " & SerializeJson( result.error ?: {} );

			throw( message, type, detail );
		}
		return true;
	}

// PRIVATE HELPERS
	private struct function _validateSchema( required string json ) {
		var results = {
			"error" = {},
			"valid" = true
		};

		try {
			_getValidator().validate( _obj( "org.json.JSONObject" ).init( arguments.json ) );
		} catch ( org.everit.json.schema.ValidationException e ) {
			results.valid = false;
			results.error = {
				  "violationCount"     = e.violationCount          ?: ""
				, "pointerToViolation" = e.pointerToViolation      ?: "##"
				, "message"            = e.message                 ?: ""
				, "keyword"            = e.keyWord                 ?: ""
				, "allMessages"        = _toCfArray( e.allMessages ?: [] )
			};
		}

		return results;
	}

// PRIVATE HELPERS
	private void function _validateUniquenessAndReferences( required struct workflow, required struct result ) {
		var steps   = arguments.workflow.workflow.steps ?: [];
		var stepIds = {};
		for( var step in steps ) {
			// step ID uniqueness
			if ( Len( Trim( step.id ?: "" ) ) ) {
				if ( StructKeyExists( stepIds, step.id ) ) {
					arguments.result.valid = false;
					arguments.result.allMessages = arguments.result.allMessages ?: [];
					arguments.result.allMessages.append( "Step IDs not unique. Two or more steps share the same ID: [#step.id#]" );
				}
				stepIds[ step.id ] = step.id;
			}

			var actions = step.actions ?: [];
			var actionIds = {};
			for( var action in actions ) {
				// action ID uniqueness
				if ( Len( Trim( action.id ?: "" ) ) ) {
					if ( StructKeyExists( actionIds, action.id ) ) {
						arguments.result.valid = false;
						arguments.result.allMessages = arguments.result.allMessages ?: [];
						arguments.result.allMessages.append( "Action IDs not unique. Two or more actions share the same ID: [#action.id#] in the step [#( step.id ?: '' )#]" );
					}
					actionIds[ action.id ] = action.id;
				}

				var results = action.conditionalResults ?: [];
				var resultIds = {};
				var resultConditions = {};
				for( var result in results ) {
					// result ID uniqueness
					if ( Len( Trim( result.id ?: "" ) ) ) {
						if ( StructKeyExists( resultIds, result.id ) ) {
							arguments.result.valid = false;
							arguments.result.allMessages = arguments.result.allMessages ?: [];
							arguments.result.allMessages.append( "Result IDs not unique. Two or more conditional results share the same ID: [#result.id#] in the step action [#( step.id ?: '' )#.#( action.id ?: '' )#]" );
						}
						resultIds[ result.id ] = result.id;
					}
					// result condition uniqueness
					if ( IsStruct( result.condition ?: "" ) ) {
						var serializedCondition = SerializeJson( result.condition );
						if ( StructKeyExists( resultConditions, serializedCondition ) ) {
							arguments.result.valid = false;
							arguments.result.allMessages = arguments.result.allMessages ?: [];
							arguments.result.allMessages.append( "Result conditions are not unique. Two or more conditional results share the same condition: [#serializedCondition#] in the step action [#( step.id ?: '' )#.#( action.id ?: '' )#]" );
						}
						resultConditions[ serializedCondition ] = result.condition;
					}

					var preFunctions = result.functions.pre ?: [];
					var postFunctions = result.functions.post ?: [];
					var functionIds = {};
					for( var fn in preFunctions ) {
						if ( Len( Trim( fn.id ?: "" ) ) ) {
							if ( StructKeyExists( functionIds, fn.id ) ) {
								arguments.result.valid = false;
								arguments.result.allMessages = arguments.result.allMessages ?: [];
								arguments.result.allMessages.append( "Pre Function IDs are not unique. Two or more pre functions share the same id: [#fn.id#] in the conditional result [#( step.id ?: '' )#.#( action.id ?: '' )#.#( result.id ?: '' )#]" );
							}
							functionIds[ fn.id ] = fn.id;
						}
					}
					functionIds = {};
					for( var fn in postFunctions ) {
						if ( Len( Trim( fn.id ?: "" ) ) ) {
							if ( StructKeyExists( functionIds, fn.id ) ) {
								arguments.result.valid = false;
								arguments.result.allMessages = arguments.result.allMessages ?: [];
								arguments.result.allMessages.append( "Post Function IDs are not unique. Two or more post functions share the same id: [#fn.id#] in the conditional result [#( step.id ?: '' )#.#( action.id ?: '' )#.#( result.id ?: '' )#]" );
							}
							functionIds[ fn.id ] = fn.id;
						}
					}
				}


				var preFunctions = action.defaultResult.functions.pre ?: [];
				var postFunctions = action.defaultResult.functions.post ?: [];
				var functionIds = {};
				for( var fn in preFunctions ) {
					if ( Len( Trim( fn.id ?: "" ) ) ) {
						if ( StructKeyExists( functionIds, fn.id ) ) {
							arguments.result.valid = false;
							arguments.result.allMessages = arguments.result.allMessages ?: [];
							arguments.result.allMessages.append( "Pre Function IDs are not unique. Two or more pre functions share the same id: [#fn.id#] in the default result for action [#( step.id ?: '' )#.#( action.id ?: '' )#]" );
						}
						functionIds[ fn.id ] = fn.id;
					}
				}
				functionIds = {};
				for( var fn in postFunctions ) {
					if ( Len( Trim( fn.id ?: "" ) ) ) {
						if ( StructKeyExists( functionIds, fn.id ) ) {
							arguments.result.valid = false;
							arguments.result.allMessages = arguments.result.allMessages ?: [];
							arguments.result.allMessages.append( "Post Function IDs are not unique. Two or more post functions share the same id: [#fn.id#] in the default result for action [#( step.id ?: '' )#.#( action.id ?: '' )#]" );
						}
						functionIds[ fn.id ] = fn.id;
					}
				}
			}
		}

		for( var step in steps ) {
			var actions = step.actions ?: [];
			for( var action in actions ) {
				var defaultTransitions = action.defaultResult.transitions ?: [];
				var conditionalResults = action.conditionalResults ?: [];

				for( var transition in defaultTransitions ) {
					if ( Len( Trim( transition.step ?: "" ) ) && !StructKeyExists( stepIds, transition.step ) ) {
						arguments.result.valid = false;
						arguments.result.allMessages = arguments.result.allMessages ?: [];
						arguments.result.allMessages.append( "Transition step ID, [#transition.step#], could not be found. Transition defined in default result for action: [#( step.id ?: '' )#.#( action.id ?: '' )#]." );
					}
				}

				for( var result in conditionalResults ) {
					var transitions = result.transitions ?: [];
					for( var transition in transitions ) {
						if ( Len( Trim( transition.step ?: "" ) ) && !StructKeyExists( stepIds, transition.step ) ) {
							arguments.result.valid = false;
							arguments.result.allMessages = arguments.result.allMessages ?: [];
							arguments.result.allMessages.append( "Transition step ID, [#transition.step#], could not be found. Transition defined in conditional result: [#( step.id ?: '' )#.#( action.id ?: '' )#.#( result.id ?: '' )#]." );
						}
					}
				}


			}
		}
	}

	private void function _setupSchemaValidator() {
		var schemaDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "schema/v1/"
		var schema    = FileRead( schemaDir & "workflow.json" );
		var schemaObj = _obj( "org.json.JSONObject" ).init( _obj( "org.json.JSONTokener" ).init( schema ) );
		var schemaLoader = _obj( "org.everit.json.schema.loader.SchemaLoader" ).builder()
            .schemaJson( schemaObj )
            .resolutionScope( "file://" & schemaDir )
            .build();

        _setValidator( schemaLoader.load().build() );
	}

	private any function _obj( required string class ) {
		return CreateObject( "java", arguments.class, _getLib() );
	}

	private array function _getLib() {
		var libDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "lib";
		return DirectoryList( libDir, false, "path", "*.jar" );
	}

	private array function _toCfArray( javaArr ) {
		var cfArray = [];

		for( var entry in arguments.javaArr ) {
			ArrayAppend( cfArray, entry );
		}

		return cfArray;
	}

// GETTERS AND SETTERS
	private any function _getValidator() {
	    return _validator;
	}
	private void function _setValidator( required any validator ) {
	    _validator = arguments.validator;
	}

}