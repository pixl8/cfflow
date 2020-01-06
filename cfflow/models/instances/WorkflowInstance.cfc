component accessors=true {

	property name="workflowId"             type="string" default="";
	property name="instanceArgs"           type="struct";
	property name="workflowDefinition"     type="Workflow";
	property name="workflowImplementation" type="WorkflowImplementation";
	property name="cfflow"                 type="CfFlow";

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

	public array function getActiveSteps() {
		var statuses = getAllStepStatuses();
		var activeSteps = [];

		for( var step in statuses ) {
			if ( step.status == "active" ) {
				ArrayAppend( activeSteps, step.step );
			}
		}

		return activeSteps;
	}

	public string function getActiveStep() {
		var statuses = getAllStepStatuses();

		for( var step in statuses ) {
			if ( step.status == "active" ) {
				return step.step;
			}
		}

		return "";
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

// STEP PROXIES
	public array function getSteps() {
		var steps = [];
		for( var step in getWorkflowDefinition().getSteps() ) {
			steps.append( step.getId() );
		}

		return steps;
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