component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow Engine", function() {
			var _implFactory = "";
			var _library = "";
			var _engine  = "";
			var _impl = "";
			var _instance  = "";
			var _instanceArgs = { test=true };
			var _steps  = "";
			var _wfId  = "";
			var _wf  = "";

			beforeEach( function(){
				_library     = CreateEmptyMock( "cfflow.models.definition.WorkflowLibrary" );
				_implFactory = CreateEmptyMock( "cfflow.models.implementation.WorkflowImplementationFactory" );
				_impl        = CreateMock( "cfflow.models.implementation.WorkflowImplementation" );
				_engine      = CreateMock( object=new cfflow.models.engine.WorkflowEngine( implementationFactory=_implFactory, workflowLibrary=_library ) );
				_wfId        = CreateUUId();
				_instance    = CreateMock( "cfflow.models.instances.WorkflowInstance" );
				_wf          = CreateMock( "cfflow.models.definition.spec.Workflow" );
				_steps       = [];

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

			describe( "doAction( wfInstance, wfAction )", function() {
				it( "should fetch the result of the action to execute and then run doResult() using the fetched result and passed instance", function(){
					var result   = CreateMock( "cfflow.models.definition.spec.WorkflowResult" );
					var action   = CreateMock( "cfflow.models.definition.spec.WorkflowAction" );
					var actionId = CreateUUId();
					var resultId = CreateUUId();

					result.setId( resultId );
					action.setId( actionId );

					_engine.$( "getResultToExecute" ).$args( _instance, action ).$results( result );
					_engine.$( "doResult" );

					_engine.doAction( _instance, action );

					var callLog = _engine.$callLog().doResult;
					expect( callLog.len()  ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance.getWorkflowId() ).toBe( _instance.getWorkflowId() );
					expect( callLog[ 1 ].wfResult.getId() ).toBe( result.getId() );
				} );
			} );

			describe( "getImplementation( workflow )", function(){
				it( "should use the implementation factory to get the implementation for the given workflows class", function(){
					var wf = CreateMock( "cfflow.models.definition.spec.Workflow" );
					var wfClass = CreateUUId();
					var result = CreateMock( "tests.resources.TestWfImplementation" );

					wf.setClass( wfClass );

					_implFactory.$( "getWorkflowImplementation" ).$args( wfClass ).$results( result );

					expect( _engine.getImplementation( wf ) ).toBe( result );
					expect( _engine.getImplementation( wf ).isTestWfImplementation() ).toBeTrue();
				} );
			} );

			describe( "getResultToExecute( wfInstance, wfAction )", function() {
				it( "should return the default result when no conditional results are defined", function(){
					var action   = CreateMock( "cfflow.models.definition.spec.WorkflowAction" );
					var actionId = CreateUUId();
					var resultId = CreateUUId();

					action.setDefaultResult( id=resultId, title="test" );

					var resultToExecute = _engine.getResultToExecute( _instance, action );

					expect( resultToExecute.getId() ).toBe( resultId );
					expect( resultToExecute.getIsDefault() ).toBe( true );
				} );
				it( "should return the first conditional result whose condition evaluates true", function(){
					var action   = CreateMock( "cfflow.models.definition.spec.WorkflowAction" );
					var actionId = CreateUUId();
					var defaultResultId = CreateUUId();
					var conditionalResultIds = [
						  CreateUUId()
						, CreateUUId()
						, CreateUUId()
					];
					var conditions = [
						  _getCondition( "test.condition.1", { test=true } )
						, _getCondition( "test.condition.2", { test=true } )
						, _getCondition( "test.condition.3", { test=true } )
					];

					action.setDefaultResult( id=defaultResultId, title="test" );
					for( var i=1; i<=conditionalResultIds.len(); i++ ) {
						action.addConditionalResult(
							  id        = conditionalResultIds[ i ]
							, condition = conditions[ i ]
						);
					}

					_engine.$( "evaluateCondition" ).$args( conditions[ 1 ], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[ 2 ], _instance ).$results( true );
					_engine.$( "evaluateCondition" ).$args( conditions[ 3 ], _instance ).$results( true );

					var resultToExecute = _engine.getResultToExecute( _instance, action );

					expect( resultToExecute.getId() ).toBe( conditionalResultIds[2] );
					expect( resultToExecute.getIsDefault() ).toBe( false );
				} );
				it( "should return the default result when no conditional results evaluate true", function(){
					var action   = CreateMock( "cfflow.models.definition.spec.WorkflowAction" );
					var actionId = CreateUUId();
					var defaultResultId = CreateUUId();
					var conditionalResultIds = [
						  CreateUUId()
						, CreateUUId()
						, CreateUUId()
					];
					var conditions = [
						  _getCondition( "test.condition.1", { test=true } )
						, _getCondition( "test.condition.2", { test=true } )
						, _getCondition( "test.condition.3", { test=true } )
					];

					action.setDefaultResult( id=defaultResultId, title="test" );
					for( var i=1; i<=conditionalResultIds.len(); i++ ) {
						action.addConditionalResult(
							  id        = conditionalResultIds[ i ]
							, condition = conditions[ i ]
						);
					}

					_engine.$( "evaluateCondition" ).$args( conditions[ 1 ], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[ 2 ], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[ 3 ], _instance ).$results( false );

					var resultToExecute = _engine.getResultToExecute( _instance, action );

					expect( resultToExecute.getId() ).toBe( defaultResultId );
					expect( resultToExecute.getIsDefault() ).toBe( true );
				} );
			} );

			describe( "doTransition( wfInstance, transition )", function() {
				it( "should set the state of the step in the transition to the status in the transition on the worklow instance", function(){
					var step = "some-step-#CreateUUId()#";
					var status = "complete";
					var transition = CreateMock( "cfflow.models.definition.spec.WorkflowTransition" );

					transition.setStep( step );
					transition.setStatus( status );

					_engine.$( "scheduleAutoActions" );
					_engine.$( "unscheduleAutoActions" );
					_engine.doTransition( _instance, transition );

					var callLog = _impl.$callLog().setStepStatus;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].workflowId ).toBe( _wfId );
					expect( callLog[ 1 ].step ).toBe( step );
					expect( callLog[ 1 ].status ).toBe( status );
				} );

				it( "should trigger auto action scheduling and execution for the step if set to active", function(){
					var step = "some-step-#CreateUUId()#";
					var status = "active";
					var transition = CreateMock( "cfflow.models.definition.spec.WorkflowTransition" );

					transition.setStep( step );
					transition.setStatus( "active" );

					_engine.$( "scheduleAutoActions" );

					_engine.doTransition( _instance, transition );

					var callLog = _engine.$callLog().scheduleAutoActions;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ] ).toBe( { stepId=step, wfInstance=_instance } );
				} );

				it( "should unschedule any auto scheduled actions for the step if set to something other than active", function(){
					var step = "some-step-#CreateUUId()#";
					var transition = CreateMock( "cfflow.models.definition.spec.WorkflowTransition" );

					transition.setStep( step );
					transition.setStatus( "complete" );

					_engine.$( "unscheduleAutoActions" );

					_engine.doTransition( _instance, transition );

					var callLog = _engine.$callLog().unscheduleAutoActions;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ] ).toBe( { stepId=step, wfInstance=_instance } );
				} );
			} );

			describe( "getStepForInstance( stepid )", function(){
				it( "should loop return the corresponding step object for the given stepId and workflow instance", function(){
					expect( _engine.getStepForInstance( wfInstance=_instance, stepId="step-2" ).getId() ).toBe( "step-2" );
				} );
			} );

			describe( "scheduleAutoActions( wfInstance, stepId )", function(){
				it( "should immediately execute any auto actions for the step when the step has no auto action timers", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";

					step.$( "hasAutoActionTimers", false );
					step.$( "hasAutoActions", true );
					_impl.$( "scheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );
					_engine.$( "doAutoActions", true );

					_engine.scheduleAutoActions( wfInstance=_instance, stepId=stepId );

					var callLog = _engine.$callLog().doAutoActions;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfStep ).toBe( step );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );

					expect( _impl.$callLog().scheduleAutoActions.len() ).toBe( 0 );
				} );
				it( "should setup scheduling with the workflow implementation when there is timer configuration and one or more automatic actions", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";
					var timers = [ CreateUUId(), CreateUUId(), CreateUUId() ];

					step.$( "hasAutoActionTimers", true );
					step.$( "hasAutoActions", true );
					step.$( "getAutoActionTimers", timers );
					_impl.$( "scheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );
					_engine.$( "doAutoActions" );

					_engine.scheduleAutoActions( wfInstance=_instance, stepId=stepId );

					var callLog = _impl.$callLog().scheduleAutoActions;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].stepId ).toBe( stepId );
					expect( callLog[ 1 ].timers ).toBe( timers );
					expect( callLog[ 1 ].instanceArgs ).toBe( _instanceArgs );
					expect( callLog[ 1 ].workflowId ).toBe( _wfId );

					expect( _engine.$callLog().doAutoActions.len() ).toBe( 0 );

				} );
				it( "should do nothing when there are not automatically executable actions", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";

					step.$( "hasAutoActionTimers", false );
					step.$( "hasAutoActions", false );
					_impl.$( "scheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );
					_engine.$( "doAutoActions" );

					_engine.scheduleAutoActions( wfInstance=_instance, stepId=stepId );

					expect( _engine.$callLog().doAutoActions.len() ).toBe( 0 );
					expect( _impl.$callLog().scheduleAutoActions.len() ).toBe( 0 );
				} );
			} );

			describe( "unScheduleAutoActions( wfInstance, stepId )", function(){
				it( "should attempt to unschedule auto actions with the workflow implementation when there is timer configuration and one or more automatic actions", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";

					step.$( "hasAutoActionTimers", true );
					step.$( "hasAutoActions", true );
					_impl.$( "unscheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );

					_engine.unScheduleAutoActions( wfInstance=_instance, stepId=stepId );

					var callLog = _impl.$callLog().unscheduleAutoActions;

					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].stepId ).toBe( stepId );
					expect( callLog[ 1 ].instanceArgs ).toBe( _instanceArgs );
					expect( callLog[ 1 ].workflowId ).toBe( _wfId );

				} );

				it( "should do nothing when step has no auto actions", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";

					step.$( "hasAutoActionTimers", true );
					step.$( "hasAutoActions", false );
					_impl.$( "unscheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );

					_engine.unScheduleAutoActions( wfInstance=_instance, stepId=stepId );

					expect( _impl.$callLog().unscheduleAutoActions.len() ).toBe( 0 );
				} );

				it( "should do nothing when step has no auto action timers", function(){
					var step = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );
					var stepId = "some-step-#CreateUUId()#";

					step.$( "hasAutoActions", true );
					step.$( "hasAutoActionTimers", false );
					_impl.$( "unscheduleAutoActions" );
					_instance.setWorkflowImplementation( _impl );
					_engine.$( "getStepForInstance" ).$args( wfInstance=_instance, stepId=stepId ).$results( step );

					_engine.unScheduleAutoActions( wfInstance=_instance, stepId=stepId );

					expect( _impl.$callLog().unscheduleAutoActions.len() ).toBe( 0 );
				} );
			} );


			describe( "evaluateCondition( wfCondition, wfInstance )", function(){
				it( "should use the workflow implementation's evaluator to evaluate the given condition, passing through the workflow instance and workflow definition objects", function(){
					var condition = _getCondition("some.condition", { test=true } );

					_instance.setWorkflowImplementation( _impl );

					_impl.$( "evaluateCondition" ).$results( true, false );
					expect( _engine.evaluateCondition( condition, _instance ) ).toBeTrue();
					expect( _engine.evaluateCondition( condition, _instance ) ).toBeFalse();
				} );
			} );

			describe( "filterFunctionsToExecute( wfInstance, functions )", function(){
				it( "should return an array of functions who either have no condition, or whose conditions evaluate to true", function(){
					var conditions = [
					      _getCondition( "handler.3" )
						, _getCondition( "handler.4" )
						, _getCondition( "handler.5" )
					];
					var functions = [
						  new cfflow.models.definition.spec.WorkflowFunction( id="fn1"  )
						, new cfflow.models.definition.spec.WorkflowFunction( id="fn2"  )
						, new cfflow.models.definition.spec.WorkflowFunction( id="fn3", condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowFunction( id="fn4", condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowFunction( id="fn5", condition=conditions[ 3 ] )
					];

					_engine.$( "evaluateCondition" ).$args( conditions[1], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[2], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[3], _instance ).$results( true );

					var filtered = _engine.filterFunctionsToExecute( _instance, functions );

					expect( filtered.len() ).toBe( 3 );
					expect( filtered[ 1 ].getId() ).toBe( "fn1" );
					expect( filtered[ 2 ].getId() ).toBe( "fn2" );
					expect( filtered[ 3 ].getId() ).toBe( "fn5" );
				} );
			} );

			describe( "doFunction( wfInstance, wfFunction )", function(){
				it( "should use the function registered in the workflow library to execute with the definition arguments", function(){
					var fn   = CreateMock( "cfflow.models.definition.spec.WorkflowFunction" );
					var testFunction = CreateMock( "tests.resources.TestFunction" );
					var fnId = CreateUUId();
					var args = { test=CreateUUId() };

					fn.setId( fnId );
					fn.setArgs( args );

					testFunction.$( "do" );
					_implFactory.$( "getFunction" ).$args( id=fnId ).$results( testFunction );

					_engine.doFunction( _instance, fn );

					var callLog = testFunction.$callLog().do;

					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].args ).toBe( args );
				} );
			} );

			describe( "doResult( wfInstance, wfResult )", function() {
				it( "should call result preFunctions, execute transitions and call postFunctions", function(){
					var result                = CreateMock( "cfflow.models.definition.spec.WorkflowResult" );
					var preFunctions          = [ CreateUUId(), CreateUUId() ];
					var postFunctions         = [ CreateUUId(), CreateUUId() ];
					var transitions           = [
						  new cfflow.models.definition.spec.WorkflowTransition( step="step1", status="complete" )
						, new cfflow.models.definition.spec.WorkflowTransition( step="step2", status="skipped"  )
						, new cfflow.models.definition.spec.WorkflowTransition( step="step3", status="active"   )
					];
					var filteredPreFunctions  = [
						  new cfflow.models.definition.spec.WorkflowFunction( id="pre-fn-1" )
						, new cfflow.models.definition.spec.WorkflowFunction( id="pre-fn-2" )
					];
					var filteredPostFunctions = [
						  new cfflow.models.definition.spec.WorkflowFunction( id="post-fn-1" )
						, new cfflow.models.definition.spec.WorkflowFunction( id="post-fn-2" )
					];


					result.$( "getTransitions", transitions );
					result.$( "getPreFunctions", preFunctions );
					result.$( "getPostFunctions", postFunctions );
					_engine.$( "filterFunctionsToExecute" ).$args( _instance, preFunctions ).$results( filteredPreFunctions );
					_engine.$( "filterFunctionsToExecute" ).$args( _instance, postFunctions ).$results( filteredPostFunctions );
					_engine.$( "doFunction" );
					_engine.$( "doTransition" );

					_engine.doResult( _instance, result );

					var transitionsLog = _engine.$callLog().doTransition;
					expect( transitionsLog.len() ).toBe( 3 );
					expect( transitionsLog[1].wfInstance ).toBe( _instance );
					expect( transitionsLog[1].wfTransition ).toBe( transitions[ 1 ] );
					expect( transitionsLog[2].wfInstance ).toBe( _instance );
					expect( transitionsLog[2].wfTransition ).toBe( transitions[ 2 ] );
					expect( transitionsLog[3].wfInstance ).toBe( _instance );
					expect( transitionsLog[3].wfTransition ).toBe( transitions[ 3 ] );

					var functionsLog = _engine.$callLog().doFunction;
					expect( functionsLog.len() ).toBe( 4 );
					expect( functionsLog[1].wfInstance ).toBe( _instance );
					expect( functionsLog[1].wfFunction ).toBe( filteredPreFunctions[ 1 ] );
					expect( functionsLog[2].wfInstance ).toBe( _instance );
					expect( functionsLog[2].wfFunction ).toBe( filteredPreFunctions[ 2 ] );
					expect( functionsLog[3].wfInstance ).toBe( _instance );
					expect( functionsLog[3].wfFunction ).toBe( filteredPostFunctions[ 1 ] );
					expect( functionsLog[4].wfInstance ).toBe( _instance );
					expect( functionsLog[4].wfFunction ).toBe( filteredPostFunctions[ 2 ] );
				} );
			} );

			describe( "doAutoActions( wfInstance, wfStep )", function(){
				it( "should execute the first auto action it finds whose condition is true and return true to indicate that an action was found and executed", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
						, _getCondition( "handler.4" )
						, _getCondition( "handler.5" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=false, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=false, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true , condition=conditions[ 3 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act4", isAutomatic=true , condition=conditions[ 4 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act5", isAutomatic=true , condition=conditions[ 5 ] )
					];
					var wfStep = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );

					wfStep.$( "getActions", actions );

					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[1] ).$results( true );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[2] ).$results( true );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[3] ).$results( false );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[4] ).$results( true );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[5] ).$results( true );

					_engine.$( "doAction" );

					expect( _engine.doAutoActions( wfInstance=_instance, wfStep=wfStep ) ).toBe( true );
					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 4 ] );
				} );
				it( "should execute the first auto action it finds that has no condition (when previous actions with conditions have failed)", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
						, _getCondition( "handler.4" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=false, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=false, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true , condition=conditions[ 3 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act4", isAutomatic=true , condition=conditions[ 4 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act5", isAutomatic=true )
					];
					var wfStep = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );

					wfStep.$( "getActions", actions );

					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[1] ).$results( true );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[2] ).$results( true );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[3] ).$results( false );
					_engine.$( "evaluateCondition" ).$args( wfInstance=_instance, wfCondition=conditions[4] ).$results( false );

					_engine.$( "doAction" );

					expect( _engine.doAutoActions( wfInstance=_instance, wfStep=wfStep ) ).toBe( true );
					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 5 ] );
				} );
				it( "should return false and execute no actions when no actions are runnable due to conditions not being met", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
						, _getCondition( "handler.4" )
						, _getCondition( "handler.5" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=false, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=false, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true , condition=conditions[ 3 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act4", isAutomatic=true , condition=conditions[ 4 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act5", isAutomatic=true , condition=conditions[ 5 ] )
					];
					var wfStep = CreateMock( "cfflow.models.definition.spec.WorkflowStep" );

					wfStep.getActions( actions );


					_engine.$( "evaluateCondition" ).$args( conditions[1], _instance ).$results( true );
					_engine.$( "evaluateCondition" ).$args( conditions[2], _instance ).$results( true );
					_engine.$( "evaluateCondition" ).$args( conditions[3], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[4], _instance ).$results( false );
					_engine.$( "evaluateCondition" ).$args( conditions[5], _instance ).$results( false );

					_engine.$( "doAction" );

					expect( _engine.doAutoActions( wfInstance=_instance, wfStep=wfStep ) ).toBe( false );
					expect( _engine.$callLog().doAction.len() ).toBe( 0 );
				} );

			} );

			describe( "initializeInstance( wfInstance, initialState, initialActionId )", function(){
				it( "should set the initial state on the instance and run the initial action", function(){
					var state = { blah=CreateUUId() };

					_instance.$( "setState" );
					_engine.$( "doInitialAction" );

					_engine.initializeInstance(
						  wfInstance   = _instance
						, initialState = state
					);

					var callLog = _instance.$callLog().setState;

					expect( callLog.len() ).toBe( 1 );
					expect( callLog[1][1] ).toBe( state );

					var callLog = _engine.$callLog().doInitialAction;

					expect( callLog.len() ).toBe( 1 );
					expect( callLog[1].wfInstance ).toBe( _instance );
					expect( callLog[1].initialActionId ).toBeNull();
				} );

				it( "should pass the set initialActionId through to doInitialAction", function(){
					var initialActionId = CreateUUId();

					_instance.$( "setState" );
					_engine.$( "doInitialAction" );

					_engine.initializeInstance(
						  wfInstance      = _instance
						, initialActionId = initialActionId
					);

					var callLog = _instance.$callLog().setState;

					expect( callLog.len() ).toBe( 0 );

					var callLog = _engine.$callLog().doInitialAction;

					expect( callLog.len() ).toBe( 1 );
					expect( callLog[1].wfInstance ).toBe( _instance );
					expect( callLog[1].initialActionId ).toBe( initialActionId );
				} );
			} );

			describe( "doInitialAction( wfInstance, initialActionId )", function(){
				it( "should do the first action that passes condition checks when no initialActionId is passed", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true , condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true , condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true , condition=conditions[ 3 ] )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( method="evaluateCondition", callback=function(){
						return arguments.wfCondition.getHandler() != "handler.1";
					} );

					_engine.$( "doAction" );

					_engine.doInitialAction( wfInstance=_instance );

					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 2 ] );
				} );

				it( "should do the first action that has no condition when no initialActionId is passed and any previous actions failed condition checks", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true , condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true , condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( "evaluateCondition", false );

					_engine.$( "doAction" );

					_engine.doInitialAction( wfInstance=_instance );

					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 3 ] );
				} );
				it( "should run the passed actionId if it has no condition", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true , condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true , condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( "evaluateCondition", true );

					_engine.$( "doAction" );

					_engine.doInitialAction( wfInstance=_instance, initialActionId="act3" );

					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 3 ] );
				} );
				it( "should run the passed actionId if it passes its condition check", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true, condition=conditions[ 3 ] )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( method="evaluateCondition", callBack=function(){
						return arguments.wfCondition.getHandler() == "handler.3";
					} );

					_engine.$( "doAction" );

					_engine.doInitialAction( wfInstance=_instance, initialActionId="act3" );

					var callLog = _engine.$callLog().doAction;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[ 1 ].wfInstance ).toBe( _instance );
					expect( callLog[ 1 ].wfAction ).toBe( actions[ 3 ] );
				} );
				it( "should raise an error when there are no initial actions possible", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true, condition=conditions[ 3 ] )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( "evaluateCondition", false );
					_engine.$( "doAction" );

					expect( function(){
						_engine.doInitialAction( wfInstance=_instance );

					} ).toThrow( "cfflow.no.initial.actions.runnable" );
				} );
				it( "should raise an error when the passed action ID fails its condition", function(){
					var conditions = [
					      _getCondition( "handler.1" )
					    , _getCondition( "handler.2" )
					    , _getCondition( "handler.3" )
					];
					var actions = [
						  new cfflow.models.definition.spec.WorkflowAction( id="act1", isAutomatic=true, condition=conditions[ 1 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act2", isAutomatic=true, condition=conditions[ 2 ] )
						, new cfflow.models.definition.spec.WorkflowAction( id="act3", isAutomatic=true, condition=conditions[ 3 ] )
					];

					_wf.$( "getInitialActions", actions );

					_engine.$( method="evaluateCondition", callBack=function(){
						return arguments.wfCondition.getHandler() != "handler.1";
					} );
					_engine.$( "doAction" );

					expect( function(){
						_engine.doInitialAction( wfInstance=_instance, initialActionId="act1" );
					} ).toThrow( "cfflow.no.initial.actions.runnable" );
				} );
			} );
		} );
	}

// helpers
	private any function _getCondition( required string handler, struct args={} ) {
		return new cfflow.models.definition.spec.WorkflowCondition( argumentCollection=arguments );
	}
}
