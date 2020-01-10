---
layout: page
title: Workflow schema
nav_order: 1
parent: Reference
has_children: true
---

# Workflow schema

## Summary

```yaml
version: 1.0.0
workflow:
  id: string
  meta: object
  class: string
  initialActions:
  - # {initialaction}
  - # {initialaction}
  steps:
  - # {step}
  - # {step}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `version` | `true` | `string` | Version of the schema. Must be `1.0.0`. |
| `workflow` | `true` | `object` | Object containing workflow definition. |
| `workflow.id` | `true` | `string` | Unique identifier for the workflow. |
| `workflow.meta` | `false` | `object` | Arbitrary data to help describe your flow. Not used by the engine. |
| `workflow.class` | `true` | `string` | ID of a registered class that defines the storage interface and scheduler for the workflow. |
| `workflow.initialActions` | `true` | `array` | Array of [initialAction](schema/initialAction.html) objects. Must have one or more initial actions. |
| `workflow.steps` | `true` | `array` | Array of [step](schema/step.html) objects. Must have two or more steps. |

## JSON Schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "workflow.schema.json",
    "type": "object",
    "title":"Workflow definition",
    "description":"Container object for a complete CfFlow workflow definition",
    "required": [
        "version",
        "workflow"
    ],
    "properties": {
        "version": {
            "type": "string",
            "description": "Version number of the schema to validate against (i.e. this document)",
            "enum": [
                "1.0.0"
            ]
        },
        "workflow": {
            "type": "object",
            "title": "Workflow",
            "description": "The root object that describes the workflow",
            "required":[ "id", "class", "steps", "initialActions" ],
            "additionalProperties": false,
            "properties": {
                "id":{ "type":"string", "description": "The unique identifier for the workflow." },
                "class":{ "type":"string", "description": "The workflow class. Determines what storage class and scheduler to use." },
                "meta":{ "type":"object", "description": "Abitrary metadata that you may use to describe the workflow" },
                "initialActions":{
                    "type": "array",
                    "minItems": 1,
                    "description": "Array of initial actions for the workflow. At least one must be specified to set the first step and perform any other functions and checks.",
                    "items": {
                        "$ref": "initialAction.schema.json"
                    }
                },
                "steps": {
                    "type": "array",
                    "minItems": 2,
                    "description": "The steps of the flow. Any workflow must have at least two steps.",
                    "items": {
                        "$ref": "step.schema.json"
                    }
                }
            }
        }
    }
}
```