---
layout: page
title: Action
parent: Workflow schema
---

# Action

## Summary

```yaml
id: string
meta: object
condition: # {condition}
isAutomatic: boolean
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
| `isAutomatic` | `false` | `boolean` | Whether or not the action will be executed automatically (either immediately, or using timer definitions on the parent step.). Default is `false`. |
| `condition` | `false` | `object` | [condition](condition.html) object defining the condition which must be true in order for this action to be chosen. |
| `defaultResult` | `true` | `object` | [defaultResult](defaultResult.html) object. |
| `conditionalResults` | `false` | `array` | Array of [conditionResult](conditionResult.html) objects. |

## JSON Schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "action.schema.json",
    "type": "object",
    "title": "Workflow action",
    "required":[ "id", "defaultResult" ],
    "additionalProperties": false,
    "properties":{
        "id":{ "type":"string", "description":"Unique action identifier (within the current step)" },
        "meta":{ "type":"object", "description": "Abitrary metadata that you may use to describe the action." },
        "isAutomatic":{"type":"boolean", "description":"Whether or not execution of the action occurs using automatic triggers or must be manually triggered." },
        "condition":{
            "type":"object",
            "description":"Optional condition for the action. If specified, the action will only be executed if the condition evaluates true.",
            "$ref":"condition.schema.json"
        },
        "defaultResult":{
            "type":"object",
            "description":"The default result for this action. If no conditional results are defined or evaluate true, this result will be executed.",
            "$ref":"defaultResult.schema.json"
        },
        "conditionalResults":{
            "type":"array",
            "minItems":0,
            "description":"Array of conditional results that are only chosen if their condition evaluates true.",
            "items":{
                "type":"object",
                "$ref":"conditionalResult.schema.json"
            }
        }
    }
}
```