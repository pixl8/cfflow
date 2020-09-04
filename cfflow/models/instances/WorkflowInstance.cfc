component accessors=true {

	property name="workflowId"             type="string" default="";
	property name="instanceArgs"           type="struct";
	property name="workflowDefinition"     type="Workflow";
	property name="workflowImplementation" type="WorkflowImplementation";
	property name="workflowEngine"         type="WorkflowEngine";

// STATE INTERACTION PROXIES
	public struct function getState(){
		return getWorkflowImplementation().getState( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs() );
	}
	public void function setState( required struct state ){
		getWorkflowImplementation().setState( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs(), state=arguments.state );
	}
	public void function appendState( required struct state ){
		getWorkflowImplementation().appendState( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs(), state=arguments.state );
	}

// STATUS INTERACTION PROXIES
	public string function getStepStatus( required string step ){
		return getWorkflowImplementation().getStepStatus( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs(), step=arguments.step );
	}

	public array function getAllStepStatuses(){
		var statuses         = [];
		var recordedStatuses = getWorkflowImplementation().getAllStepStatuses( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs() );

		for( var step in getSteps() ) {
			ArrayAppend( statuses, { step=step, status=recordedStatuses[ step ] ?: "pending" } );
		}

		return statuses;
	}

	public array function getActiveSteps( boolean includeMeta=false ) {
		var statuses = getAllStepStatuses();
		var activeSteps = [];

		for( var step in statuses ) {
			if ( step.status == "active" ) {
				if ( arguments.includeMeta ) {
					var wfStep = _getStep( step.step );
					ArrayAppend( activeSteps, {
						  id   = step.step
						, meta = wfStep.getMeta()
					} );
				} else {
					ArrayAppend( activeSteps, step.step );
				}
			}
		}

		return activeSteps;
	}

	public any function getActiveStep( boolean includeMeta=false ) {
		var statuses = getAllStepStatuses();

		for( var step in statuses ) {
			if ( step.status == "active" ) {
				if ( arguments.includeMeta ) {
					return {
						  id   = step.step
						, meta = _getStep( step.step ).getMeta()
					};
				}
				return step.step;
			}
		}

		return "";
	}

	public void function setComplete() {
		getWorkflowImplementation().setComplete( workflowId=getWorkflowId(), instanceArgs=getInstanceArgs() );
	}

	public boolean function isComplete() {
		for( var step in getActiveSteps() ) {
			var stepHasActions = ArrayLen( _getStep( step ).getActions() );

			if ( stepHasActions ) {
				return false;
			}
		}

		return true;
	}

	public boolean function isSplit() {
		return ArrayLen( getActiveSteps() ) > 1;
	}

// STEP PROXIES
	public array function getSteps( boolean includeMeta=false ) {
		var steps = [];
		for( var step in getWorkflowDefinition().getSteps() ) {
			if ( arguments.includeMeta ) {
				steps.append( {
					  id   = step.getId()
					, meta = step.getMeta()
				} );

			} else {
				steps.append( step.getId() );
			}
		}

		return steps;
	}

// ACTION PROXIES
	public array function getManualActions( string stepId=getActiveStep() ) {
		var step          = _getStep( arguments.stepId );
		var actions       = step.getActions();
		var manualActions = [];

		for( var action in actions ) {
			if ( action.getIsManual() ) {
				if ( action.hasCondition() ) {
					var conditionPasses = getWorkflowEngine().evaluateCondition(
						  wfCondition = action.getCondition()
						, wfInstance  = this
					);

					if ( !conditionPasses ) {
						continue;
					}
				}

				ArrayAppend( manualActions, action.getId() );
			}
		}

		return manualActions;
	}

	public void function doAction( required string actionId, string stepId=getActiveStep() ) {
		if ( !ArrayFindNoCase( getActiveSteps(), arguments.stepId ) ) {
			throw( "Cannot perform action [#arguments.actionId#] on step [#arguments.stepId#] because the step is not currently active", "cfflow.step.not.active" );
		}
		if ( !ArrayFindNoCase( getManualActions( arguments.stepId ), arguments.actionId ) ) {
			throw( "Cannot perform action [#arguments.actionId#] on step [#arguments.stepId#] because the action is either not valid for this step, or the action's condition has failed.", "cfflow.invalid.manual.action" );
		}

		var step = _getStep( arguments.stepId );
		for( var action in step.getActions() ) {
			if ( action.getId() == arguments.actionId ) {
				getWorkflowEngine().doAction(
					  wfInstance = this
					, wfAction   = action
				);
				return;
			}
		}
	}

	public boolean function doAutoActions( required string stepId ) {
		if ( !ArrayFindNoCase( getActiveSteps(), arguments.stepId ) ) {
			throw( "Cannot perform auto actions on step [#arguments.stepId#] because the step is not currently active", "cfflow.step.not.active" );
		}
		return getWorkflowEngine().doAutoActions(
			  wfInstance = this
			, stepId     = arguments.stepId
		);
	}

// PRIVATE HELPERS
	public any function _getStep( required string stepId ) {
		for( var step in getWorkflowDefinition().getSteps() ) {
			if ( step.getId() == arguments.stepId ) {
				return step;
			}
		}
	}
}