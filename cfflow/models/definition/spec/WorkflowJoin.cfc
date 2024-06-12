component accessors=true {

	property name="id"                 type="string"  required=true;
	property name="meta"               type="struct";
	property name="steps"              type="array";
	property name="defaultResult"      type="WorkflowResult";
	property name="conditionalResults" type="array";

	public string function getSignature() {
		var rawInput = getId() & getDefaultResult().getSignature();

		for( var result in getConditionalResults() ) {
			rawInput &= result.getSignature();
		}

		return LCase( Hash( rawInput ) );
	}

	public struct function getMemento() {
		var memento = {
			  id                 = getId()
			, meta               = getMeta()
			, steps              = getSteps()
			, conditionalResults = []
		};

		if ( !IsNull( getDefaultResult() ) ) {
			memento.defaultResult = getDefaultResult().getMemento();
		}
		for( var cr in getConditionalResults() ) {
			ArrayAppend( memento.conditionalResults, cr.getMemento() );
		}

		return memento;
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


}