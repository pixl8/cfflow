component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var steps        = args.steps ?: "";
		var stepStatuses = arguments.wfInstance.getAllStepStatuses();
		var skippedSteps = [];
		var skipped      = true;

		if ( IsSimpleValue( steps ) ) {
			steps = [ steps ];
		}

		if ( IsArray( steps ) && ArrayLen( steps ) ) {
			for( var ss in stepStatuses ) {
				if ( ss.status == "skipped" ) {
					ArrayAppend( skippedSteps, ss.step );
				}
			}
			for( var s in steps ) {
				if ( !ArrayFindNoCase( skippedSteps, s ) ) {
					skipped = false;
					break;
				}
			}
		}

		return skipped;
	}

}