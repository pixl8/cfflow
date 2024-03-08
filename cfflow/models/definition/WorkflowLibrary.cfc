component singleton {

	variables._library = {};

	/**
	 * @workflowReader.inject workflowReader@cfflow
	 */
	public any function init( required any workflowReader ) {
		_setWorkflowReader( arguments.workflowReader );
	}


	public void function registerWorkflow( required Workflow wf ) {
		variables._library[ arguments.wf.getId() ] = arguments.wf.getRaw(); // much cheaper memory use to store in raw structs
	}

	public any function getWorkflow( required string id ) {
		var key = "_cfflowwf#arguments.id#";

		if ( !StructKeyExists( request, key ) ) {
			// once per request, deserialize raw wf into our WF data model
			var flow = variables._library[ arguments.id ] ?: throw(
				  "The workflow [#arguments.id#] has not been registered with the cfflow library."
				, "cfflow.workflow.does.not.exist"
			);

			request[ key ] = _getWorkflowReader().read( { workflow=flow }, false );
		}

		return request[ key ];
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