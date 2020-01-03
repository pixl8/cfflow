interface {

	public void function scheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId, required array timers );
	public void function unScheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId );

}