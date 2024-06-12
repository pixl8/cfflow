---
layout: page
title: Conditional result
parent: Workflow schema
grand_parent: Reference
---

# Conditional result

## Summary

```yaml
id: string
meta: object
condition: # {condition}
joins:
- # joinId
- # joinId
transitions:
- # {transition}
- # {transition}
functions:
  pre:
  - # {function}
  - # {function}
  post:
  - # {function}
  - # {function}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `id` | `true` | `string` | Identifier of the registered condition class to use  |
| `meta` | `false` | `object` | Arbitrary data to help describe your condition. Not used by the engine. |
| `joins` | `false` | `string` or `array` | An array of join IDs to execute after this result. Can also be a single step ID (string) |
| `condition` | `true` | `object` | A [condition](condition.html) object defining the condition that must be true in order for this result to be used. |
| `functions.pre` | `false` | `array` | Array of [function](function.html) objects that will be executed _before_ the transitions take place. |
| `functions.post` | `false` | `array` | Array of [function](function.html) objects that will be executed _after_ the transitions take place. |
| `transitions` | `true` | `array` | Array of [transition](transition.html) objects that define the change of step statuses that effectively allow instances to move through the flow. |


## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "conditionalResult.schema.json",
    "type": "object",
    "title": "Workflow result (conditional)",
    "required":[ "id", "condition", "transitions" ],
    "additionalProperties": false,
    "properties":{
        "id"    : { "type":"string", "description":"Unique identifier for the result within the action" },
        "meta" : { "type":"object", "description":"Abitrary metadata that you may use to describe the result."},
        "condition":{
            "type":"object",
            "description":"Condition that must evaluate to true in order for this conditional result to be chosen",
            "$ref":"condition.schema.json"
        },
        "functions":{
            "type":"object",
            "description":"Pre and post functions that execute before and after this result is executed.",
            "$ref":"functions.schema.json"
        },
        "joins":{
            "type":["array", "string"],
            "description":"Array of join IDs. These joins will be checked after all transitions are completed.",
            "items":{ "type":"string" }
        },
        "transitions":{
            "type":"array",
            "minItems":1,
            "description":"Array of step status transitions that this result actions when executed.",
            "items":{
                "type":"object",
                "$ref":"transition.schema.json"
            }
        }
    }
}
```