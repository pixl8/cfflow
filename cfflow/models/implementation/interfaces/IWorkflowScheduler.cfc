interface {

	public void function scheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
		, required array  timers
	);

	public void function unScheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
	);

}