component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		return true;
	}

}