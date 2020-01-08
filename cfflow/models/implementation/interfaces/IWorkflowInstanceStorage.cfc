interface {

	public boolean function instanceExists( required string workflowId, required struct instanceArgs );
	public void    function createInstance( required string workflowId, required struct instanceArgs );
	public struct  function getState( required string workflowId, required struct instanceArgs );
	public void    function setState( required string workflowId, required struct instanceArgs, required struct state );
	public void    function appendState( required string workflowId, required struct instanceArgs, required struct state );
	public string  function getStepStatus( required string workflowId, required struct instanceArgs, required string step );
	public void    function setStepStatus( required string workflowId, required struct instanceArgs, required string step, required string status );
	public struct  function getAllStepStatuses( required string workflowId, required struct instanceArgs );
	public void    function setComplete( required string workflowId, required struct instanceArgs );
	public void    function recordTransition( required string workflowId, required struct instanceArgs, required string actionId, required string resultId, required array transitions );
}