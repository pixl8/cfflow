/**
 * The CfFlow class is the entry point for all cfflow
 * implementation programmers to interact with workflow
 * definitions and instances.
 */
component singleton {

	public any function init() {
		_setWorkflowLibrary( new definition.WorkflowLibrary() );
		_setImplementationFactory( new implementation.WorkflowImplementationFactory() );
		_setWorkflowEngine( new engine.WorkflowEngine(
			  implementationFactory = _getImplementationFactory()
			, workflowLibrary       = _getWorkflowLibrary()
		) );
		_setWorkflowReader( new definition.readers.WorkflowReader(
			  workflowFactory = new definition.WorkflowFactory()
			, schemaValidator = new definition.validation.WorkflowSchemaValidator()
			, schemaUtil      = new util.WorkflowSchemaUtil()
		) );
		_setYamlWorkflowReader( new definition.readers.WorkflowYamlReader(
			  workflowFactory = new definition.WorkflowFactory()
			, schemaValidator = new definition.validation.WorkflowSchemaValidator()
			, schemaUtil      = new util.WorkflowSchemaUtil()
			, yamlParser      = new util.YamlParser()
		) );

		return this;
	}

// INSTANCES
	public boolean function instanceExists( required string workflowId, struct instanceArgs={} ) {
		var wf   = _getWorkflowDefinition( arguments.workflowId );
		var impl = _getWorkflowEngine().getImplementation( wf );

		return impl.instanceExists( instanceArgs=arguments.instanceArgs );
	}

	public any function getInstance( required string workflowId, struct instanceArgs={} ) {
		var engine         = _getWorkflowEngine();
		var wf             = _getWorkflowDefinition( arguments.workflowId );
		var impl           = engine.getImplementation( wf );
		var instanceExists = impl.instanceExists( instanceArgs=arguments.instanceArgs );

		if ( instanceExists ) {
			return new instances.WorkflowInstance(
				  workflowId             = arguments.workflowId
				, instanceArgs           = arguments.instanceArgs
				, workflowDefinition     = wf
				, workflowImplementation = impl
				, workflowEngine         = engine
			);
		}

		return;
	}

	public WorkflowInstance function createInstance( required string workflowId, struct instanceArgs={}, struct initialState={}, string initialActionId ) {
		var engine     =  _getWorkflowEngine();
		var engine     =  _getWorkflowEngine();
		var wf         = _getWorkflowDefinition( arguments.workflowId );
		var impl       = engine.getImplementation( wf );
		var wfInstance = "";

		impl.createInstance(
			  workflowId   = arguments.workflowId
			, instanceArgs = arguments.instanceArgs
		);
		wfInstance = getInstance( workflowId=arguments.workflowId, instanceArgs=arguments.instanceArgs );

		engine.initializeInstance(
			  wfInstance      = wfInstance
			, initialState    = arguments.initialState
			, initialActionId = arguments.initialActionId ?: NullValue()
		);

		return wfInstance;
	}

	public boolean function doAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
	) {
		var instance = getInstance( workflowId=arguments.workflowId, instanceArgs=instanceArgs );

		if ( !IsNull( local.instance ) ) {
			return instance.doAutoActions( stepId=arguments.stepId )
		}

		return false;
	}

// LIBRARY PROXIES
	public void function registerWorkflow( required any wf ) {
		var lib = _getWorkflowLibrary();

		// given a workflow object already parsed
		if ( IsInstanceOf( arguments.wf, "Workflow" ) ) {
			lib.registerWorkflow( wf=arguments.wf );

		// given a simple struct, ready for parsing
		} else if ( IsStruct( arguments.wf ) && !IsObject( arguments.wf ) ) {
			lib.registerWorkflow( wf=_getWorkflowReader().read( arguments.wf ) );

		// given a string
		} else if ( IsSimpleValue( arguments.wf ) ) {
			// if a file path, presume a YAML file with workflow definition
			if ( FileExists( arguments.wf ) ) {
				lib.registerWorkflow( wf=_getYamlWorkflowReader().read( FileRead( arguments.wf ) ) );

			// otherwise, presume YAML string
			} else {
				lib.registerWorkflow( wf=_getYamlWorkflowReader().read( arguments.wf ) );
			}
		}
	}

// IMPLEMENTATION PROXIES
	public void function registerWorkflowClass(
		  required string className
		, required string storageClass
		, required string functionExecutor
		, required string conditionEvaluator
		, required string scheduler
	) {
		_getImplementationFactory().registerWorkflowClass( argumentCollection=arguments );
	}
	public void function registerStorageClass(
		  required string                   className
		, required IWorkflowInstanceStorage implementation
	) {
		_getImplementationFactory().registerStorageClass( argumentCollection=arguments );
	}
	public void function registerFunctionExecutor(
		  required string                    className
		, required IWorkflowFunctionExecutor implementation
	) {
		_getImplementationFactory().registerFunctionExecutor( argumentCollection=arguments );
	}
	public void function registerConditionEvaluator(
		  required string                       className
		, required IWorkflowConditionEvaluator implementation
	) {
		_getImplementationFactory().registerConditionEvaluator( argumentCollection=arguments );
	}
	public void function registerScheduler(
		  required string             className
		, required IWorkflowScheduler implementation
	) {
		_getImplementationFactory().registerScheduler( argumentCollection=arguments );
	}

// PRIVATE HELPERS
	private any function _getWorkflowDefinition( required string workflowId ) {
		return _getWorkflowLibrary().getWorkflow( arguments.workflowId );
	}

// GETTERS AND SETTERS
	private any function _getWorkflowLibrary() {
	    return _workflowLibrary;
	}
	private void function _setWorkflowLibrary( required any workflowLibrary ) {
	    _workflowLibrary = arguments.workflowLibrary;
	}

	private any function _getImplementationFactory() {
	    return _implementationFactory;
	}
	private void function _setImplementationFactory( required any implementationFactory ) {
	    _implementationFactory = arguments.implementationFactory;
	}

	private any function _getWorkflowEngine() {
	    return _workflowEngine;
	}
	private void function _setWorkflowEngine( required any workflowEngine ) {
	    _workflowEngine = arguments.workflowEngine;
	}

	private any function _getWorkflowReader() {
	    return _workflowReader;
	}
	private void function _setWorkflowReader( required any workflowReader ) {
	    _workflowReader = arguments.workflowReader;
	}

	private any function _getYamlWorkflowReader() {
	    return _yamlWorkflowReader;
	}
	private void function _setYamlWorkflowReader( required any yamlWorkflowReader ) {
	    _yamlWorkflowReader = arguments.yamlWorkflowReader;
	}

}