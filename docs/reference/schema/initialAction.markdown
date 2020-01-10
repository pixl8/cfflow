---
layout: page
title: Initial action
parent: Workflow schema
grand_parent: Reference
---

# Initial action

## Summary

```yaml
id: string
meta: object
condition: # {condition}
defaultResult: # {defaultResult}
conditionResults:
- # {conditionalResult}
- # {conditionalResult}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `id` | `true` | `string` | Unique identifier for the action within the workflow.  |
| `meta` | `false` | `object` | Arbitrary data to help describe your action. Not used by the engine. |
| `condition` | `false` | `object` | [condition](condition.html) object defining the condition which must be true in order for this action to be chosen. |
| `defaultResult` | `true` | `object` | [defaultResult](defaultResult.html) object. |
| `conditionalResults` | `false` | `array` | Array of [conditionResult](conditionResult.html) objects. |

## JSON Schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "webflow.init.schema.json",
    "type": "object",
    "title":"Webflow initialization definition",
    "description":"The init definition describes items such as pre-conditions for the flow, initial state and handler for extracting instance arguments.",
    "properties": {
        "state":{
            "type":"object",
            "description":"Definition The starting state for an instance of the flow.",
            "properties":{
                "handler":{ "type":"string", "description":"Coldbox handler that will return instance state in a struct." },
                "args":{ "type":"object", "description":"Hardcoded properties that will be returned as instance args" },
                "configform":{ "type":"string", "description":"Preside form ID that will be used to configure initial state for an instance of this flow. (i.e. an admin user will use this form to configure a specific instance of the flow)" }
            }
        },
        "instanceargs":{
            "type":"object",
            "description":"Definition of unique set of args that will identify an instance of this flow. These can be generated from a handler or hardcoded as a set of args here.",
            "properties":{
                "handler":{ "type":"string", "description":"Coldbox handler that will return instance args in a struct. It will be passed initialState struct with any initial state." },
                "args":{ "type":"object", "description":"Hardcoded properties that will be returned as instance args" }
            }
        },
        "condition": {
            "type": "object",
            "description":"CFFlow condition that must evaluate true in order for the flow to be able to be instantiated / worked through.",
            "$ref": "webflow.condition.schema.json"
        },
    }
}

```