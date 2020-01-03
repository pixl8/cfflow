component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Abstract Coldbox workflow implementation", function() {
			var _impl = "";
			var _coldbox = "";

			beforeEach( function(){
				_coldbox = CreateStub();
				_impl = CreateMock( object=new cfflow.models.implementation.AbstractColdboxWorkflowImpl( coldbox=_coldbox ) );

				_coldbox.$( "handlerExists", true );
			} );

			describe( "evaluateCondition( wfCondition, wfInstance )", function() {
				it( "should return boolean result from running the condition handler, passing in workflow instance and any args as arguments", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfCondition = new cfflow.models.definition.spec.WorkflowCondition( handler=handler, args=args );

					_coldbox.$( "runEvent" ).$args(
						  event   = handler
						, private = true
						, prePostExempt = true
						, eventArguments = { conditionArgs=args, wfInstance=wfInstance }
					).$results( true );

					expect( _impl.evaluateCondition( wfCondition, wfInstance ) ).toBeTrue();

					_coldbox.$( "runEvent" ).$args(
						  event   = handler
						, private = true
						, prePostExempt = true
						, eventArguments = { conditionArgs=args, wfInstance=wfInstance }
					).$results( false );

					expect( _impl.evaluateCondition( wfCondition, wfInstance ) ).toBeFalse();
				} );

				it( "should return false when a handler returns null", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfCondition = new cfflow.models.definition.spec.WorkflowCondition( handler=handler, args=args );

					_coldbox.$( "runEvent" ).$args(
						  event   = handler
						, private = true
						, prePostExempt = true
						, eventArguments = { conditionArgs=args, wfInstance=wfInstance }
					).$results( NullValue() );

					expect( _impl.evaluateCondition( wfCondition, wfInstance ) ).toBeFalse();
				} );

				it( "should return false when a handler returns a non-boolean value", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfCondition = new cfflow.models.definition.spec.WorkflowCondition( handler=handler, args=args );

					_coldbox.$( "runEvent" ).$args(
						  event   = handler
						, private = true
						, prePostExempt = true
						, eventArguments = { conditionArgs=args, wfInstance=wfInstance }
					).$results( CreateUUId() );

					expect( _impl.evaluateCondition( wfCondition, wfInstance ) ).toBeFalse();
				} );

				it( "should throw an informative error when the condition handler does not exist", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfCondition = new cfflow.models.definition.spec.WorkflowCondition( handler=handler, args=args );


					_coldbox.$( "handlerExists" ).$args( handler ).$results( false );

					expect( function(){
						_impl.evaluateCondition( wfCondition, wfInstance )
					} ).toThrow( "cfflow.condition.handler.does.not.exist" );
				} );
			} );

			describe( "executeFunction( wfFunction, wfInstance )", function() {
				it( "should run the function handler, passing in workflow instance and any args as arguments", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfFunction = new cfflow.models.definition.spec.WorkflowFunction( handler=handler, args=args );

					_coldbox.$( "runEvent" );
					_impl.executeFunction( wfFunction, wfInstance )

					var callLog = _coldbox.$callLog().runEvent;
					expect( callLog.len() ).toBe( 1 );
					expect( callLog[1].event ).toBe( handler );
					expect( callLog[1].private ).toBeTrue();
					expect( callLog[1].prePostExempt ).toBeTrue();
					expect( callLog[1].eventArguments.functionArgs ).toBe( args );
					expect( callLog[1].eventArguments.wfInstance ).toBe( wfInstance );
				} );


				it( "should throw an informative error when the condition handler does not exist", function(){
					var handler     = CreateUUId();
					var args        = { test=CreateUUId(), this=true };
					var wfInstance  = CreateEmptyMock( "tests.resources.WorkflowInstance" );
					var wfFunction = new cfflow.models.definition.spec.WorkflowFunction( handler=handler, args=args );


					_coldbox.$( "handlerExists" ).$args( handler ).$results( false );

					expect( function(){
						_impl.executeFunction( wfFunction, wfInstance )
					} ).toThrow( "cfflow.function.handler.does.not.exist" );
				} );
			} );
		} );
	}
}