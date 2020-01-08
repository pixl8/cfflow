component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

	public boolean function evaluate( required WorkflowInstance wfInstance, required struct args ){
		var value = args.value ?: "";
		var pattern = args.pattern ?: "";

		if ( IsArray( pattern ) ) {
			for( var p in pattern ) {
				if ( this.evaluate( arguments.wfInstance, { value=value, pattern=p } ) ) {
					return true;
				}
			}

			return false;
		}

		return ReFindNoCase( pattern, value ) > 0;
	}

}