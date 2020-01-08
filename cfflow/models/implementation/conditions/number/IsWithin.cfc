component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var match = args.match ?: "";
		var range = args.range ?: "";

		return IsNumeric( value ) && IsNumeric( match ) && Abs( value - match ) <= range;
	}

}