component accessors=true {

	property name="handler" type="string" required=true;
	property name="args"    type="struct" required=false;
	property name="meta"    type="struct" required=false;

	public string function getSignature() {
		return LCase( Hash( getHandler() & SerializeJson( getArgs() ) ) );
	}

	public struct function getArgs() {
		return variables.args ?: {};
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}
}