component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var key = args.key ?: "";
		var state = arguments.wfInstance.getState();

		if ( IsArray( key ) ) {
			for( var k in key ) {
				if ( this.evaluate( arguments.wfInstance, { key=k } ) ) {
					return true;
				}
			}

			return false;
		}

		return Len( Trim( key ) ) && StructKeyExists( state, key );
	}

}