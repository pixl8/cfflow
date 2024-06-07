component accessors=true {

	property name="step"     type="string"  required=true;
	property name="newStatus" type="string" required=true;
	property name="oldStatus" type="string" required=true default="pending";


	public struct function getMemento() {
		return {
			  step      = getStep()
			, newStatus = getNewStatus()
			, oldStatus = getOldStatus()
			,
		};
	}
}