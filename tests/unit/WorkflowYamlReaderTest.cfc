component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "YAML Workflow reader", function() {
			var reader  = "";

			beforeEach( function(){
				reader = CreateMock( object=new cfflow.models.definition.readers.WorkflowYamlReader(
					  workflowFactory = new cfflow.models.definition.WorkflowFactory()
					, yamlParser      = new cfflow.models.util.YamlParser()
					, schemaValidator = new cfflow.models.definition.validation.WorkflowSchemaValidator()
					, schemaUtil      = new cfflow.models.util.WorkflowSchemaUtil()
				) );
			} );

			describe( "read( yaml )", function() {
				var wf = "";

				beforeEach( function(){
					wf = reader.read( _getYaml() );
				} );

				it( "should use yaml parser to convert to struct and then use the Struct reader to read workflow", function(){
					expect( wf.getId() ).toBe( "test-workflow" );
					expect( wf.getMeta().title ).toBe( "Test workflow" );
					expect( wf.getClass() ).toBe( "pixl8.webflow" );
				} );
			} );
		} );
	}

	private string function _getYaml() {
		return FileRead( "/tests/resources/yaml/fullSpecExample.yaml" );
	}

}