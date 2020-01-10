---
layout: page
title: Condition
parent: Workflow schema
grand_parent: Reference
---

# Condition

## Summary

```yaml
ref: string
meta: object
args: object
not: boolean
and:
- # {condition}
- # {condition}
or
- # {condition}
- # {condition}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `ref` | `true` | `string` | Identifier of the registered condition class to use  |
| `meta` | `false` | `object` | Arbitrary data to help describe your condition. Not used by the engine. |
| `args` | `false` | `object` | Arbitrary data to pass to the condition class when evaluating the condition |
| `not` | `false` | `boolean` | Whether or not the condition result should be inveresed. |
| `and` | `false` | `array` | Array of condition objects that must also be true. |
| `or` | `false` | `array` | Array of condition objects that may alternatively be true. |


## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "condition.schema.json",
    "type": "object",
    "title": "Workflow condition",
    "additionalProperties": false,
    "description":"A condition represents a decision and will evaluate to either true or false when executed.",
    "required":[ "id"],
    "properties":{
        "ref":{ "type":"string", "description":"Unique identifier for a condition evaluator that has been registered with the workflow engine." },
        "args":{ "type":"object","description":"Arbitrary set of arguments that will be passed to the condition handler." },
        "meta":{ "type":"object", "description": "Abitrary metadata that you may use to describe the condition." },
        "not":{ "type":"boolean", "description": "If set to true (default is false), condition must be false." },
        "and":{
            "type":"array",
            "description": "Optional array of conditions that also must evaluate true for the parent condition to be true",
            "items": {
                "type":"object",
                "$ref":"condition.schema.json"
            }
        },
        "or":{
            "type":"array",
            "description": "Optional array of conditions that alternatively can evaluate true for the parent condition to be true",
            "items": {
                "type":"object",
                "$ref":"condition.schema.json"
            }
        }
    }
}
```