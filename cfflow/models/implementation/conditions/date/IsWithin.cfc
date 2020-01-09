component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public void function init() {
		variables.util = new cfflow.models.util.WorkflowSchemaUtil();
	}

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var match = args.match ?: "";
		var range = args.range ?: "";

		if ( !IsDate( value ) || !IsDate( match ) || !Len( Trim( range ) ) ) {
			return false;
		}

		var diff = Abs( DateDiff( 's', value, match ) );

		return diff <= util.convertTimeIntervalToSeconds( range );
	}

}