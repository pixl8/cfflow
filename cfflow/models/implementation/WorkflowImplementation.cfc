component accessors=true {

	property name="storageClass"       type="IWorkflowInstanceStorage";
	property name="functionExecutor"   type="IWorkflowFunctionExecutor";
	property name="conditionEvaluator" type="IWorkflowConditionEvaluator";
	property name="scheduler"          type="IWorkflowScheduler";


// STORAGE CLASS PROXIES
	public boolean function instanceExists( required struct instanceArgs ){
		return getStorageClass().instanceExists( argumentCollection=arguments );
	}
	public void function createInstance( required struct instanceArgs ){
		return getStorageClass().createInstance( argumentCollection=arguments );
	}
	public struct function getState( required struct instanceArgs ){
		return getStorageClass().getState( argumentCollection=arguments );
	}
	public void function setState( required struct instanceArgs, required struct state ){
		return getStorageClass().setState( argumentCollection=arguments );
	}
	public void function appendState( required struct instanceArgs, required struct state ){
		return getStorageClass().appendState( argumentCollection=arguments );
	}
	public string function getStepStatus( required struct instanceArgs, required string step ){
		return getStorageClass().getStepStatus( argumentCollection=arguments );
	}
	public void function setStepStatus( required struct instanceArgs, required string step, required string status ){
		return getStorageClass().setStepStatus( argumentCollection=arguments );
	}
	public struct function getAllStepStatuses( required struct instanceArgs ){
		return getStorageClass().getAllStepStatuses( argumentCollection=arguments );
	}

}