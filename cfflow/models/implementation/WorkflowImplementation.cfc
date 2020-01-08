component accessors=true {

	property name="storageClass" type="IWorkflowInstanceStorage";
	property name="scheduler"    type="IWorkflowScheduler";

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

	public void function setComplete( required string workflowId, required struct instanceArgs ){
		return getStorageClass().setComplete( argumentCollection=arguments );
	}

	public void function recordTransition( required string workflowId, required struct instanceArgs, required string actionId, required string resultId, required array transitions ){
		return getStorageClass().recordTransition( argumentCollection=arguments );
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