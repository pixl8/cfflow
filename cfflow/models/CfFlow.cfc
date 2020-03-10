/**
 * The CfFlow class is the entry point for all cfflow
 * implementation programmers to interact with workflow
 * definitions and instances.
 */
component singleton {

	public any function init() {
		_setWorkflowLibrary( new definition.WorkflowLibrary() );
		_setWorkflowArgSubstitutor( new substitution.workflowArgSubstitutor() );
		_setImplementationFactory( new implementation.WorkflowImplementationFactory() );
		_setWorkflowEngine( new engine.WorkflowEngine(
			  implementationFactory  = getImplementationFactory()
			, workflowLibrary        = getWorkflowLibrary()
			, workflowArgSubstitutor = getWorkflowArgSubstitutor()
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

		_registerBuiltInConditions();
		_registerBuiltInFunctions();

		return this;
	}

// INSTANCES
	public boolean function instanceExists( required string workflowId, struct instanceArgs={} ) {
		var wf   = _getWorkflowDefinition( arguments.workflowId );
		var impl = getWorkflowEngine().getImplementation( wf );

		return impl.instanceExists( workflowId=arguments.workflowId, instanceArgs=arguments.instanceArgs );
	}

	public any function getInstance( required string workflowId, struct instanceArgs={} ) {
		var engine         = getWorkflowEngine();
		var wf             = _getWorkflowDefinition( arguments.workflowId );
		var impl           = engine.getImplementation( wf );
		var instanceExists = impl.instanceExists( workflowId=arguments.workflowId, instanceArgs=arguments.instanceArgs );

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
		var engine     =  getWorkflowEngine();
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
		var lib = getWorkflowLibrary();

		// given a workflow object already parsed
		if ( IsInstanceOf( arguments.wf, "Workflow" ) ) {
			lib.registerWorkflow( wf=arguments.wf );

		// given a simple struct, ready for parsing
		} else if ( IsStruct( arguments.wf ) && !IsObject( arguments.wf ) ) {
			lib.registerWorkflow( wf=getWorkflowReader().read( arguments.wf ) );

		// given a string
		} else if ( IsSimpleValue( arguments.wf ) ) {
			// if a file path, presume a YAML file with workflow definition
			if ( FileExists( arguments.wf ) ) {
				lib.registerWorkflow( wf=getYamlWorkflowReader().read( FileRead( arguments.wf ) ) );

			// otherwise, presume YAML string
			} else {
				lib.registerWorkflow( wf=getYamlWorkflowReader().read( arguments.wf ) );
			}
		}
	}

// IMPLEMENTATION PROXIES
	public void function registerWorkflowClass(
		  required string className
		, required string storageClass
		, required string scheduler
	) {
		getImplementationFactory().registerWorkflowClass( argumentCollection=arguments );
	}
	public void function registerStorageClass(
		  required string                   className
		, required IWorkflowInstanceStorage implementation
	) {
		getImplementationFactory().registerStorageClass( argumentCollection=arguments );
	}
	public void function registerScheduler(
		  required string             className
		, required IWorkflowScheduler implementation
	) {
		getImplementationFactory().registerScheduler( argumentCollection=arguments );
	}
	public void function registerFunction(
		  required string            id
		, required IWorkflowFunction implementation
	) {
		getImplementationFactory().registerFunction( argumentCollection=arguments );
	}
	public void function registerCondition(
		  required string             id
		, required IWorkflowCondition implementation
	) {
		getImplementationFactory().registerCondition( argumentCollection=arguments );
	}
	public void function registerTokenProvider( required IWorkflowArgSubstitutionProvider provider ) {
		getWorkflowArgSubstitutor().registerTokenProvider( arguments.provider );
	}

// PRIVATE HELPERS
	private any function _getWorkflowDefinition( required string workflowId ) {
		return getWorkflowLibrary().getWorkflow( arguments.workflowId );
	}

	private void function _registerBuiltInConditions() {
		var root = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/implementation/conditions";
		var rootCfcPath = "implementation.conditions";
		var conditionCfcs = DirectoryList( root, true, "path", "*.cfc" );

		for( var conditionCfc in conditionCfcs ) {
			var relPath = Right( conditionCfc, Len( conditionCfc ) - Len( root ) );
			    relPath = Replace( relPath, "/", ".", "all" );
			    relPath = Replace( relPath, "\", ".", "all" );
			    relPath = ReReplaceNoCase( relPath, ".cfc$", "", "all" );

			registerCondition( id=relPath, implementation=CreateObject( rootCfcPath & "." & relPath ) );
		}
	}

	private void function _registerBuiltInFunctions() {
		var root = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/implementation/functions";
		var rootCfcPath = "implementation.functions";
		var functionCfcs = DirectoryList( root, true, "path", "*.cfc" );

		for( var functionCfc in functionCfcs ) {
			var relPath = Right( functionCfc, Len( functionCfc ) - Len( root ) );
			    relPath = Replace( relPath, "/", ".", "all" );
			    relPath = Replace( relPath, "\", ".", "all" );
			    relPath = ReReplaceNoCase( relPath, ".cfc$", "", "all" );

			registerFunction( id=relPath, implementation=CreateObject( rootCfcPath & "." & relPath ) );
		}
	}

// GETTERS AND SETTERS
	public any function getWorkflowLibrary() {
	    return _workflowLibrary;
	}
	private void function _setWorkflowLibrary( required any workflowLibrary ) {
	    _workflowLibrary = arguments.workflowLibrary;
	}

	public any function getImplementationFactory() {
	    return _implementationFactory;
	}
	private void function _setImplementationFactory( required any implementationFactory ) {
	    _implementationFactory = arguments.implementationFactory;
	}

	public any function getWorkflowEngine() {
	    return _workflowEngine;
	}
	private void function _setWorkflowEngine( required any workflowEngine ) {
	    _workflowEngine = arguments.workflowEngine;
	}

	public any function getWorkflowReader() {
	    return _workflowReader;
	}
	private void function _setWorkflowReader( required any workflowReader ) {
	    _workflowReader = arguments.workflowReader;
	}

	public any function getYamlWorkflowReader() {
	    return _yamlWorkflowReader;
	}
	private void function _setYamlWorkflowReader( required any yamlWorkflowReader ) {
	    _yamlWorkflowReader = arguments.yamlWorkflowReader;
	}

	public any function getWorkflowArgSubstitutor() {
	    return _workflowArgSubstitutor;
	}
	private void function _setWorkflowArgSubstitutor( required any workflowArgSubstitutor ) {
	    _workflowArgSubstitutor = arguments.workflowArgSubstitutor;
	}

}