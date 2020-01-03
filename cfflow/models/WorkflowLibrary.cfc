component singleton {

	variables._library = {};

	public void function registerWorkflow( required Workflow wf ) {
		variables._library[ arguments.wf.getId() ] = arguments.wf;
	}

	public any function getWorkflow( required string id ) {
		return variables._library[ arguments.id ] ?: throw(
			  "The workflow [#arguments.id#] has not been registered with the cfflow library."
			, "cfflow.workflow.does.not.exist"
		);
	}

	public boolean function workflowExists( required string id ) {
		return StructKeyExists( variables._library, arguments.id );
	}

}