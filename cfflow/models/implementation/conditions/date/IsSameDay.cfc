component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public void function init() {
		variables.util = new cfflow.models.util.WorkflowSchemaUtil();
	}

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var match = args.match ?: "";

		if ( !IsDate( value ) || !IsDate( match ) ) {
			return false;
		}

		return DateDiff( 'd', value, match ) == 0;
	}

}