component accessors=true {

	property name="id"        type="string" required=true;
	property name="preOrPost" type="string" required=true;
	property name="meta"      type="struct";
	property name="args"      type="struct";
	property name="condition" type="WorkflowCondition";

	public any function setPreOrPost( required string preOrPost ) {
		if ( arguments.preOrPost == "pre" || arguments.preOrPost == "post" ) {
			variables.preOrPost = arguments.preOrPost;
			return;
		}

		throw( type="workflow.function.invalid.preOrPost", message="Invalid value, [#arguments.preOrPost#], for preOrPost field for the workflow function object. Valid values are either 'pre' or 'post'." );
	}

	public boolean function hasCondition() {
		return !IsNull( variables.condition );
	}

	public struct function getArgs() {
		return variables.args ?: {};
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}
}