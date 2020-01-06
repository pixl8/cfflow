component accessors=true {

	property name="id"             type="string" required=true;
	property name="class"          type="string" required=true;
	property name="meta"           type="struct";
	property name="initialActions" type="array";
	property name="steps"          type="array";

	public string function getSignature() {
		var rawInput = getId() & getClass();

		for( var step in getSteps() ) {
			rawInput &= step.getSignature();
		}

		return LCase( Hash( rawInput ) );
	}

	public any function addStep(
		  required string id
		,          struct meta = {}
	) {
		var steps   = getSteps();
		var newStep = new WorkflowStep( argumentCollection=arguments );

		ArrayAppend( steps, newStep );

		return newStep;
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}

	public array function getSteps() {
		return variables.steps ?: _initSteps();
	}

	private array function _initSteps() {
		variables.steps = [];

		return variables.steps;
	}

	public any function addInitialAction() {
		var actions   = getInitialActions();
		var newAction = new WorkflowAction( argumentCollection=arguments );

		ArrayAppend( actions, newAction );

		return newAction;
	}

	public array function getInitialActions() {
		return variables.initialActions ?: _initInitialActions();
	}

	private array function _initInitialActions() {
		variables.initialActions = [];

		return variables.initialActions;
	}
}