component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "CfFlow API Object", function() {
			var _library = "";
			var _implFactory = "";
			var _engine  = "";
			var _impl = "";
			var _instance  = "";
			var _instanceArgs = { test=true };
			var _steps  = "";
			var _wfId  = "";
			var _wf  = "";
			var _reader = "";
			var _yamlReader = "";

			beforeEach( function(){
				_library     = CreateEmptyMock( "cfflow.models.definition.WorkflowLibrary" );
				_implFactory = CreateEmptyMock( "cfflow.models.implementation.WorkflowImplementationFactory" );
				_impl        = CreateMock( "cfflow.models.implementation.WorkflowImplementation" );
				_engine      = CreateMock( object=new cfflow.models.engine.WorkflowEngine( implementationFactory=_implFactory, workflowLibrary=_library ) );
				_cfflow      = CreateMock( object=new cfflow.models.CfFlow() );
				_wfId        = CreateUUId();
				_instance    = CreateMock( "cfflow.models.instances.WorkflowInstance" );
				_wf          = CreateMock( "cfflow.models.definition.spec.Workflow" );
				_reader      = CreateMock( "cfflow.models.definition.readers.WorkflowReader" );
				_yamlReader  = CreateMock( "cfflow.models.definition.readers.WorkflowYamlReader" );
				_steps       = [];

				_cfflow.$( "_getWorkflowLibrary", _library );
				_cfflow.$( "_getImplementationFactory", _implFactory );
				_cfflow.$( "_getWorkflowEngine", _engine );
				_cfflow.$( "_getWorkflowReader", _reader );
				_cfflow.$( "_getYamlWorkflowReader", _yamlReader );

				for( var i=1; i<=5; i++ ) {
					_steps.append( CreateMock( "cfflow.models.definition.spec.WorkflowStep" ) );
					_steps[ i ].$( "getId", "step-#i#" );
				}

				_wf.$( "getId", _wfId );
				_wf.$( "getSteps", _steps );
				_instance.$( "getWorkflowId", _wfId );
				_instance.setWorkflowImplementation( _impl );
				_instance.setInstanceArgs( _instanceArgs );
				_library.$( "getWorkflow" ).$args( _wfId ).$results( _wf );
				_impl.$( "setStepStatus" );

			} );

			describe( "Interacting with instances", function(){

				describe( "getInstance( workflowId, instanceArgs )", function(){
					it( "should construct a new workflow instance with the given args", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };

						_engine.$( "getImplementation" ).$args( _wf ).$results( _impl );
						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( true );

						var instance = _cfflow.getInstance( _wfId, instanceArgs );

						expect( instance.getWorkflowId() ).toBe( _wfId );
						expect( instance.getInstanceArgs() ).toBe( instanceArgs );
						expect( instance.getWorkflowDefinition() ).toBe( _wf );
						expect( instance.getWorkflowImplementation() ).toBe( _impl );
					} );

					it( "should return NULL when no instance exists", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };

						_engine.$( "getImplementation" ).$args( _wf ).$results( _impl );
						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( false );

						expect( _cfflow.getInstance( _wfId, instanceArgs ) ).toBeNull();
					} );
				} );

				describe( "instanceExists( workflowId, instanceArgs )", function(){
					it( "should proxy to the implementation's instanceExists method", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };

						_engine.$( "getImplementation" ).$args( _wf ).$results( _impl );

						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( true );
						expect( _cfflow.instanceExists( _wfId, instanceArgs ) ).toBe( true );

						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( false );
						expect( _cfflow.instanceExists( _wfId, instanceArgs ) ).toBe( false );
					} );
				} );

				describe( "createInstance( workflowId, instanceArgs, initialState, initialActionId )", function(){
					it( "should use the workflowIds corresponding workflow implementation to get a new workflow instance using the supplied instance args", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };

						_impl.$( "createInstance" );
						_engine.$( "getImplementation" ).$args( _wf ).$results( _impl );
						_engine.$( "initializeInstance" );
						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( true );

						var instance = _cfflow.createInstance( _wfId, instanceArgs, {} );

						var callLog = _impl.$callLog().createInstance;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ].instanceArgs ).toBe( instanceArgs );
						expect( callLog[ 1 ].workflowId ).toBe( _wfId );

						expect( instance.getWorkflowId() ).toBe( _wfId );
						expect( instance.getInstanceArgs() ).toBe( instanceArgs );
						expect( instance.getWorkflowDefinition() ).toBe( _wf );
						expect( instance.getWorkflowImplementation() ).toBe( _impl );
					} );


					it( "should pass the initial action ID to the initializeInstance method when set", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };
						var initialState = { test=true, fubar=CreateUUId() }
						var initialActionId = CreateUUId();

						_impl.$( "createInstance" );
						_engine.$( "getImplementation" ).$args( _wf ).$results( _impl );
						_engine.$( "initializeInstance" );
						_impl.$( "instanceExists" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( true );

						var instance = _cfflow.createInstance( _wfId, instanceArgs, initialState, initialActionId );
						var callLog = _engine.$callLog().initializeInstance;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ].wfInstance ).toBe( instance );
						expect( callLog[ 1 ].initialState ).toBe( initialState );
						expect( callLog[ 1 ].initialActionId ).toBe( initialActionId );

					} );
				} );

				describe( "doAutoActions( workflowId, instanceArgs, stepId )", function(){
					it( "should proxy to the instance.doAutoActions() method", function(){
						var instanceArgs = { test=CreateUUId(), args={ yes="test", no=false } };
						var mockInstance = createMock( "cfflow.models.instances.WorkflowInstance" );
						var stepId       = CreateUUId();

						_cfflow.$( "getInstance" ).$args( workflowId=_wfId, instanceArgs=instanceArgs ).$results( mockInstance );
						mockInstance.$( "doAutoActions", true );

						expect( _cfFlow.doAutoActions( workflowId=_wfId, instanceArgs=instanceArgs, stepId=stepId ) ).toBe( true );

						var callLog = mockInstance.$callLog().doAutoActions;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ] ).toBe( { stepId=stepId } );
					} );
				} );
			} );

			describe( "Library proxies", function(){
				describe( "registerWorkflow( any flow )", function(){
					it( "should directly proxy to the library passing in the passed Workflow object", function(){
						_library.$( "registerWorkflow" );

						_cfflow.registerWorkflow( _wf );

						var callLog = _library.$callLog().registerWorkflow;

						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ][ 1 ] ).toBe( _wf );
					} );

					it( "it should first convert the passed workflow from a struct to a workflow object when passed a struct", function(){
						var flow = { some="struct" };

						_library.$( "registerWorkflow" );
						_reader.$( "read" ).$args( flow ).$results( _wf );

						_cfflow.registerWorkflow( flow );

						var callLog = _library.$callLog().registerWorkflow;

						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ][ 1 ] ).toBe( _wf );
					} );

					it( "should attempt registering a workflow from a yaml file path", function(){
						var flow = "/tests/resources/yaml/fullSpecExample.yaml";
						var yaml = FileRead( flow );

						_library.$( "registerWorkflow" );
						_yamlReader.$( "read" ).$args( yaml ).$results( _wf );

						_cfflow.registerWorkflow( flow );

						var callLog = _library.$callLog().registerWorkflow;

						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ][ 1 ] ).toBe( _wf );
					} );

					it( "should attempt registering a workflow from raw yaml input", function(){
						var filePath = "/tests/resources/yaml/fullSpecExample.yaml";
						var flow = FileRead( filePath );

						_library.$( "registerWorkflow" );
						_yamlReader.$( "read" ).$args( flow ).$results( _wf );

						_cfflow.registerWorkflow( flow );

						var callLog = _library.$callLog().registerWorkflow;

						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ][ 1 ] ).toBe( _wf );
					} );
				} );
			} );
		} );
	}

// helpers
	private any function _getCondition( required string handler, struct args={} ) {
		return new cfflow.models.definition.spec.WorkflowCondition( argumentCollection=arguments );
	}
}
