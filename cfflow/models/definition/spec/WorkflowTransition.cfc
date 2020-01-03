component accessors=true {

	property name="step"   type="string"  required=true;
	property name="status" type="string"  required=true;

	public string function getSignature() {
		return LCase( Hash( getStep() & getStatus() ) );
	}

	public any function setStatus( required string status ) {
		var validStatuses = [ "pending", "active", "complete", "skipped" ];

		if ( ArrayFindNoCase( validStatuses, arguments.status ) ) {
			variables.status = arguments.status;
			return;
		}

		throw( type="workflow.stepchange.invalid.status", message="Invalid value, [#arguments.status#], for status field for the workflow step change object. Valid values are either 'pending', 'active', 'complete' or 'skipped'." );
	}
}