component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Function library", function() {
			beforeEach( body=function(){
				variables._wfId = CreateUUId();
				variables._instanceArgs = {};
				variables._state = { test=CreateUUId(), is="truly", testy=false };
				variables._instance = CreateMock( object=new cfflow.models.instances.WorkflowInstance( workflowId=_wfId, instanceArgs=_instanceArgs ) );

				variables._instance.$( "getState", _state );
				variables._instance.$( "appendState" );
				variables._instance.$( "setState" );
			} );

			describe( "State", function(){
				describe( "state.append", function(){
					it( "should call instance.append() passing in any args passed to the function", function(){
						var fn = new cfflow.models.implementation.functions.state.Append();
						var args = { test=CreateUUId(), this=true };

						fn.do( _instance, args );

						var callLog = _instance.$callLog().appendState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ] ).toBe( [ args ] );
					} );

					it( "should do nothing if the passed in args struct is empty", function(){
						var fn = new cfflow.models.implementation.functions.state.Append();
						var args = {};

						fn.do( _instance, args );

						var callLog = _instance.$callLog().appendState;
						expect( callLog.len() ).toBe( 0 );
					} );
				} );
				describe( "state.set", function(){
					it( "should simply proxy to instance.setState( args )", function(){
						var fn = new cfflow.models.implementation.functions.state.Set();
						var args = { test=CreateUUId(), this=true };

						fn.do( _instance, args );

						var callLog = _instance.$callLog().setState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ] ).toBe( [ args ] );
					} );
				} );
				describe( "state.delete", function(){
					it( "should do remove any matching keys from the passed args.keys array from state", function(){
						var fn = new cfflow.models.implementation.functions.state.Delete();
						var args = { keys=[ "test", "is", "something" ] };

						fn.do( _instance, args );

						var callLog = _instance.$callLog().setState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ] ).toBe( [ { testy=false } ] );

					} );

					it( "should do nothing when no keys match anything in state", function(){
						var fn = new cfflow.models.implementation.functions.state.Delete();
						var args = { keys=[ "a", "b", "c", "d" ] };

						fn.do( _instance, args );

						var callLog = _instance.$callLog().setState;
						expect( callLog.len() ).toBe( 0 );
					} );

					it( "should remove single key when keys is passed as a simple value, not an array", function(){
						var fn = new cfflow.models.implementation.functions.state.Delete();
						var args = { keys="test" };

						fn.do( _instance, args );

						var callLog = _instance.$callLog().setState;
						expect( callLog.len() ).toBe( 1 );
						expect( callLog[ 1 ] ).toBe( [ { is="truly", testy=false } ] );
					} );
				} );
			} );
		} );
	}

}