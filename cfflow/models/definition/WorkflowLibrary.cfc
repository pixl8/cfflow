component singleton {

	variables._library = {};

	/**
	 * @workflowReader.inject workflowReader@cfflow
	 */
	public any function init( required any workflowReader ) {
		_setWorkflowReader( arguments.workflowReader );
	}


	public void function registerWorkflow( required Workflow wf ) {
		variables._library[ arguments.wf.getId() ] = {
			  raw = arguments.wf.getRaw() // much cheaper memory use to store in raw structs
			, full = CreateObject( "java", "java.lang.ref.WeakReference" ).init( arguments.wf )
		}
	}

	public any function getWorkflow( required string id ) {
		var flow = variables._library[ arguments.id ] ?: throw(
			  "The workflow [#arguments.id#] has not been registered with the cfflow library."
			, "cfflow.workflow.does.not.exist"
		);

		if ( !StructKeyExists( flow, "full" ) || IsNull( flow.full ) || IsNull( flow.full.get() ) ) {
			flow.full = _reanimate( flow );
		}

		return flow.full.get();
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

	private any function _reanimate( flow ) {
		var wf = _getWorkflowReader().read( { workflow=arguments.flow.raw }, false );

		return CreateObject( "java", "java.lang.ref.WeakReference" ).init( wf )
	}

}