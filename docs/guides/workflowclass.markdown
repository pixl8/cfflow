---
layout: page
title: Creating a workflow class
nav_order: 2
parent: Guides
---

# Creating a workflow class

All [worklow definitions](workflowschema.html) must specify a workflow _class_ to use. For example, the workflow schema below specifies a class of `pixl8.webflow`:

```yaml
version: 1.0.0
workflow:
  id: my-workflow
  class: pixl8.webflow

# ...
```

A **workflow class** tells the engine which [storage implementation](statestorage.html) to use for storing workflow state and which [scheduler implementation](scheduler.html) to use for scheduling automatic actions using _timers_.

This class **must** be registered with the **CfFlow** engine in order to be usable. No pre-built classes or storage/scheduler implementations exist in the core engine as of the current version so you must implement your own and register them with the engine.

Registering a _class_ is as follows:

```cfc
// registering the storage class + scheduler
cfflow.registerStorageClass( "my.db.storage", myDbStorageImpl );
cfflow.registerScheduler( "my.cf.scheduler", mySchedulerImpl );

// registering the class
cfflow.registerWorkflowClass(
	  className    = "my.cfflow.class"
	, storageClass = "my.db.storage"
	, scheduler    = "my.cf.scheduler"
);
```
