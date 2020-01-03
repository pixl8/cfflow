interface {

	public boolean           function evaluateCondition( required WorkflowCondition wfCondition, required IWorkflowInstance wfInstance );
	public void              function executeFunction( required WorkflowFunction wfFunction, required IWorkflowInstance wfInstance );

	public void              function scheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId, required array timers );
	public void              function unScheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId );

	public any               function getInstance( required struct instanceArgs );
	public IWorkflowInstance function createInstance( required struct instanceArgs );

}