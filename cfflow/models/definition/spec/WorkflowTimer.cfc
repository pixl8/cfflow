component accessors=true {

	property name="interval" type="numeric" default=0;
	property name="count"    type="numeric" default=0;

	public struct function getMemento() {
		return {
			  interval = getInterval() & "s"
			, count    = getCount()
		};
	}

}