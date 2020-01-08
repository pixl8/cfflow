component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";

		return CompareNoCase( value, "true" ) == 0;
	}

}