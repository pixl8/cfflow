---
layout: page
title: Creating a state storage implementation
nav_order: 4
parent: Extending CfFlow
grand_parent: Guides
---

# Creating a state storage implementation

Storage implementations are responsible for persisting the state of your workflow instances. State can be added to by [workflow functions](functions.html) and also by your own code that interacts with workflow instances, for example:

```cfc
public void function do( required WorkflowInstance wfInstance, required struct args ) {
	arguments.wfInstance.appendState( {
		userId = $getLoggedInUserId()
	} );
}
```

## The IWorkflowInstanceStorage interface

To implement your own instance storage, create a CFC that implements the `cfflow.models.implementation.interfaces.IWorkflowInstanceStorage` interface. The interface is as follows:

```cfc
interface {

	public boolean function instanceExists( required string workflowId, required struct instanceArgs );
	public void    function createInstance( required string workflowId, required struct instanceArgs );
	public struct  function getState( required string workflowId, required struct instanceArgs );
	public void    function setState( required string workflowId, required struct instanceArgs, required struct state );
	public void    function appendState( required string workflowId, required struct instanceArgs, required struct state );
	public string  function getStepStatus( required string workflowId, required struct instanceArgs, required string step );
	public void    function setStepStatus( required string workflowId, required struct instanceArgs, required string step, required string status );
	public struct  function getAllStepStatuses( required string workflowId, required struct instanceArgs );
	public void    function setComplete( required string workflowId, required struct instanceArgs );
	public void    function recordAction( required string workflowId, required struct instanceArgs, required struct state, required string actionId, required string resultId, required array transitions );
}
```

## Register your instance storage implementation

To use your storage implementation class, you must register it using `cfflow.registerStorageClass()`:

```cfc
var myStorage = new my.CustomInstanceStorage();

cfflow.registerStorageClass(
	  className      = "my.storage.class"
	, implementation = myStorage
);
```

## Example implementation using Preside database objects

