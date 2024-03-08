component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow Library", function() {
			var _library = "";

			beforeEach( function(){
				factory = CreateMock( object=new cfflow.models.definition.WorkflowFactory() );
				reader = CreateMock( object=new cfflow.models.definition.readers.WorkflowReader(
					  workflowFactory = factory
					, schemaValidator = new cfflow.models.definition.validation.WorkflowSchemaValidator()
					, schemaUtil      = new cfflow.models.util.WorkflowSchemaUtil()
				) );
				_library = CreateMock( object=new cfflow.models.definition.WorkflowLibrary( reader ) );
			} );

			describe( "workflowExists()", function(){
				it( "it should return false when the flow has not been registered", function(){
					expect( _library.workflowExists( "whatever" ) ).toBeFalse();
				} );

				it( "should return true when the flow has been registered", function(){
					var wf = CreateMock( "cfflow.models.definition.spec.Workflow" );
					var id = CreateUUId();

					wf.$( "getId", id );

					_library.registerWorkflow( wf );
					expect( _library.workflowExists( id ) ).toBeTrue();
				} );
			} );

			describe( "getWorkflow( id )", function(){
				it( "should return the workflow by the given ID", function(){
					var wf = CreateMock( "cfflow.models.definition.spec.Workflow" );
					var id = CreateUUId();

					wf.$( "getId", id );

					_library.registerWorkflow( wf );
					expect( _library.getWorkflow( id ).getId() ).toBe( id );
					expect( _library.workflowExists( id ) ).toBeTrue();
				} );

				it( "should raise an informative error when the workflow does not exist", function(){
					expect( function(){
						_library.getWorkflow( "whatever" )
					} ).toThrow( "cfflow.workflow.does.not.exist" );
				} );
			} );

			describe( "registerWorkflow( wf )", function(){
				it( "should accept a workflow instance and add it to the internal library", function(){
					var wf = CreateMock( "cfflow.models.definition.spec.Workflow" );
					var id = CreateUUId();

					wf.$( "getId", id );

					_library.registerWorkflow( wf );
					expect( _library.getWorkflow( id ).getId() ).toBe( id );
					expect( _library.workflowExists( id ) ).toBeTrue();
				} );
			} );

		} );
	}
}