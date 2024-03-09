component singleton {

	variables._library = {};

	/**
	 * @workflowReader.inject workflowReader@cfflow
	 */
	public any function init( required any workflowReader ) {
		_setWorkflowReader( arguments.workflowReader );
	}


	public void function registerWorkflow( required Workflow wf ) {
		var full = StructNew( "weak" ); // a simple cache

		full.flow = arguments.wf;

		variables._library[ arguments.wf.getId() ] = {
			  raw = arguments.wf.getRaw() // much cheaper memory use to store in raw structs
			, full = full
		}
	}

	public any function getWorkflow( required string id ) {
		if ( !StructKeyExists( variables._library, arguments.id ) ) {
			throw(
				  "The workflow [#arguments.id#] has not been registered with the cfflow library."
				, "cfflow.workflow.does.not.exist"
			);
		}

		if ( !StructKeyExists( variables._library[ arguments.id ].full, "flow" ) || IsNull( variables._library[ arguments.id ].full.flow ) ) {
			variables._library[ arguments.id ].full.flow = _getWorkflowReader().read( { workflow=variables._library[ arguments.id ].raw }, false )
		}

		return variables._library[ arguments.id ].full.flow;
	}

	public boolean function workflowExists( required string id ) {
		return StructKeyExists( variables._library, arguments.id );
	}

	private void function _setWorkflowReader( required any workflowReader ) {
		variables._workflowReader = arguments.workflowReader;
	}
	private any function _getWorkflowReader() {
		return variables._workflowReader;
	}


}