---
layout: page
title: Step
parent: Workflow schema
grand_parent: Reference
---

# Step

## Summary

```yaml
id: string
meta: object
autoActionTimers:
- {timer}
- {timer}
actions:
- {action}
- {action}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `id` | `true` | `string` | Unique identifier for the step within the workflow.  |
| `meta` | `false` | `object` | Arbitrary data to help describe your step. Not used by the engine. |
| `autoActionTimers` | `false` | `array` | Array of [timer](timer.html) objects. |
| `actions` | `false` | `array` | Array of [action](action.html) objects. |

## JSON Schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "step.schema.json",
    "type": "object",
    "title": "Workflow step",
    "description": "A step within a workflow",
    "required":[ "id" ],
    "additionalProperties": false,
    "properties":{
        "id":{ "type":"string", "description":"Unique identifier for the step within this workflow" },
        "meta":{ "type":"object", "description": "Abitrary metadata that you may use to describe the step." },
        "autoActionTimers":{
            "type":"array",
            "description": "Array of timer definitions for repeatedly checking any automatically triggered actions on this step.",
            "items":{
                "type":"object",
                "$ref":"timer.schema.json"
            }
        },
        "actions":{
            "type":"array",
            "minItems": 0,
            "description":"Array of actions for the step that allow the workflow to transition from this step to one or more others. If none defined, the step is considered to be a terminating step and the workflow completed for any instances arriving here.",
            "items":{
                "type":"object",
                "$ref":"action.schema.json"
            }
        }
    }
}
```