interface {

	public string function getWorkflowId();
	public struct function getState();
	public void   function setState( required struct state );
	public string function getStatus( required string step );
	public void   function setStatus( required string step, required string status );

}