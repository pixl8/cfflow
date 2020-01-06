component accessors=true {

	property name="id"                 type="string" required=true;
	property name="screen"             type="string"  default="";
	property name="isAutomatic"        type="boolean" default=false;
	property name="meta"               type="struct";
	property name="condition"          type="WorkflowCondition";
	property name="defaultResult"      type="WorkflowResult";
	property name="conditionalResults" type="array";

	public string function getSignature() {
		var rawInput = getId() & getScreen() & getDefaultResult().getSignature();

		if ( hasCondition() ) {
			rawInput &= getCondition().getSignature();
		}

		for( var result in getConditionalResults() ) {
			rawInput &= result.getSignature();
		}

		return LCase( Hash( rawInput ) );
	}

	public any function addConditionalResult() {
		var results   = getConditionalResults();
		var newResult = new WorkflowResult( argumentCollection=arguments );

		newResult.setIsDefault( false );

		ArrayAppend( results, newResult );

		return newResult;
	}

	public array function getConditionalResults() {
		return variables.conditionalResults ?: _initConditionalResults();
	}

	private array function _initConditionalResults() {
		variables.conditionalResults = [];

		return variables.conditionalResults;
	}

	public any function setDefaultResult() {
		variables.defaultResult = new WorkflowResult( argumentCollection=arguments );
		variables.defaultResult.setIsDefault( true );
	}

	public any function getDefaultResult() {
		return variables.defaultResult ?: NullValue();
	}

	public boolean function hasCondition() {
		return !IsNull( variables.condition );
	}

	public boolean function getIsManual() {
		return !getIsAutomatic();
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}
}