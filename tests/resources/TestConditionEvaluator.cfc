component implements="cfflow.models.implementation.interfaces.IWorkflowConditionEvaluator" {

	public boolean function evaluateCondition( required WorkflowCondition wfCondition, required IWorkflowInstance wfInstance ){
		return true;
	}

}