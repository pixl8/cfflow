component implements="cfflow.models.implementation.interfaces.IWorkflowFunction" {

	public void function do( required WorkflowInstance wfInstance, required struct args ) {
		if ( StructCount( args ) ) {
			arguments.wfInstance.appendState( arguments.args );
		}
	}

}