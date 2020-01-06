component implements="cfflow.models.implementation.interfaces.IWorkflowInstanceStorage" {

	public boolean function instanceExists( required string workflowId, required struct instanceArgs ){ return false; }

	public void function createInstance( required string workflowId, required struct instanceArgs ){}

	public struct  function getState( required string workflowId, required struct instanceArgs ){ return {}; }

	public void function setState( required string workflowId, required struct instanceArgs, required struct state ){}

	public void function appendState( required string workflowId, required struct instanceArgs, required struct state ){}

	public string function getStepStatus( required string workflowId, required struct instanceArgs, required string step ){ return "pending"; }

	public void function setStepStatus( required string workflowId, required struct instanceArgs, required string step, required string status ){}

	public struct function getAllStepStatuses( required string workflowId, required struct instanceArgs ){ return {}; }

}