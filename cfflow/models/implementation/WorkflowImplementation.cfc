component accessors=true {

	property name="storageClass"       type="IWorkflowInstanceStorage";
	property name="functionExecutor"   type="IWorkflowFunctionExecutor";
	property name="conditionEvaluator" type="IWorkflowConditionEvaluator";
	property name="scheduler"          type="IWorkflowScheduler";


// STORAGE CLASS PROXIES
	public boolean function instanceExists( required string workflowId, required struct instanceArgs ){
		return getStorageClass().instanceExists( argumentCollection=arguments );
	}
	public void function createInstance( required string workflowId, required struct instanceArgs ){
		return getStorageClass().createInstance( argumentCollection=arguments );
	}
	public struct function getState( required string workflowId, required struct instanceArgs ){
		return getStorageClass().getState( argumentCollection=arguments );
	}
	public void function setState( required string workflowId, required struct instanceArgs, required struct state ){
		return getStorageClass().setState( argumentCollection=arguments );
	}
	public void function appendState( required string workflowId, required struct instanceArgs, required struct state ){
		return getStorageClass().appendState( argumentCollection=arguments );
	}
	public string function getStepStatus( required string workflowId, required struct instanceArgs, required string step ){
		return getStorageClass().getStepStatus( argumentCollection=arguments );
	}
	public void function setStepStatus( required string workflowId, required struct instanceArgs, required string step, required string status ){
		return getStorageClass().setStepStatus( argumentCollection=arguments );
	}
	public struct function getAllStepStatuses( required string workflowId, required struct instanceArgs ){
		return getStorageClass().getAllStepStatuses( argumentCollection=arguments );
	}

// EXECUTOR PROXIES
	public void function executeFunction( required WorkflowFunction wfFunction, required WorkflowInstance wfInstance ){
		return getFunctionExecutor().executeFunction( argumentCollection=arguments );
	}

// EVALUATOR PROXIES
	public boolean function evaluateCondition( required WorkflowCondition wfCondition, required WorkflowInstance wfInstance ) {
		return getConditionEvaluator().evaluateCondition( argumentCollection=arguments );
	}

// SCHEDULER PROXIES
	public void function scheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
		, required array  timers
	){
		return getScheduler().scheduleAutoActions( argumentCollection=arguments );
	}

	public void function unScheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
	){
		return getScheduler().unScheduleAutoActions( argumentCollection=arguments );
	}

}