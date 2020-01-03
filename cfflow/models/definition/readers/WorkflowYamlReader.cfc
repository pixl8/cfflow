component extends="WorkflowReader" singleton {

// CONSTRUCTOR
	/**
	 * @workflowFactory.inject WorkflowFactory@cfflow
	 * @schemaValidator.inject WorkflowSchemaValidator@cfflow
	 * @schemaUtil.inject      WorkflowSchemaUtil@cfflow
	 * @yamlParser.inject      parser@cbyaml
	 */
	public any function init(
		  required any workflowFactory
		, required any schemaValidator
		, required any schemaUtil
		, required any yamlParser
	) {
		super.init( argumentCollection=arguments );
		_setYamlParser( arguments.yamlParser );

		return this;
	}

// PUBLIC API METHODS
	public any function read( required string yamlWorkflow ) {
		return super.read( _getYamlParser().deserialize( arguments.yamlWorkflow ) );
	}

// GETTERS AND SETTERS
	private any function _getYamlParser() {
	    return _yamlParser;
	}
	private void function _setYamlParser( required any yamlParser ) {
	    _yamlParser = arguments.yamlParser;
	}
}