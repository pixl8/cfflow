component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var steps          = args.steps ?: "";
		var stepStatuses   = arguments.wfInstance.getAllStepStatuses();
		var completedSteps = [];
		var completed      = true;

		if ( IsSimpleValue( steps ) ) {
			steps = [ steps ];
		}

		if ( IsArray( steps ) && ArrayLen( steps ) ) {
			for( var ss in stepStatuses ) {
				if ( ss.status == "complete" || ss.status == "skipped" ) {
					ArrayAppend( completedSteps, ss.step );
				}
			}
			for( var s in steps ) {
				if ( !ArrayFindNoCase( completedSteps, s ) ) {
					completed = false;
					break;
				}
			}
		}

		return completed;
	}

}