/**
 * The workflow implementation factory is a class that
 * provides the ability to register and fetch workflow
 * functionality implementations by classname. You are
 * able to register storage classes, functions,
 * condition evaluators, schedulers and, finally,
 * workflow classes that are a named bundle of the other
 * four implementation types.
 *
 * @singleton
 *
 */
component {

	variables._workflowClasses     = {};
	variables._storageClasses      = {};
	variables._functions           = {};
	variables._conditionEvaluators = {};
	variables._schedulers          = {};
	variables._implementations     = {};

// CONSTRUCTOR
	public any function init() {
		return this;
	}

// MAIN WORKFLOW CLASS FACTORY METHODS
	public void function registerWorkflowClass(
		  required string className
		, required string storageClass
		, required string conditionEvaluator
		, required string scheduler
	) {
		variables._workflowClasses[ arguments.className ] = {
			  storageClass       = arguments.storageClass
			, conditionEvaluator = arguments.conditionEvaluator
			, scheduler          = arguments.scheduler
		};
	}

	public WorkflowImplementation function getWorkflowImplementation( required string className ) {
		if ( !StructKeyExists( _implementations, arguments.className ) ) {
			var classes = variables._workflowClasses[ arguments.className ] ?: throw( "The workflow class, [#arguments.className#], is not registered with the workflow implementation library.", "cfflow.workflow.class.not.exists", "Registered implementations: [#StructKeyList( variables._workflowClasses )#]" );

			_implementations[ arguments.className ] = new WorkflowImplementation(
				  storageClass       = getStorageClass( classes.storageClass )
				, conditionEvaluator = getConditionEvaluator( classes.conditionEvaluator )
				, scheduler          = getScheduler( classes.scheduler )
			);
		}

		return _implementations[ arguments.className ];
	}

// STORAGE CLASSES
	public void function registerStorageClass(
		  required string                   className
		, required IWorkflowInstanceStorage implementation
	) {
		variables._storageClasses[ arguments.className ] = arguments.implementation;
	}
	public IWorkflowInstanceStorage function getStorageClass( required string className ) {
		return variables._storageClasses[ arguments.className ] ?: throw( "The workflow instance storage class, [#arguments.className#], is not registered with the workflow implementation library.", "cfflow.storage.class.not.exists", "Registered implementations: [#StructKeyList( variables._storageClasses )#]" );
	}

// CONDiTION EVALUATORS
	public void function registerConditionEvaluator(
		  required string                       className
		, required IWorkflowConditionEvaluator implementation
	) {
		variables._conditionEvaluators[ arguments.className ] = arguments.implementation;
	}
	public IWorkflowConditionEvaluator function getConditionEvaluator( required string className ) {
		return variables._conditionEvaluators[ arguments.className ] ?: throw( "The workflow condition evaluator class, [#arguments.className#], is not registered with the workflow implementation library.", "cfflow.condition.evaluator.not.exists", "Registered implementations: [#StructKeyList( variables._conditionEvaluators )#]" );
	}

// SCHEDULERS
	public void function registerScheduler(
		  required string             className
		, required IWorkflowScheduler implementation
	) {
		variables._schedulers[ arguments.className ] = arguments.implementation;
	}
	public IWorkflowScheduler function getScheduler( required string className ) {
		return variables._schedulers[ arguments.className ] ?: throw( "The workflow scheduler class, [#arguments.className#], is not registered with the workflow implementation library.", "cfflow.scheduler.not.exists", "Registered implementations: [#StructKeyList( variables._schedulers )#]" );
	}

// FUNCTIONS
	public void function registerFunction(
		  required string            id
		, required IWorkflowFunction implementation
	) {
		variables._functions[ arguments.id ] = arguments.implementation;
	}
	public IWorkflowFunction function getFunction( required string id ) {
		return variables._functions[ arguments.id ] ?: throw( "The workflow function class, [#arguments.id#], is not registered with the workflow implementation library.", "cfflow.function.not.exists", "Registered functions: [#StructKeyList( variables._functions )#]" );
	}
}