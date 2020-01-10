component singleton {

// CONSTRUCTOR
	public any function init() {
		_setupSchemaValidator();

		return this;
	}

// PUBLIC API METHODS
	public boolean function validate( required struct workflow ) {
		var result = _getValidator().validate( SerializeJson( arguments.workflow ) );

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
		var validator = new cfflow.models.util.JsonSchemaValidator(
			  schemaFilePath = schemaDir & "workflow.schema.json"
			, schemaBaseUri  = "file://#schemaDir#"
		);

		_setValidator( validator );
	}

// GETTERS AND SETTERS
	private any function _getValidator() {
	    return _validator;
	}
	private void function _setValidator( required any validator ) {
	    _validator = arguments.validator;
	}

}