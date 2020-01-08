component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public void function init() {
		variables.util = new cfflow.models.util.WorkflowSchemaUtil();
	}

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var offset = args.offset ?: "";
		var offsetConverted = 0;
		var match = Now();

		if ( !IsDate( value ) ) {
			return false;
		}

		if ( Len( Trim( offset ) ) ) {
			offsetConverted = util.convertTimeIntervalToSeconds( ReReplace( offset, "^\-", "" ) );
			if ( ReFind( "^\-", offset ) ) {
				offsetConverted = 0-offsetConverted;
			}

			if ( offsetConverted ) {
				match = DateAdd( 's', offsetConverted, match );
			}
		}

		return value > match;
	}

}