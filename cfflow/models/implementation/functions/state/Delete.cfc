component implements="cfflow.models.implementation.interfaces.IWorkflowFunction" {

	public void function do( required WorkflowInstance wfInstance, required struct args ) {
		var keys      = arguments.args.keys ?: "";
		var state     = arguments.wfInstance.getState();
		var anyChange = false;

		if ( !IsArray( keys ) && IsSimpleValue( keys ) && Len( Trim( keys ) ) ) {
			keys = [ keys ];
		}

		for( var key in keys ) {
			if ( IsSimpleValue( key ) && StructKeyExists( state, key ) )  {
				StructDelete( state, key );
				anyChange = true;
			}
		}

		if ( anyChange ) {
			arguments.wfInstance.setState( state );
		}
	}

}