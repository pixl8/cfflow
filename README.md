CfFlow
======

CfFlow is an open source workflow engine for the CFML language. It is inspired by the work and concepts of Open Symphony Workflow (OSWorkflow), an unmaintained Java workflow engine that is used in JIRA and many other java projects.

[![Build Status](https://travis-ci.org/pixl8/cfflow.svg?branch=master "Master")](https://travis-ci.org/pixl8/cfflow)

[![Latest version](https://forgebox.io/api/v1/entry/cfflow/badges/version)](https://forgebox.io/view/cfflow)


## Getting started

The following code snippets demonstrate the overall _gist_ of how the engine is designed to work. Full documentation can be found here: [https://pixl8.github.io/cfflow](https://pixl8.github.io/cfflow).

```cfc
// create a singleton instance of CfFlow i.e. only one instance for your application
application.cfflow = new cfflow.models.CfFlow();
```

```cfc
// register workflow definitions (YAML file)
application.cfflow.registerWorkflow( "/workflows/my-product-workflow.yaml" );
application.cfflow.registerWorkflow( "/workflows/my-automatic-workflow.yaml" );
```

```cfc
// get a workflow "instance"
var instance     = "";
var cfflow       = application.cfflow;
var workflowId   = "my-product-workflow";              // would be matched against YAML workflow definition
var instanceArgs = { user=userId, product=productId }; // up to you

if ( !cfflow.instanceExists( workflowId, instanceArgs ) ) {
	instance = cfflow.createInstance( workflowId, instanceArgs );
} else {
	instance = cfflow.getInstance( workflowId, instanceArgs );
}
```

```cfc
// query the workflow instance
if ( instance.isComplete() ) {
	// do logic to tidy up, or show message, etc.
}

if ( instance.isSplit() ) {
	// do special logic when more than one step is active..
}

var steps       = instance.getSteps();         // e.g. [ "step-1", "step-2", "step-3" ];
var activeStep  = instance.getActiveStep();    // when not split, e.g. "step-2"
var activeSteps = instance.getActiveSteps();   // i.e. when split, [ "step-1", "step-2" ]
var actions     = instance.getManualActions(); // e.g. [ "next", "prev", "cancel" ]
var state       = instance.getState();         // the current state of the instance, a struct of data
```

```cfc
// set state
instance.setState( completeStateOfInstance );
instance.appendState( { one="more thing" } );
```

```cfc
// process a workflow action (conditionally moves the instance through 
// the workflow steps and functions)
instance.processAction( stepId, actionId, args );
```

## Versioning

We use [SemVer](https://semver.org) for versioning. For the versions available, see the [tags on this repository](https://github.com/pixl8/cfflow/releases). Project releases can also be found and installed from [Forgebox](https://forgebox.io/view/cfflow)

## License

This project is licensed under the GPLv2 License - see the [LICENSE.txt](https://github.com/pixl8/Preside-CMS/blob/master/LICENSE.txt) file for details.

## Authors

The project is maintained by [The Pixl8 Group](https://www.pixl8.co.uk). The lead developer is [Dominic Watson](https://github.com/DominicWatson).

## Code of conduct

We are a small, friendly and professional community. For the eradication of doubt, we publish a simple [code of conduct](https://github.com/pixl8/cfflow/blob/master/CODE_OF_CONDUCT.md) and expect all contributors, users and passers-by to observe it.