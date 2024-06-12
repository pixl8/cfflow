---
layout: page
title: Join
parent: Workflow schema
grand_parent: Reference
---

# Join

## Summary

```yaml
id: string
steps:
  - step1
  - step2
meta: object
defaultResult: # {defaultResult}
conditionalResults:
- # {conditionalResult}
- # {conditionalResult}

```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `id`                 | `true`  | `string` | Unique identifier for the join within the workflow.  |
| `steps`              | `true`  | `array`  | Array of step IDs that must be complete or skipped in order for this join to execute |
| `meta`               | `false` | `object` | Arbitrary data to help describe your step. Not used by the engine. |
| `defaultResult`      | `true`  | `object` | [defaultResult](defaultResult.html) object. |
| `conditionalResults` | `false` | `array`  | Array of [conditionResult](conditionResult.html) objects. |

## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "join.schema.json",
    "type": "object",
    "title": "Workflow join",
    "description": "A join within a workflow, defines steps to listen to for completion and perform the first matching action",
    "required":[ "id", "steps", "defaultResult" ],
    "additionalProperties": false,
    "properties":{
        "id":{ "type":"string", "description":"Unique identifier for the join definition within this workflow" },
        "meta":{ "type":"object", "description": "Abitrary metadata that you may use to describe the join." },
        "steps":{ "type":"array", "description": "Array of step IDs. Join results will be triggered when a step transition triggers the join and all steps are in either a skipped or complete status.", "items":{ "type":"string" } },
        "defaultResult":{
            "type":"object",
            "description":"The default result for this join. If no conditional results are defined or evaluate true, this result will be executed.",
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