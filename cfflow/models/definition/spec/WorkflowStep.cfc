component accessors=true {

	property name="id"               type="string"  required=true;
	property name="meta"             type="struct";
	property name="autoActionTimers" type="array"   required=false;
	property name="actions"          type="array"   required=false;
	property name="_hasAutoActions"  type="boolean";

	public string function getSignature() {
		var rawInput = getId();

		for( var action in getActions() ) {
			rawInput &= action.getSignature();
		}

		return LCase( Hash( rawInput ) );
	}

	public any function addAction() {
		var actions   = getActions();
		var newAction = new WorkflowAction( argumentCollection=arguments );

		ArrayAppend( actions, newAction );

		return newAction;
	}

	public array function getActions() {
		return variables.actions ?: _initActions();
	}

	private array function _initActions() {
		variables.actions = [];

		return variables.actions;
	}

	public any function addAutoActionTimer() {
		var timers   = getAutoActionTimers();
		var newTimer = new WorkflowTimer( argumentCollection=arguments );

		ArrayAppend( timers, newTimer );

		return newTimer;
	}

	public array function getAutoActionTimers() {
		return variables.autoActionTimers ?: _initAutoActionTimers();
		return [];
	}

	private array function _initAutoActionTimers() {
		variables.autoActionTimers = [];

		return variables.autoActionTimers;
	}

	public boolean function hasAutoActionTimers() {
		return ArrayLen( getAutoActionTimers() ) > 0;
	}

	public boolean function hasAutoActions() {
		if ( IsNull( variables._hasAutoActions ) ) {
			variables._hasAutoActions = false;
			for( var action in getActions() ) {
				if ( action.getIsAutomatic() ) {
					variables._hasAutoActions = true;
					break;
				}
			}
		}

		return variables._hasAutoActions;
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}
}