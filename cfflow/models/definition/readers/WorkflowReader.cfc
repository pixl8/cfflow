component singleton {

// CONSTRUCTOR
	/**
	 * @workflowFactory.inject WorkflowFactory@cfflow
	 * @schemaValidator.inject WorkflowSchemaValidator@cfflow
	 * @schemaUtil.inject      WorkflowSchemaUtil@cfflow
	 *
	 */
	public any function init(
		  required any workflowFactory
		, required any schemaValidator
		, required any schemaUtil
	) {
		_setWorkflowFactory( arguments.workflowFactory );
		_setSchemaValidator( arguments.schemaValidator );
		_setSchemaUtil( arguments.schemaUtil );

		return this;
	}

// PUBLIC API METHODS
	public any function read( required struct workflow ) {
		_getSchemaValidator().validate( arguments.workflow );

		var wf    = arguments.workflow.workflow ?: {};
		var wfObj = _getWorkflowFactory().getWorkflow(
			  id    = wf.id    ?: "unknown"
			, meta  = wf.meta  ?: {}
			, class = wf.class ?: "unknown"
		);

		var initialActions = wf.initialActions ?: [];
		for( var action in initialActions ) {
			_addInitialAction( wfObj, action );
		}

		var steps = wf.steps ?: [];
		for( var step in steps ) {
			_addStep( wfObj, step );
		}


		return wfObj;
	}

// PRIVATE HELPERS
	private void function _addInitialAction( wf, action ) {
		var wfAction = wf.addInitialAction(
			  id          = arguments.action.id     ?: "unknown"
			, title       = arguments.action.title  ?: "unknown"
			, isAutomatic = true
			, condition   = _createCondition( arguments.action.condition ?: "" )
		);

		_addDefaultResult( wfAction, arguments.action.defaultResult ?: {} );

		var results = action.conditionalResults ?: [];
		for( var result in results ) {
			_addConditionalResult( wfAction, result );
		}
	}

	private void function _addStep( wf, step ) {
		var wfStep = wf.addStep(
			  id          = arguments.step.id          ?: "unknown"
			, title       = arguments.step.title       ?: "unknown"
			, description = arguments.step.description ?: ""
		);

		var timers = arguments.step.autoActionTimers ?: [];
		for( var timer in timers ) {
			wfStep.addAutoActionTimer(
				  interval = _getSchemaUtil().convertTimeIntervalToSeconds( timer.interval ?: "0m" )
				, count    = Val( timer.count ?: 0 )
			);
		}
		var actions = arguments.step.actions ?: [];
		for( var action in actions ) {
			_addAction( wfstep, action );
		}
	}

	private void function _addAction( wfstep, action ) {
		var wfAction = wfstep.addAction(
			  id          = arguments.action.id     ?: "unknown"
			, title       = arguments.action.title  ?: "unknown"
			, isAutomatic = IsBoolean( arguments.action.isAutomatic ?: "" ) && arguments.action.isAutomatic
			, condition   = _createCondition( arguments.action.condition ?: "" )
		);

		_addDefaultResult( wfAction, arguments.action.defaultResult ?: {} );

		var results = action.conditionalResults ?: [];
		for( var result in results ) {
			_addConditionalResult( wfAction, result );
		}
	}

	private void function _addDefaultResult( wfAction, result ) {
		wfAction.setDefaultResult(
			  id    = arguments.result.id        ?: "unknown"
			, title = arguments.result.title     ?: "unknown"
			, type  = arguments.result.type      ?: ""
		);

		var wfResult = wfAction.getDefaultResult();
		_addResultTransitionsAndFunctions( wfResult, result );
	}

	private void function _addConditionalResult( wfAction, result ) {
		var wfResult = wfAction.addConditionalResult(
			  id           = arguments.result.id        ?: "unknown"
			, title        = arguments.result.title     ?: "unknown"
			, type         = arguments.result.type      ?: ""
			, condition    = _createCondition( arguments.result.condition ?: "" )
		);
		_addResultTransitionsAndFunctions( wfResult, result );
	}

	private void function _addResultTransitionsAndFunctions( wfResult, result ) {
		var transitions = arguments.result.transitions ?: [];
		for( var transition in transitions ) {
			wfResult.addTransition(
				  step   = transition.step ?: ""
				, status = transition.status ?: ""
			);
		}

		var preFunctions = arguments.result.functions.pre ?: [];
		for( var pf in preFunctions ) {
			wfResult.addPreFunction(
				  id        = pf.id        ?: "unknown"
				, title     = pf.title     ?: "unknown"
				, handler   = pf.handler   ?: "unknown"
				, args      = pf.args      ?: {}
				, condition = _createCondition( pf.condition ?: "" )
			);
		}

		var postFunctions = arguments.result.functions.post ?: [];
		for( var pf in postFunctions ) {
			wfResult.addPostFunction(
				  id        = pf.id        ?: "unknown"
				, title     = pf.title     ?: "unknown"
				, handler   = pf.handler   ?: "unknown"
				, args      = pf.args      ?: {}
				, condition = _createCondition( pf.condition ?: "" )
			);
		}
	}

	private any function _createCondition( required any condition ) {
		if ( IsStruct( arguments.condition ) ) {
			return _getWorkflowFactory().getCondition( argumentCollection=condition );
		}
	}

// GETTERS AND SETTERS
	private any function _getWorkflowFactory() {
	    return _workflowFactory;
	}
	private void function _setWorkflowFactory( required any workflowFactory ) {
	    _workflowFactory = arguments.workflowFactory;
	}

	private any function _getSchemaValidator() {
	    return _schemaValidator;
	}
	private void function _setSchemaValidator( required any schemaValidator ) {
	    _schemaValidator = arguments.schemaValidator;
	}

	private any function _getSchemaUtil() {
	    return _schemaUtil;
	}
	private void function _setSchemaUtil( required any schemaUtil ) {
	    _schemaUtil = arguments.schemaUtil;
	}
}