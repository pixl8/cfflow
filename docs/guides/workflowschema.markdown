---
layout: page
title: Defining a workflow
nav_order: 2
parent: Guides
---

# Defining a workflow

## Register with the engine

Workflows can be defined in several ways. Our recommendation is to define them as `.yaml` files and register them with the `cfflow` engine using the following method:

```cfc
cfflow.registerWorkflow( pathToYamlFile );
```

Alternatively, you can pass a `struct` that you build in some other way (e.g. this struct could be made dynamically from entries in a database):

```cfc
var structWorkflowDefinition = myCustomService.generateWorkflowDefinition( wfid );

cfflow.registerWorkflow( structWorkflowDefinition );
```

## Schema validation

Whichever method you choose, the resultant workflow structure will be validated against our [Workflow JSON Schema](../reference/workflowschema.html).

For yaml files, we first convert the YAML file to a `struct` before converting to `json` and validating against the schema.

For workflows passed as a `struct`, we convert to `json` before validating against the schema.

## Full YAML example

```yaml
version: 1.0.0
workflow:
  id: test-workflow
  meta:
    title: Test workflow
  class: pixl8.webflow
  initialActions:
  - id: action-1
    meta:
      title: Action 1
    defaultResult:
      id: start
      meta:
        title: Start
      transitions:
      - step: step-1
        status: active
      - step: step-2
        status: active
  steps:
  - id: "step-1"
    meta:
      title: "Step 1"
      description: "Step 1 description"
    autoActionTimers:
    - interval: 10m
      count: 100
    actions:
    - id: action-1
      meta:
        title: Action 1
      condition:
        ref: action1.condition.handler
        not: true
        args:
          val1: $state_var_1
          val2: $state_var_2
        and:
        - ref: action1.condition.handler.2
          or:
          - ref: action.condition.handler.3
        or:
        - ref: action1.condition.handler.4
      isAutomatic: true
      defaultResult:
        id: result-1
        meta:
          title: Result 1
        joins: simple-join
        transitions:
        - step: step-1
          status: complete
        functions:
          pre:
          - ref: function-1
            meta:
              title: Function 1
            args:
              test: true
              cool: really
            condition:
              ref: function1.condition.handler
              args:
                test: blah
          - ref: function-2
            meta:
              title: Function 2
            condition:
              ref: function2conditionid
          post:
          - ref: function-1
            meta:
              title: Function 1
            condition:
              ref: function1.condition.handler
          - ref: function-2
            meta:
              title: Function 2
            condition:
              ref: function2conditionid
      conditionalResults:
      - id: result-2
        meta:
          title: Result 2
        condition:
          ref: result2.condition.handler
        joins: simple-join
        transitions:
        - step: step-1
          status: complete
        - step: step-2
          status: skipped
        functions:
          pre:
          - ref: function-1
            meta:
              title: Function 1
            condition:
              ref: function1.condition.handler
          - ref: function-2
            meta:
              title: Function 2
            condition:
              ref: function2conditionid
      - id: result-3
        meta:
          title: Result 3
        condition:
          ref: result3ConditionId
        joins:
        - simple-join
        transitions:
        - step: step-1
          status: complete
        - step: step-2
          status: complete
        functions:
          post:
          - ref: function-1
            meta:
              title: Function 1
            condition:
              ref: function1.condition.handler
          - ref: function-2
            meta:
              title: Function 2
            condition:
              ref: function2conditionid
    - id: action-2
      meta:
        title: Action 2
      condition:
        ref: action2.condition
      defaultResult:
        id: result-1
        meta:
          title: Result 1
        joins:
        - simple-join
        transitions:
        - step: step-1
          status: complete
        - step: step-2
          status: active
  - id: "step-2"
    meta:
      title: "Step 2"
      description: "Step 2 description"
    actions:
    - id: action-1
      meta:
        title: Action 1
      isAutomatic: false
      defaultResult:
        id: result-1
        meta:
          title: Result 1
        joins: simple-join
        transitions:
        - step: step-2
          status: complete

  - id: "step-3"
    meta:
      title: "Step 3"
      description: "Step 3 description"

  joins:
  - id: simple-join
    meta:
      anything: really
    steps:
    - "step-1"
    - "step-2"
    defaultResult:
      id: result-1
      meta:
        title: Result 1
      transitions:
      - step: step-3
        status: active
```