component accessors=true {

	property name="ref"           type="string"  required=true;
	property name="args"          type="struct"  required=false;
	property name="meta"          type="struct"  required=false;
	property name="not"           type="boolean" required=false default=false;
	property name="andConditions" type="array"   required=false;
	property name="orConditions"  type="array"   required=false;

	public WorkflowCondition function init(
		  string  ref   = ""
		, struct  args  = {}
		, struct  meta  = {}
		, boolean not   = false
		, array   and   = []
		, array   or    = []
	) {
		setRef( arguments.ref );
		setArgs( arguments.args );
		setMeta( arguments.meta );
		setNot( arguments.not );

		for( var condition in arguments.and ) {
			addAndCondition( argumentCollection=condition );
		}
		for( var condition in arguments.or ) {
			addOrCondition( argumentCollection=condition );
		}

		return this;
	}

	public string function getSignature() {
		return LCase( Hash( getRef() & SerializeJson( getArgs() ) ) );
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

	public struct function getMemento() {
		var memento = {
			  ref   = getRef()
			, args  = getArgs()
			, meta  = getMeta()
			, "not" = getNot()
			, "and" = []
			, "or"  = []
		};

		for( var c in getAndConditions() ) {
			ArrayAppend( memento[ "and" ], c.getMemento() );
		}
		for( var c in getOrConditions() ) {
			ArrayAppend( memento[ "or" ], c.getMemento() );
		}

		return memento;
	}
}