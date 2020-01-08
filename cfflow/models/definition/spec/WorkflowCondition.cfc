component accessors=true {

	property name="id"            type="string" required=true;
	property name="args"          type="struct" required=false;
	property name="meta"          type="struct" required=false;
	property name="andConditions" type="array"  required=false;
	property name="orConditions"  type="array"  required=false;

	public WorkflowCondition function init(
		  string id   = ""
		, struct args = {}
		, struct meta = {}
		, array  and  = []
		, array  or   = []
	) {
		setId( arguments.id );
		setArgs( arguments.args );
		setMeta( arguments.meta );

		for( var condition in arguments.and ) {
			addAndCondition( argumentCollection=condition );
		}
		for( var condition in arguments.or ) {
			addOrCondition( argumentCollection=condition );
		}

		return this;
	}

	public string function getSignature() {
		return LCase( Hash( getId() & SerializeJson( getArgs() ) ) );
	}

	public struct function getArgs() {
		return variables.args ?: {};
	}

	public struct function getMeta() {
		return variables.meta ?: {};
	}


	public WorkflowCondition function addAndCondition() {
		var andConditions   = getAndConditions();
		var newAndCondition = new WorkflowCondition( argumentCollection=arguments );

		ArrayAppend( andConditions, newAndCondition );

		return newAndCondition;
	}
	public array function getAndConditions() {
		return variables.andConditions ?: _initAndConditions();
	}
	private array function _initAndConditions() {
		variables.andConditions = [];

		return variables.andConditions;
	}

	public WorkflowCondition function addOrCondition() {
		var orConditions   = getOrConditions();
		var newOrCondition = new WorkflowCondition( argumentCollection=arguments );

		ArrayAppend( orConditions, newOrCondition );

		return newOrCondition;
	}
	public array function getOrConditions() {
		return variables.orConditions ?: _initOrConditions();
	}
	private array function _initOrConditions() {
		variables.orConditions = [];

		return variables.orConditions;
	}
}