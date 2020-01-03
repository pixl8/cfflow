component singleton implements="IWorkflowImplementation" {

	/**
	 * @coldbox.inject coldbox
	 *
	 */
	public any function init( required any coldbox ) {
		_setColdbox( arguments.coldbox );

		return this;
	}

	public any function getInstance( required struct instanceArgs ) {
		throw( "Instances are not implemented in the default workflow implementation. You will need to create your own implementation if you wish to use this feature.", "cfflow.instances.not.implemented" );
	}

	public IWorkflowInstance function createInstance( required struct instanceArgs ) {
		throw( "Instances are not implemented in the default workflow implementation. You will need to create your own implementation if you wish to use this feature.", "cfflow.instances.not.implemented" );
	}

	public boolean function evaluateCondition(
		  required WorkflowCondition wfCondition
		, required IWorkflowInstance wfInstance
	) {
		if ( !_getColdbox().handlerExists( arguments.wfCondition.getHandler() ) ) {
			throw( "Workflow condition handler, [#arguments.wfCondition.getHandler()#], does not exist.", "cfflow.condition.handler.does.not.exist" );
		}
		var result = _getColdbox().runEvent(
			  event = arguments.wfCondition.getHandler()
			, private = true
			, prePostExempt = true
			, eventArguments = { conditionArgs=arguments.wfCondition.getArgs(), wfInstance=arguments.wfInstance }
		);

		if ( !IsNull( local.result ) && IsBoolean( result ) ) {
			return result;
		}

		return false;

	}

	public void function executeFunction(
		  required WorkflowFunction wfFunction
		, required IWorkflowInstance wfInstance
	) {
		if ( !_getColdbox().handlerExists( arguments.wfFunction.getHandler() ) ) {
			throw( "Workflow function handler, [#arguments.wfFunction.getHandler()#], does not exist.", "cfflow.function.handler.does.not.exist" );
		}

		_getColdbox().runEvent(
			  event = arguments.wfFunction.getHandler()
			, private = true
			, prePostExempt = true
			, eventArguments = { wfInstance=arguments.wfInstance, functionArgs=arguments.wfFunction.getArgs() }
		);
	}

	public void function scheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId, required array timers ) {
		throw( "Scheduled auto actions is not implemented in the default workflow implementation. You will need to create your own implementation if you wish to use this feature.", "cfflow.scheduling.not.implemented" );
	}

	public void function unScheduleAutoActions( required IWorkflowInstance wfInstance, required string stepId ) {
		throw( "Scheduled auto actions is not implemented in the default workflow implementation. You will need to create your own implementation if you wish to use this feature.", "cfflow.scheduling.not.implemented" );
	}

// GETTERS AND SETTERS
	private any function _getColdbox() {
	    return _coldbox;
	}
	private void function _setColdbox( required any coldbox ) {
	    _coldbox = arguments.coldbox;
	}
}