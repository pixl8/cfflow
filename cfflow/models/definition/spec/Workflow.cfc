component accessors=true {

	property name="id"             type="string" required=true;
	property name="class"          type="string" required=true;
	property name="meta"           type="struct";
	property name="initialActions" type="array";
	property name="steps"          type="array";
	property name="joins"          type="array";
	property name="raw"            type="struct";

	public string function getSignature() {
		var rawInput = getId() & getClass();

		for( var step in getSteps() ) {
			rawInput &= step.getSignature();
		}
		for( var join in getJoins() ) {
			rawInput &= join.getSignature();
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

	public any function addJoin(
		  required string id
		,          struct meta = {}
	) {
		var joins   = getJoins();
		var newJoin = new WorkflowJoin( argumentCollection=arguments );

		ArrayAppend( joins, newJoin );

		return newJoin;
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}

	public array function getSteps() {
		return variables.steps ?: _initSteps();
	}

	public array function getJoins() {
		return variables.joins ?: _initJoins();
	}

	public struct function getRaw() {
		if ( IsNull( variables.raw ) ) {
			return getMemento();
		}

		return variables.raw;
	}

	public struct function getMemento() {
		var memento = {
			  id             = getId()
			, class          = getClass()
			, meta           = getMeta()
			, initialActions = []
			, steps          = []
			, joins          = []
		};

		for( var s in getSteps() ) {
			ArrayAppend( memento.steps, s.getMemento() );
		}
		for( var j in getJoins() ) {
			ArrayAppend( memento.joins, j.getMemento() );
		}
		for( var a in getInitialActions() ) {
			ArrayAppend( memento.initialActions, a.getMemento() );
		}

		return memento;
	}

	private array function _initSteps() {
		variables.steps = [];

		return variables.steps;
	}

	private array function _initJoins() {
		variables.joins = [];

		return variables.joins;
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