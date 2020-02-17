component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow arg replacer", function() {
			beforeEach( function(){
				_subst = CreateMock( object=new cfflow.models.substitution.WorkflowArgSubstitutor() )
			} );

			describe( "substitue( args, wfInstance )", function(){
				it( "should use the default registered state provider to substitute args based on instance state", function(){
					var wfInstance = CreateEmptyMock( "cfflow.models.instances.WorkflowInstance" );
					var args = {
						  test   = "this is a $_test.token"
						, simple = "$token"
						, multi  = "$token another $fubar.here"
						, nested = {
							test = "$token"
						}
					};
					var state = {
						  token = "this"
						, _test = { token="yes" }
						, fubar  = { here="no" }
					};

					wfInstance.$( "getState", state );

					expect( _subst.substitute( args, wfinstance ) ).toBe( {
						  test   = "this is a yes"
						, simple = "this"
						, multi  = "this another no"
						, nested = { test="this" }
					} );
				} );
			} );

			describe( "discoverTokens( args )", function(){
				it( "should extract available tokens to be substitued from the args", function(){
					var args = {
						  test   = "this is a $_test.token"
						, simple = "$token"
						, multi  = "$token another $token.here"
					};
					var expected = [ "$_test.token", "$token", "$token.here" ];
					var actual = _subst.discoverTokens( args );

					ArraySort( actual, "text" );


					expect( actual ).toBe( expected );
				} );
			} );
		} );
	}

}
