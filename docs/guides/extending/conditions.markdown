---
layout: page
title: Creating a custom condition
nav_order: 7
parent: Extending CfFlow
grand_parent: Guides
---

# Creating a custom condition

## The IWorkflowCondition interface

Custom conditions are creating by defining a CFC that implements the `cfflow.models.implementation.interfaces.IWorkflowCondition` interface. The interface definition is as follows:

```cfc
interface {

    public boolean function evaluate( 
        required WorkflowInstance wfInstance
      , required struct           args 
    );

}
```

## Registering a condition

You must register your condition with the cfflow engine using the `cfflow.registerCondition()` method:

```cfc
var myCondition = new my.CustomCondition();

cfflow.registerCondition(
      id             = "my.custom.condition"
    , implementation = myCondition
);
```

## Using the condition

Once a condition is registered, you can use it in your workflow definition. Any args defined in your definition will be passed through to the condition `evaluate()` method:

```yaml
condition:
  id: my.custom.condition
  args:
    arg1: $variable_from_state
    arg2: $variable_from_state2
```

## A Preside/Coldbox Example

The following example is for a Preside application. The CFC below resides at `/application/services/IsLoggedInCfFlowCondition.cfc` so is auto discovered by Wirebox:

```cfc
/**
 * A CfFlow condition to evaluate whether or not the current
 * Preside website visitor is logged in or not.
 *
 * @singleton
 * @presideService
 */
component implements="cfflow.models.implementation.interfaces.IWorkflowCondition" {

    public any function init() {
        return this;
    }

    public boolean function evaluate( 
        required WorkflowInstance wfInstance
      , required struct           args 
    ){
        // this method provided by preside super class
        return $isWebsiteUserLoggedIn();
    }

}
```

We could then register this condition in a handler, for example:

```cfc
component {
    property name="cfflow" inject="cfflow@cfflow";
    property name="isLoggedInCfFlowCondition" inject="IsLoggedInCfFlowCondition";

    function onApplicationStart() {
        cfflow.registerCondition( 
              id             = "preside.IsLoggedIn"
            , implementation = isLoggedInCfFlowCondition
        );
    }
}
```

Finally, we could then use it in our workflow definitions:

```yaml
condition:
  id: preside.IsLoggedIn
  not: true
```