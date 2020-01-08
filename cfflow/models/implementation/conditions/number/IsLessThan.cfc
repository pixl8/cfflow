component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var match = args.match ?: "";

		return IsNumeric( value ) && IsNumeric( match ) && value < match;
	}

}