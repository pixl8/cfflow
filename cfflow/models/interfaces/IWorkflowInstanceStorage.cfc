interface {

	public boolean function instanceExists( required struct instanceArgs );
	public void    function createInstance( required struct instanceArgs );
	public struct  function getState( required struct instanceArgs );
	public void    function setState( required struct instanceArgs, required struct state );
	public void    function appendState( required struct instanceArgs, required struct state );
	public string  function getStepStatus( required struct instanceArgs, required string step );
	public void    function setStepStatus( required struct instanceArgs, required string step, required string status );

}