```cfc
/**
 * @presideService true
 * @singleton      true
 */
component implements="cfflow.models.implementation.interfaces.IWorkflowInstanceStorage" {

// CONSTRUCTOR
	/**
	 * @instanceDao.inject   presidecms:object:cfflow_workflow_instance
	 * @stepStatusDao.inject presidecms:object:cfflow_workflow_instance_step
	 * @historyDao.inject    presidecms:object:cfflow_workflow_instance_history
	 * @transitionDao.inject presidecms:object:cfflow_workflow_instance_history_transition
	 *
	 */
	public any function init(
		  required any instanceDao
		, required any stepStatusDao
		, required any historyDao
		, required any transitionDao
	) {
		_setInstanceDao( arguments.instanceDao );
		_setStepStatusDao( arguments.stepStatusDao );
		_setHistoryDao( arguments.historyDao );
		_setTransitionDao( arguments.transitionDao );

		return this;
	}

// PUBLIC API METHODS
	public boolean function instanceExists( required string workflowId, required struct instanceArgs ){
		return _getInstanceDao().dataExists( filter=_getInstanceFilter( argumentCollection=arguments ) );
	}

	public void function createInstance( required string workflowId, required struct instanceArgs ) {
		_getInstanceDao().insertData( data={
			  workflow_id   = arguments.workflowId
			, owner         = arguments.instanceArgs.owner        ?: ""
			, reference     = arguments.instanceArgs.reference    ?: ""
			, sub_reference = arguments.instanceArgs.subreference ?: ""
		} );
	}

	public struct function getState( required string workflowId, required struct instanceArgs ) {
		var instanceRecord = _getInstance( argumentCollection=arguments );

		if ( Len( Trim( instanceRecord.state ?: "" ) ) ) {
			try {
				var state = DeserializeJson( instanceRecord.state );
				if ( IsStruct( state ) ) {
					return state;
				}
			} catch( any e ) {
				$raiseError( e );
			}
		}

		return {};
	}

	public void function setState( required string workflowId, required struct instanceArgs, required struct state ){
		_getInstanceDao().updateData(
			  filter = _getInstanceFilter( argumentCollection=arguments )
			, data   = { state=SerializeJson( arguments.state ) }
		);
	}

	public void function appendState( required string workflowId, required struct instanceArgs, required struct state ){
		var newState = getState( argumentCollection=arguments );

		StructAppend( newState, arguments.state );

		setState( argumentCollection=arguments, state=newState );
	}

	public string function getStepStatus( required string workflowId, required struct instanceArgs, required string step ) {
		var statusRecord = _getStepStatusDao().selectData( filter=_getStepFilter( argumentCollection=arguments ) );

		return statusRecord.status ?: "";
	}
	public void function setStepStatus( required string workflowId, required struct instanceArgs, required string step, required string status ){
		var updated = _getStepStatusDao().updateData(
			  filter = _getStepFilter( argumentCollection=arguments )
			, data   = { status=arguments.status }
		);

		if ( !updated ) {
			var instance = _getInstance( argumentCollection=arguments );
			if ( instance.recordCount ) {
				_getStepStatusDao().insertData( data={
					  instance = instance.id
					, step     = arguments.step
					, status   = arguments.status
				} );
			}
		}
	}
	public struct function getAllStepStatuses( required string workflowId, required struct instanceArgs ){
		var records = _getStepStatusDao().selectData( filter=_getStepFilter( argumentCollection=arguments ) );
		var statuses = {};

		for( var step in records ) {
			statuses[ step.step ] = step.status;
		}

		return statuses;
	}
	public void function setComplete( required string workflowId, required struct instanceArgs ) {
		_getInstanceDao().updateData(
			  filter = _getInstanceFilter( argumentCollection=arguments )
			, data   = { completed=true }
		);
	}

	public void function recordAction(
		  required string workflowId
		, required struct instanceArgs
		, required struct state
		, required string actionId
		, required string resultId
		, required array  transitions
	) {
		var instance = _getInstance( argumentCollection=arguments );
		if ( instance.recordCount ) {
			var historyId = _getHistoryDao().insertData( data={
				  instance = instance.id
				, action   = arguments.actionId
				, result   = arguments.resultId
				, state    = SerializeJson( arguments.state )
			} );

			for( var transition in arguments.transitions ) {
				_getTransitionDao().insertData( data={
					  history = historyId
					, step    = transition.getStep()
					, status  = transition.getStatus()
				} );
			}
		}
	}

// PRIVATE HELPERS
	private any function _getInstance( required string workflowId, required struct instanceArgs ) {
		return _getInstanceDao().selectData( filter=_getInstanceFilter( argumentCollection=arguments ) );
	}

	private struct function _getInstanceFilter( required string workflowId, required struct instanceArgs ) {
		return {
			  workflow_id   = arguments.workflowId
			, owner         = arguments.instanceArgs.owner        ?: ""
			, reference     = arguments.instanceArgs.reference    ?: ""
			, sub_reference = arguments.instanceArgs.subreference ?: ""
		};
	}

	private struct function _getStepFilter( required string workflowId, required struct instanceArgs, string step="" ) {
		var filter = {
			  "instance.workflow_id"   = arguments.workflowId
			, "instance.owner"         = arguments.instanceArgs.owner        ?: ""
			, "instance.reference"     = arguments.instanceArgs.reference    ?: ""
			, "instance.sub_reference" = arguments.instanceArgs.subreference ?: ""
		};

		if ( Len( Trim( arguments.step ) ) ){
			filter.step = arguments.step;
		}

		return filter;
	}

// GETTERS AND SETTERS
	private any function _getInstanceDao() {
	    return _instanceDao;
	}
	private void function _setInstanceDao( required any instanceDao ) {
	    _instanceDao = arguments.instanceDao;
	}

	private any function _getStepStatusDao() {
	    return _stepStatusDao;
	}
	private void function _setStepStatusDao( required any stepStatusDao ) {
	    _stepStatusDao = arguments.stepStatusDao;
	}

	private any function _getHistoryDao() {
	    return _historyDao;
	}
	private void function _setHistoryDao( required any historyDao ) {
	    _historyDao = arguments.historyDao;
	}

	private any function _getTransitionDao() {
	    return _transitionDao;
	}
	private void function _setTransitionDao( required any transitionDao ) {
	    _transitionDao = arguments.transitionDao;
	}

}
```


