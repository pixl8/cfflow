component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Struct Workflow reader", function() {
			var reader  = "";
			var factory = "";

			beforeEach( function(){
				factory = CreateMock( object=new cfflow.models.definition.WorkflowFactory() );
				reader = CreateMock( object=new cfflow.models.definition.readers.WorkflowReader(
					  workflowFactory = factory
					, schemaValidator = new cfflow.models.definition.validation.WorkflowSchemaValidator()
					, schemaUtil      = new cfflow.models.util.WorkflowSchemaUtil()
				) );
			} );

			describe( "read( struct )", function() {
				var wf = "";

				beforeEach( function(){
					wf = reader.read( _getWorkflowStructFromYaml() );
				} );

				it( "should raise an error when the incoming workflow definition is invalid", function(){
					expect( function(){
						reader.read( { some="invalid", workflow=true } );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );

				it( "should read top level workflow information from the struct definition", function(){
					expect( wf.getId() ).toBe( "test-workflow" );
					expect( wf.getMeta() ).toBe( { title="Test workflow" } );
					expect( wf.getClass() ).toBe( "pixl8.webflow" );
				} );

				it( "should read all initial actions in the flow", function(){
					var actions = wf.getInitialActions();

					expect( actions.len() ).toBe( 1 );
					expect( actions[1].getId() ).toBe( "action-1" );
					expect( actions[1].getMeta() ).toBe( { title="Action 1"} );
					expect( actions[1].getIsAutomatic() ).toBe( true );
				} );

				it( "should read all steps in the flow", function(){
					var steps = wf.getSteps();

					expect( steps.len() ).toBe( 2 );
					expect( steps[1].getId() ).toBe( "step-1" );
					expect( steps[1].getMeta() ).toBe( { title="Step 1", description="Step 1 description" } );
					expect( steps[1].getAutoActionTimers()[1].getInterval() ).toBe( 600 );
					expect( steps[1].getAutoActionTimers()[1].getCount() ).toBe( 100 );
					expect( steps[2].getId() ).toBe( "step-2" );
					expect( steps[2].getAutoActionTimers() ).toBe( [] );
					expect( steps[2].getMeta() ).toBe( { title="Step 2", description="Step 2 description" } );
				} );

				it( "should read all step actions in the flow", function(){
					var steps = wf.getSteps();
					var step1Actions = steps[1].getActions();
					var step2Actions = steps[2].getActions();

					expect( step1Actions.len() ).toBe( 2 );
					expect( step2Actions.len() ).toBe( 0 );

					expect( step1Actions[1].getId() ).toBe( "action-1" );
					expect( step1Actions[1].getMeta() ).toBe( {title="Action 1"} );
					expect( step1Actions[1].getCondition().getHandler() ).toBe( "action1.condition.handler" );
					expect( step1Actions[1].getIsAutomatic() ).toBe( true );
					expect( step1Actions[2].getId() ).toBe( "action-2" );
					expect( step1Actions[2].getMeta() ).toBe( {title="Action 2"} );
					expect( step1Actions[2].getScreen() ).toBe( "" );
					expect( step1Actions[2].getCondition().getHandler() ).toBe( "action2.condition" );
					expect( step1Actions[2].getIsAutomatic() ).toBe( false );
				} );

				it( "should read the action default results", function(){
					var result = wf.getSteps()[1].getActions()[1].getDefaultResult();

					expect( result.getId() ).toBe( "result-1" );
					expect( result.getMeta() ).toBe( {title="Result 1"} );
					expect( result.getType() ).toBe( "step" );
					expect( result.getIsDefault() ).toBe( true );
					expect( result.getCondition() ).toBeNull();
				} );

				it( "should read the all action conditional results", function(){
					var results = wf.getSteps()[1].getActions()[1].getConditionalResults()

					expect( results.len() ).toBe( 2 );

					expect( results[1].getId() ).toBe( "result-2" );
					expect( results[1].getMeta() ).toBe( {title="Result 2"} );
					expect( results[1].getType() ).toBe( "split" );
					expect( results[1].getIsDefault() ).toBe( false );
					expect( results[1].getCondition().getHandler() ).toBe( "result2.condition.handler" );

					expect( results[2].getId() ).toBe( "result-3" );
					expect( results[2].getMeta() ).toBe( {title="Result 3"} );
					expect( results[2].getType() ).toBe( "step" );
					expect( results[2].getIsDefault() ).toBe( false );
					expect( results[2].getCondition().getHandler() ).toBe( "result3ConditionId" );
				} );

				it( "should read all transitions from default results", function(){
					var transitions = wf.getSteps()[1].getActions()[1].getDefaultResult().getTransitions();

					expect( transitions.len() ).toBe( 2 );

					expect( transitions[1].getStep() ).toBe( "step-1" );
					expect( transitions[1].getStatus() ).toBe( "complete" );
					expect( transitions[2].getStep() ).toBe( "step-2" );
					expect( transitions[2].getStatus() ).toBe( "active" );

				} );

				it( "should read all transitions from conditional results", function(){
					var transitions = wf.getSteps()[1].getActions()[1].getConditionalResults()[1].getTransitions();

					expect( transitions.len() ).toBe( 2 );

					expect( transitions[1].getStep() ).toBe( "step-1" );
					expect( transitions[1].getStatus() ).toBe( "complete" );
					expect( transitions[2].getStep() ).toBe( "step-2" );
					expect( transitions[2].getStatus() ).toBe( "skipped" );

				} );

				it( "should read all pre functions from default results", function(){
					var preFunctions = wf.getSteps()[1].getActions()[1].getDefaultResult().getPreFunctions();

					expect( preFunctions.len() ).toBe( 2 );

					expect( preFunctions[1].getId() ).toBe( "function-1" );
					expect( preFunctions[1].getMeta() ).toBe( { title="Function 1"} );
					expect( preFunctions[1].getPreOrPost() ).toBe( "pre" );
					expect( preFunctions[1].getArgs() ).toBe( { test=true, cool="really" } );
					expect( preFunctions[1].getCondition().getHandler() ).toBe( "function1.condition.handler" );
					expect( preFunctions[1].getCondition().getArgs() ).toBe( { test="blah" } );

					expect( preFunctions[2].getId() ).toBe( "function-2" );
					expect( preFunctions[2].getMeta() ).toBe( { title="Function 2" } );
					expect( preFunctions[2].getPreOrPost() ).toBe( "pre" );
					expect( preFunctions[2].getCondition().getHandler() ).toBe( "function2conditionid" );
				} );

				it( "should read all post functions from default results", function(){
					var postFunctions = wf.getSteps()[1].getActions()[1].getDefaultResult().getPostFunctions();

					expect( postFunctions.len() ).toBe( 2 );

					expect( postFunctions[1].getId() ).toBe( "function-1" );
					expect( postFunctions[1].getMeta() ).toBe( { title="Function 1" } );
					expect( postFunctions[1].getPreOrPost() ).toBe( "post" );
					expect( postFunctions[1].getCondition().getHandler() ).toBe( "function1.condition.handler" );

					expect( postFunctions[2].getId() ).toBe( "function-2" );
					expect( postFunctions[2].getMeta() ).toBe( { title="Function 2" } );
					expect( postFunctions[2].getPreOrPost() ).toBe( "post" );
					expect( postFunctions[2].getCondition().getHandler() ).toBe( "function2conditionid" );
				} );

				it( "should read all pre functions from conditional results", function(){
					var preFunctions = wf.getSteps()[1].getActions()[1].getConditionalResults()[1].getPreFunctions();

					expect( preFunctions.len() ).toBe( 2 );

					expect( preFunctions[1].getId() ).toBe( "function-1" );
					expect( preFunctions[1].getMeta() ).toBe( {title="Function 1"} );
					expect( preFunctions[1].getPreOrPost() ).toBe( "pre" );
					expect( preFunctions[1].getCondition().getHandler() ).toBe( "function1.condition.handler" );

					expect( preFunctions[2].getId() ).toBe( "function-2" );
					expect( preFunctions[2].getMeta() ).toBe( {title="Function 2"} );
					expect( preFunctions[2].getPreOrPost() ).toBe( "pre" );
					expect( preFunctions[2].getCondition().getHandler() ).toBe( "function2conditionid" );
				} );

				it( "should read all post functions from conditional results", function(){
					var postFunctions = wf.getSteps()[1].getActions()[1].getConditionalResults()[2].getPostFunctions();

					expect( postFunctions.len() ).toBe( 2 );

					expect( postFunctions[1].getId() ).toBe( "function-1" );
					expect( postFunctions[1].getMeta() ).toBe( {title="Function 1"} );
					expect( postFunctions[1].getPreOrPost() ).toBe( "post" );
					expect( postFunctions[1].getCondition().getHandler() ).toBe( "function1.condition.handler" );

					expect( postFunctions[2].getId() ).toBe( "function-2" );
					expect( postFunctions[2].getMeta() ).toBe( {title="Function 2"} );
					expect( postFunctions[2].getPreOrPost() ).toBe( "post" );
					expect( postFunctions[2].getCondition().getHandler() ).toBe( "function2conditionid" );
				} );
			} );
		} );
	}

	private any function _getWorkflowStructFromYaml() {
		var yaml = FileRead( "/tests/resources/yaml/fullSpecExample.yaml" );

		return new cfflow.models.util.YamlParser().deserialize( yaml );
	}

}