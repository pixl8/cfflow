component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow Instance", function() {
			var _instance = "";
			var _workflowId = CreateUUId();
			var _instanceArgs = { test=CreateUUId(), cool="beans" };
			var _definition = CreateEmptyMock( "cfflow.models.definition.spec.Workflow" );
			var _implementation = CreateEmptyMock( "cfflow.models.implementation.WorkflowImplementation" );
			var _engine = CreateEmptyMock( "cfflow.models.WorkflowEngine" );

			beforeEach( function(){
				_instance = CreateMock( object=new cfflow.models.instances.WorkflowInstance(
					  workflowId             = _workflowId
					, instanceArgs           = _instanceArgs
					, workflowDefinition     = _definition
					, workflowImplementation = _implementation
					, workflowEngine         = _engine
				) );
			} );

			describe( "State proxies", function(){
				describe( "getState()", function(){
					it( "should proxy to the implementation's getState method, passing in the instances args", function(){
						var mockState = { test=CreateUUId() };

						_implementation.$( "getState" ).$args( instanceArgs=_instanceArgs ).$results( mockState );

						expect( _instance.getState() ).toBe( mockState );
					} );
				} );

				describe( "setState()", function(){
					it( "should proxy to the implementation's setState method, passing in the instances args + supplied state", function(){
						var mockState = { test=CreateUUId() };

						_implementation.$( "setState" );
						_instance.setState( mockState );

						var callLog = _implementation.$callLog().setState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[1].instanceArgs ).toBe( _instanceArgs );
						expect( callLog[1].state ).toBe( mockState );
					} );
				} );

				describe( "appendState()", function(){
					it( "should proxy to the implementation's appendState method, passing in the instances args + supplied state", function(){
						var mockState = { test=CreateUUId() };

						_implementation.$( "appendState" );
						_instance.appendState( mockState );

						var callLog = _implementation.$callLog().appendState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[1].instanceArgs ).toBe( _instanceArgs );
						expect( callLog[1].state ).toBe( mockState );
					} );
				} );
			} );

			describe( "Status proxies", function(){
				describe( "getStepStatus()", function(){
					it( "should proxy to the implementation's getStepStatus method, passing in the instances args", function(){
						var mockStatus = CreateUUId();
						var step = CreateUUId();

						_implementation.$( "getStepStatus" ).$args( instanceArgs=_instanceArgs, step=step ).$results( mockStatus );

						expect( _instance.getStepStatus( step ) ).toBe( mockStatus );
					} );
				} );

				describe( "getAllStepStatuses()", function(){
					it( "should proxy to the implementation's getAllStepStatuses method, passing in the instances args and return a new array with steps in order and statuses from the proxy or 'pending' for those missing", function(){
						var mockStatuses = { step1="complete", step2="skipped", step3="active" };
						var steps        = [ "step1", "step2", "step3", "step4", "step5" ];

						_instance.$( "getSteps", steps );
						_implementation.$( "getAllStepStatuses" ).$args( instanceArgs=_instanceArgs ).$results( mockStatuses );

						expect( _instance.getAllStepStatuses() ).toBe( [
							  { step="step1", status="complete" }
							, { step="step2", status="skipped"  }
							, { step="step3", status="active"   }
							, { step="step4", status="pending"  }
							, { step="step5", status="pending"  }
						] );
					} );
				} );

				describe( "getActiveSteps()", function(){
					it( "should return array of step names from getAllStepStatuses() who's value is active", function(){
						_instance.$( "getAllStepStatuses", [
							  { step="step1", status="complete" }
							, { step="step2", status="skipped"  }
							, { step="step3", status="active"   }
							, { step="step4", status="active"  }
							, { step="step5", status="pending"  }
						] );

						expect( _instance.getActiveSteps() ).toBe( [ "step3", "step4" ] );
					} );

					it( "should return an empty array when no steps are active", function(){
						_instance.$( "getAllStepStatuses", [
							  { step="step1", status="complete" }
							, { step="step2", status="skipped"  }
							, { step="step3", status="complete" }
							, { step="step4", status="complete" }
							, { step="step5", status="complete" }
						] );

						expect( _instance.getActiveSteps() ).toBe( [] );
					} );
				} );

				describe( "getActiveStep()", function(){
					it( "should return the first active step ID", function(){
						_instance.$( "getAllStepStatuses", [
							  { step="step1", status="complete" }
							, { step="step2", status="skipped"  }
							, { step="step3", status="active"   }
							, { step="step4", status="active"  }
							, { step="step5", status="pending"  }
						] );

						expect( _instance.getActiveStep() ).toBe( "step3" );
					} );

					it( "should return an empty string when there are no active steps", function(){
						_instance.$( "getAllStepStatuses", [
							  { step="step1", status="complete" }
							, { step="step2", status="skipped"  }
							, { step="step3", status="complete" }
							, { step="step4", status="complete" }
							, { step="step5", status="complete" }
						] );

						expect( _instance.getActiveStep() ).toBe( "" );
					} );
				} );

				describe( "isComplete()", function(){
					it( "should return true when there are no active steps ", function(){
						_instance.$( "getActiveSteps", [] );

						expect( _instance.isComplete() ).toBe( true );
					} );

					it( "should return true when there are no active steps with actions", function(){
						_instance.$( "getActiveSteps", [ "step1", "step2" ] );
						var mockStep = CreateStub();
						mockStep.$( "getActions", [] );

						_instance.$( "_getStep" ).$args( "step1" ).$results( mockStep );
						_instance.$( "_getStep" ).$args( "step2" ).$results( mockStep );

						expect( _instance.isComplete() ).toBe( true );
					} );

					it( "should return false when at least one active step has actions", function(){
						_instance.$( "getActiveSteps", [ "step1", "step2" ] );
						var mockStep = CreateStub();
						mockStep.$( "getActions", [ 1 ] );

						_instance.$( "_getStep" ).$args( "step1" ).$results( mockStep );
						_instance.$( "_getStep" ).$args( "step2" ).$results( mockStep );

						expect( _instance.isComplete() ).toBe( false );
					} );
				} );
			} );

			describe( "Step proxies", function(){
				describe( "getSteps()", function(){
					it( "should return an array of step IDs from the workflow definition", function(){
						var steps = [];
						for( var i=1; i<=5; i++ ) {
							steps.append( CreateStub() );
							steps[ i ].$( "getId", "step#i#" );
						}

						_definition.$( "getSteps", steps );

						expect( _instance.getSteps() ).toBe( [ "step1", "step2", "step3", "step4", "step5" ] );
					} );
				} );
			} );
		});
	}
}