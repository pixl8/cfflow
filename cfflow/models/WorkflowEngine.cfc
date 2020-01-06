/**
 * The workflow engine is the entry point for all cfflow
 * implementation programmers to interact with workflow
 * definitions and instances.
 */
component singleton {

	public any function init() {
		_setWorkflowLibrary( new definition.WorkflowLibrary() );
		_setImplementationFactory( new implementation.WorkflowImplementationFactory() );

		return this;
	}

// INSTANCES
	public boolean function instanceExists( required string workflowId, struct instanceArgs={} ) {
		var wf   = getWorkflowDefinition( arguments.workflowId );
		var impl = getImplementation( wf );

		return impl.instanceExists( instanceArgs=arguments.instanceArgs );
	}

	public any function getInstance( required string workflowId, struct instanceArgs={} ) {
		var wf             = getWorkflowDefinition( arguments.workflowId );
		var impl           = getImplementation( wf );
		var instanceExists = impl.instanceExists( instanceArgs=arguments.instanceArgs );

		if ( instanceExists ) {
			return new instances.WorkflowInstance(
				  workflowId             = arguments.workflowId
				, instanceArgs           = arguments.instanceArgs
				, workflowDefinition     = wf
				, workflowImplementation = impl
				, workflowEngine         = this
			);
		}

		return;
	}

	public WorkflowInstance function createInstance( required string workflowId, struct instanceArgs={}, struct initialState={}, string initialActionId ) {
		var wf         = getWorkflowDefinition( arguments.workflowId );
		var impl       = getImplementation( wf );
		var wfInstance = "";

		impl.createInstance(
			  workflowId   = arguments.workflowId
			, instanceArgs = arguments.instanceArgs
		);
		wfInstance = getInstance( workflowId=arguments.workflowId, instanceArgs=arguments.instanceArgs );

		initializeInstance(
			  wfInstance      = wfInstance
			, initialState    = arguments.initialState
			, initialActionId = arguments.initialActionId ?: NullValue()
		);

		return wfInstance;
	}

	public void function initializeInstance( required WorkflowInstance wfInstance, struct initialState={}, string initialActionId ) {
		if ( StructCount( arguments.initialState ) ) {
			arguments.wfInstance.setState( arguments.initialState );
		}

		doInitialAction(
			  wfInstance      = arguments.wfInstance
			, initialActionId = arguments.initialActionId ?: NullValue()
		);
	}

	public void function doInitialAction(
		  required WorkflowInstance wfInstance
		,          string           initialActionId = ""
	) {
		var wf             = getWorkflowDefinition( arguments.wfInstance.getWorkflowId() );
		var actions        = wf.getInitialActions();
		var specificAction = Len( Trim( arguments.initialActionId ) );

		for( var action in actions ) {
			var useAction = !specificAction || action.getId() == arguments.initialActionId;

			if ( !useAction ) {
				continue;
			}

			if ( action.hasCondition() ) {
				useAction = evaluateCondition( wfInstance=arguments.wfInstance, wfCondition=action.getCondition() );
				if ( !useAction ) {
					continue;
				}
			}

			doAction( wfInstance=arguments.wfInstance, wfAction=action );
			return;
		}

		throw( "The workflow [#wf.getId()#] could not be initialized. No initial actions met their conditional criteria.", "cfflow.no.initial.actions.runnable" );
	}

// LIBRARY PROXIES
	public void function registerWorkflow( required Workflow wf ) {
		_getWorkflowLibrary().registerWorkflow( argumentCollection=arguments );
	}

	public Workflow function getWorkflowDefinition( required string workflowId ) {
		return _getWorkflowLibrary().getWorkflow( arguments.workflowId );
	}

// IMPLEMENTATION PROXIES
	public void function registerWorkflowClass(
		  required string className
		, required string storageClass
		, required string functionExecutor
		, required string conditionEvaluator
		, required string scheduler
	) {
		_getImplementationFactory().registerWorkflowClass( argumentCollection=arguments );
	}
	public void function registerStorageClass(
		  required string                   className
		, required IWorkflowInstanceStorage implementation
	) {
		_getImplementationFactory().registerStorageClass( argumentCollection=arguments );
	}
	public void function registerFunctionExecutor(
		  required string                    className
		, required IWorkflowFunctionExecutor implementation
	) {
		_getImplementationFactory().registerFunctionExecutor( argumentCollection=arguments );
	}
	public void function registerConditionEvaluator(
		  required string                       className
		, required IWorkflowConditionEvaluator implementation
	) {
		_getImplementationFactory().registerConditionEvaluator( argumentCollection=arguments );
	}
	public void function registerScheduler(
		  required string             className
		, required IWorkflowScheduler implementation
	) {
		_getImplementationFactory().registerScheduler( argumentCollection=arguments );
	}


// PUBLIC API
	public WorkflowImplementation function getImplementation( required Workflow wf ) {
		return _getImplementationFactory().getWorkflowImplementation( wf.getClass() );
	}

	public void function doAction( required WorkflowInstance wfInstance, required WorkflowAction wfAction ) {
		doResult(
			  wfInstance = arguments.wfInstance
			, wfResult   = getResultToExecute( arguments.wfInstance, arguments.wfAction )
		);
	}

	public void function doResult( required WorkflowInstance wfInstance, required WorkflowResult wfResult ) {
		var preFunctions  = filterFunctionsToExecute( arguments.wfInstance, arguments.wfResult.getPreFunctions() );
		var postFunctions = filterFunctionsToExecute( arguments.wfInstance, arguments.wfResult.getPostFunctions() );
		var transitions   = arguments.wfResult.getTransitions();

		for( var fn in preFunctions ) {
			doFunction( wfInstance=arguments.wfInstance, wfFunction=fn );
		}

		for( var transition in transitions ) {
			doTransition( wfInstance=arguments.wfInstance, wfTransition=transition );
		}

		for( var fn in postFunctions ) {
			doFunction( wfInstance=arguments.wfInstance, wfFunction=fn );
		}
	}

	public void function doTransition(
		  required WorkflowInstance  wfInstance
		, required WorkflowTransition wfTransition
	) {
		var impl = arguments.wfInstance.getWorkflowImplementation();

		impl.setStepStatus(
			  instanceArgs = arguments.wfInstance.getInstanceArgs()
			, step   = arguments.wfTransition.getStep()
			, status = arguments.wfTransition.getStatus()
		);

		if ( arguments.wfTransition.getStatus() == "active" ) {
			scheduleAutoActions(
				  stepId     = arguments.wfTransition.getStep()
				, wfInstance = arguments.wfInstance
			);
		} else {
			unScheduleAutoActions(
				  stepId     = arguments.wfTransition.getStep()
				, wfInstance = arguments.wfInstance
			);
		}
	}

	public WorkflowResult function getResultToExecute( required WorkflowInstance wfInstance, required WorkflowAction wfAction ) {
		var conditionalResults = arguments.wfAction.getConditionalResults();

		for( var result in conditionalResults ) {
			if ( evaluateCondition( result.getCondition(), arguments.wfInstance ) ) {
				return result;
			}
		}

		return arguments.wfAction.getDefaultResult();
	}

	public boolean function evaluateCondition( required  WorkflowCondition wfCondition, required WorkflowInstance wfInstance ) {
		var impl = arguments.wfInstance.getWorkflowImplementation();

		return impl.evaluateCondition( arguments.wfCondition, arguments.wfInstance );
	}

	public void function doFunction( required WorkflowInstance wfInstance, required WorkflowFunction wfFunction ) {
		var impl = arguments.wfInstance.getWorkflowImplementation();

		impl.executeFunction( wfInstance=arguments.wfInstance, wfFunction=arguments.wfFunction );
	}

	public array function filterFunctionsToExecute( required WorkflowInstance wfInstance, required array functions ) {
		var filtered = [];

		for( var fn in arguments.functions ) {
			if ( !fn.hasCondition() || evaluateCondition( fn.getCondition(), arguments.wfInstance ) ) {
				filtered.append( fn );
			}
		}

		return filtered;
	}

	public WorkflowStep function getStepForInstance( required WorkflowInstance wfInstance, required string stepId ) {
		var steps = getWorkflowDefinition( arguments.wfInstance.getWorkflowId() ).getSteps();

		for( var step in steps ) {
			if ( step.getId() == arguments.stepId ) {
				return step;
			}
		}
	}

	public void function scheduleAutoActions( required WorkflowInstance wfInstance, required string stepId ) {
		var wfStep = getStepForInstance( wfInstance=arguments.wfInstance, stepId=arguments.stepId );

		if ( wfStep.hasAutoActions() ) {
			if ( wfStep.hasAutoActionTimers() ) {
				arguments.wfInstance.getWorkflowImplementation().scheduleAutoActions(
					  wfInstance = arguments.wfInstance
					, stepId     = arguments.stepId
					, timers     = wfStep.getAutoActionTimers()
				);
			} else {
				// immediate execution
				doAutoActions( wfInstance=arguments.wfInstance, wfStep=wfStep );
			}
		}
	}

	public void function unScheduleAutoActions() {
		var wfStep = getStepForInstance( wfInstance=arguments.wfInstance, stepId=arguments.stepId );

		if ( wfStep.hasAutoActions() ) {
			if ( wfStep.hasAutoActionTimers() ) {
				arguments.wfInstance.getWorkflowImplementation().unScheduleAutoActions(
					  wfInstance = arguments.wfInstance
					, stepId     = arguments.stepId
				);
			}
		}
	}

	public boolean function doAutoActions(
		  required WorkflowInstance wfInstance
		,          string            stepId = ""
		,          WorkflowStep      wfStep = getStepForInstance( arguments.wfInstance, arguments.stepId )
	) {
		for( var action in arguments.wfStep.getActions() ) {
			if ( action.getIsAutomatic() ) {
				if ( !action.hasCondition() || evaluateCondition( wfInstance=arguments.wfInstance, wfCondition=action.getCondition() ) ) {
					doAction( wfInstance=arguments.wfInstance, wfAction=action );
					return true;
				}
			}
		}
		return false;
	}

// GETTERS AND SETTERS
	private any function _getWorkflowLibrary() {
	    return _workflowLibrary;
	}
	private void function _setWorkflowLibrary( required any workflowLibrary ) {
	    _workflowLibrary = arguments.workflowLibrary;
	}

	private any function _getImplementationFactory() {
	    return _implementationFactory;
	}
	private void function _setImplementationFactory( required any implementationFactory ) {
	    _implementationFactory = arguments.implementationFactory;
	}

}