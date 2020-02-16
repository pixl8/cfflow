component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow state substitution provider", function() {
			beforeEach( function(){
				_subs = new cfflow.models.substitution.WorkflowStateSubstitutionProvider();
			} );

			describe( "getTokens( tokens, wfInstance )", function() {
				it( "should return a struct of simple values whose keys are the original state keys prepended with $ and whose token name is present in the passed array of tokens", function(){
					var wfInstance = CreateEmptyMock( "cfflow.models.instances.WorkflowInstance" );
					var state = {
						  test = "this"
						, yes = CreateUUId()
						, no  = { thank="you", yes={ please=true } }
						, _not = "passed.in"
					};

					wfInstance.$( "getState", state );

					expect( _subs.getTokens( [ "$test", "$yes", "$no.thank", "$no.yes.please" ], wfInstance ) ).toBe( {
						  "$test"          = "this"
						, "$yes"           = state.yes
						, "$no.thank"      = "you"
						, "$no.yes.please" = true
					} );
				} );
			} );
		} );
	}

}
