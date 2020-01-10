---
layout: page
title: Creating a scheduler implementation
nav_order: 5
parent: Extending CfFlow
grand_parent: Guides
---

# Creating a scheduler implementation

Scheduler implementations are responsible for delaying automatic workflow action execution. For example, you may have a workflow where you only move to the next step when something happens in the future. You may define that you wish to check this once a day for up to a year:

```yaml
steps:
- id: paused.waiting
  autoActionTimers:
  - interval: 1d
    count: 365
  actions:
  - id: next
    condition:
      ref: custom.SomethingIsTrue
    defaultResult:
      transitions:
      - step: paused.waiting
        status: completed
      - step: continue.to.do.something
        status: active

# ...
```

## The IWorkflowScheduler interface

Implementing a scheduler is achieved by creating a CFC that implements the `cfflow.models.implementation.interfaces.IWorkflowScheduler` interface and registering it with the CfFlow engine. The interface definition is as follows:

```cfc
interface {

	public void function scheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
		, required array  timers
	);

	public void function unScheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
	);

}
```

## Registering a scheduler

Registering a scheduler is achieved by using the `cfflow.registerScheduler()` method:

```cfc
var myScheduler = new my.CustomScheduler();

cfflow.registerScheduler(
	    className      = "my.scheduler"
	  , implementation = myScheduler
);
```

## Executing auto actions

Your scheduler will have access to a string `workflowId`, a struct of `instanceArgs` to get the relevant workflow instance and a string `stepId`. These variables can be used to execute the automatic actions on the specified step and workflow instance.

The example below, is a Coldbox handler that a custom scheduler invokes on each scheduled iteration:


```cfc
component {

	property name="cfflow" inject="cfflow@cfflow";

	private boolean function runScheduledAutoActions( event, rc, prc, args={}, logger, progress ) {
		var wfId   = args.workflowId   ?: "";
		var iArgs  = args.instanceArgs ?: {};
		var stepId = args.stepId       ?: "";

		// does the instance stil exist?
		if ( !cfflow.instanceExists( workflowId=wfId, instanceArgs=iArgs ) ) {
			// return true, we should not try to run again
			return true;
		}

		// execute the auto actions
		try {
			// if no actions are executed, we will return false
			// and this task will be rescheduled if need be
			return cfflow.doAutoActions(
				  workflowId   = wfId
				, instanceArgs = iArgs
				, stepId       = stepId
			);

		} catch( "cfflow.step.not.active" e ) {
			// if the step is no longer active, we should return true to prevent rescheduling
			return true;
		}
	}
}
```

## Scheduler example using Preside

The corresponding scheduler to the execution handler above, is as follows:

```cfc
/**
 * @presideService true
 * @singleton      true
 */
component implements="cfflow.models.implementation.interfaces.IWorkflowScheduler" {

// CONSTRUCTOR
	public any function init() {
		return this;
	}

// PUBLIC API METHODS
	public void function scheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
		, required array  timers
	){
		var sched = _calculateSchedule( arguments.timers );

		// use preside ad-hoc task manager for the scheduler
		$createTask(
			  event             = "cfFlowHelpers.runScheduledAutoActions"
			, args              = { workflowId=arguments.workflowId, stepId=arguments.stepId, instanceArgs=arguments.instanceArgs }
			, runNow            = false
			, runIn             = sched.runIn
			, retryInterval     = sched.retries
			, discardOnComplete = true
		);
	}

	public void function unScheduleAutoActions(
		  required string workflowId
		, required struct instanceArgs
		, required string stepId
	){
		// not yet implemented and not necessary
		// we can stop the schedule when the step
		// becomes unavailable
	}

// PRIVATE HELPERS
	private struct function _calculateSchedule( required array timers ) {
		var sched = {
			  runIn = CreateTimeSpan( 0, 0, 0, arguments.timers[ 1 ].getInterval() )
			, retries = []
		};

		var start = ( arguments.timers[ 1 ].getCount() == 1 ) ? 2 : 1;
		for( var i=start; i<=ArrayLen( arguments.timers ); i++ ) {
			var retry = {
				  tries    = arguments.timers[ i ].getCount()
				, interval = arguments.timers[ i ].getInterval()
			};
			if ( i==1 ) {
				retry.tries--;
			}

			ArrayAppend( sched.retries, retry );
		}

		return sched;
	}
}
```
