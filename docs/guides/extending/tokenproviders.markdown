---
layout: page
title: Creating a custom token provider
nav_order: 8
parent: Extending CfFlow
grand_parent: Guides
---

# Creating a custom token provider

Token providers allow you to use dynamic token replacement in condition and function arguments. For example, the following condition definition allows checking against the dynamic state variable named `email_address`:

```yml
condition:
  ref: string.EndsWith
  args:
    pattern: @gmail.com
    value: $email_address
```

You can extend CfFlow to provide your own tokens that will be replaced dynamically with your own logic.

## The IWorkflowArgSubstitutionProvider interface

To create your own token provider, create a CFC that implements the following interface:

```cfc
interface {

  public struct function getTokens( 
      required array            requiredTokens
    , required WorkflowInstance wfInstance 
  );

}
```

For example:

```cfc
component {

  public struct function getTokens( 
      required array            requiredTokens
    , required WorkflowInstance wfInstance
  ) {
    var tokens = {};

    if ( ArrayFindNoCase( requiredTokens, "$my.custom.token" ) ) {
      tokens[ "$my.custom.token" ] = "a hardcoded example";
    }

    return tokens;
  }

}
```

## Register your token provider with CfFlow

Create an instance of your component, and register it with the core engine:

```
var myTokenProvider = new myTokenProvider();

cfflow.registerTokenProvider( myTokenProvider );
```

That's it!