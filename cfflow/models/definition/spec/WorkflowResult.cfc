component accessors=true {

	property name="id"            type="string"  required=true;
	property name="title"         type="string"  required=true;
	property name="type"          type="string"  required=true;
	property name="isDefault"     type="boolean" required=true;
	property name="condition"     type="WorkflowCondition";
	property name="transitions"   type="array";
	property name="preFunctions"  type="array";
	property name="postFunctions" type="array";

	public string function getSignature() {
		var rawInput = getId() & getType() & getIsDefault() & getCondition();

		for( var transition in getTransitions() ) {
			rawInput &= transition.getSignature();
		}

		return LCase( Hash( rawInput ) );
	}

	public any function addTransition( required string step, required string status ) {
		var transitions   = getTransitions();
		var newTransition = new WorkflowTransition( argumentCollection=arguments );

		ArrayAppend( transitions, newTransition );

		return newTransition;
	}
	public array function getTransitions() {
		return variables.transitions ?: _initTransitions();
	}
	private array function _initTransitions() {
		variables.transitions = [];

		return variables.transitions;
	}

	public any function addPreFunction(
		  required string            id
		, required string            title
		, required string            handler
		,          WorkflowCondition condition
	) {
		var preFunctions = getPreFunctions();
		var newFunction  = new WorkflowFunction( argumentCollection=arguments );

		newFunction.setPreOrPost( "pre" );

		ArrayAppend( preFunctions, newFunction );

		return newFunction;
	}
	public array function getPreFunctions() {
		return variables.preFunctions ?: _initPreFunctions();
	}
	private array function _initPreFunctions() {
		variables.preFunctions = [];

		return variables.preFunctions;
	}

	public any function addPostFunction(
		  required string            id
		, required string            title
		, required string            handler
		,          WorkflowCondition condition
	) {
		var postFunctions = getPostFunctions();
		var newFunction  = new WorkflowFunction( argumentCollection=arguments );

		newFunction.setPreOrPost( "post" );

		ArrayAppend( postFunctions, newFunction );

		return newFunction;
	}
	public array function getPostFunctions() {
		return variables.postFunctions ?: _initPostFunctions();
	}
	private array function _initPostFunctions() {
		variables.postFunctions = [];

		return variables.postFunctions;
	}

	public any function setType( required string resultType ) {
		var validTypes = [ "step", "split", "join" ];

		if ( ArrayFindNoCase( validTypes, arguments.resultType ) ) {
			variables.type = arguments.resultType;
			return;
		}

		throw( type="workflow.result.invalid.type", message="Invalid value, [#arguments.resultType#], for type field for the workflow result object. Valid values are either 'step', 'split' or 'join'." );
	}

	public boolean function hasCondition() {
		return !IsNull( variables.condition );
	}
}