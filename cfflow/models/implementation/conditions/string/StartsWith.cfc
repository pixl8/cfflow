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

		if ( Len( value ) < Len( pattern ) ) {
			return false;
		}

		return Compare( Left( value, Len( pattern ) ), pattern ) == 0;
	}

}