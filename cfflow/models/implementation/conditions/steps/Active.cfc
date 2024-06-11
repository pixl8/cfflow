component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var steps        = args.steps ?: "";
		var activeSteps  = arguments.wfInstance.getActiveSteps();
		var active       = true;

		if ( IsSimpleValue( steps ) ) {
			steps = [ steps ];
		}

		if ( IsArray( steps ) && ArrayLen( steps ) ) {
			for( var s in steps ) {
				if ( !ArrayFindNoCase( activeSteps, s ) ) {
					active = false;
					break;
				}
			}
		}

		return active;
	}

}