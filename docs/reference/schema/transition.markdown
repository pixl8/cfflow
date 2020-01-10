---
layout: page
title: Transition
parent: Workflow schema
---

# Transition

## Summary

```yaml
step: string
status: enum (pending|active|skipped|complete)
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `step` | `true` | `string` | Reference to the step ID within this workflow whose status will change. |
| `status` | `true` | `enum` | New status for the step. Either: `pending`, `active`, `skipped` or `complete` |

## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "transition.schema.json",
    "type": "object",
    "title": "Workflow transition",
    "additionalProperties": false,
    "required":[ "step", "status" ],
    "description":"A transition represents the setting of a new status on a step. Combinations of transitions effectively move instances through the workflow.",
    "properties":{
        "step":{ "type":"string", "description":"The unique ID of the step within this workflow that the transition applies to." },
        "status":{
            "type":"string",
            "description":"The new status for the step. Either 'pending', 'active', 'complete' or 'skipped'.",
            "enum":["pending","active","complete","skipped"]
        }
    }
}
```