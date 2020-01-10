---
layout: page
title: Creating a custom function
nav_order: 6
parent: Extending CfFlow
grand_parent: Guides
---

# Creating a custom function

## The IWorkflowFunction interface

Custom functions are creating by defining a CFC that implements the `cfflow.models.implementation.interfaces.IWorkflowFunction` interface. The interface definition is as follows:

```cfc
interface {

    public void function do( 
          required WorkflowInstance wfInstance
        , required struct           args 
    );

}
```

## Registering a function

You must register your function with the cfflow engine using the `cfflow.registerFunction()` method:

```cfc
var myFunction = new my.CustomFunction();

cfflow.registerFunction(
      id             = "my.custom.function"
    , implementation = myFunction
);
```

## Using the function

Once a function is registered, you can use it in your workflow definition. Any args defined in your definition will be passed through to the function `evaluate()` method:

```yaml
action:
  id: next
  functions:
    pre:
      ref: my.custom.function
      args:
        arg1: $variable_from_state
        arg2: $variable_from_state2
  transitions:
  # ...
```

## A Preside/Coldbox Example

The following example is for a Preside application. The CFC below resides at `/application/services/SendEmailCfFlowFunction.cfc` so is auto discovered by Wirebox:

```cfc
/**
 * A CfFlow function to send an email using the Preside
 * email templating system.
 *
 * @singleton
 * @presideService
 */
component implements="cfflow.models.implementation.interfaces.IWorkflowFunction" {

    public any function init() {
        return this;
    }

    public void function do( 
        required WorkflowInstance wfInstance
      , required struct           args 
    ){
        var emailArgs = {
              template  = arguments.args.template  ?: ""
            , recipient = arguments.args.recipient ?: ""
            , args      = arguments.args.args      ?: {}
        };

        // get the current state of the workflow instance and make it available to the email template
        StructAppend( emailArgs.args, arguments.wfInstance.getState() );

        $sendEmail( argumentCollection=emailArgs );
    }

}
```

We could then register this function in a handler, for example:

```cfc
component {
    property name="cfflow" inject="cfflow@cfflow";
    property name="sendEmailCfFlowFunction" inject="SendEmailCfFlowFunction";

    function onApplicationStart() {
        cfflow.registerFunction( 
              id             = "preside.SendEmail"
            , implementation = sendEmailCfFlowFunction
        );
    }
}
```

Finally, we could then use it in our workflow definitions:

```yaml
action:
  id: next
  functions:
    post:
      ref: preside.SendEmail
      args:
        template: eventBookingConfirmation
        recipient: $userid
        args:
          includeFancyFooter: true
  transitions:
  # ...
```