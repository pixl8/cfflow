---
layout: page
title: Function
parent: Workflow schema
---

# Function

## Summary

```yaml
id: string
meta: object
args: object
condition: # {condition}
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|--------|
| `id` | `true` | `string` | Identifier of the registered function class to use |
| `meta` | `false` | `object` | Arbitrary data to help describe your function. Not used by the engine. |
| `args` | `false` | `object` | Arbitrary data to pass to the function class when executing |
| `condition` | `false` | `object` | [condition](condition.html) object representing the condition(s) that must be true in order for this function to be executed |

## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "function.schema.json",
    "type": "object",
    "title": "Workflow function",
    "additionalProperties": false,
    "required":["id"],
    "properties":{
        "id":{ "type":"string", "description":"ID of function that has been registered with the workflow engine." },
        "meta":{ "type":"object", "description":"Abitrary meta data that you may use to describe the function."},
        "args":{"type":"object", "description":"Abitrary object of data that will be passed to the function handler when executued (along with the instance state, etc.)" },
        "condition":{
            "type":"object",
            "description":"Optional condition object that will determine whether or not the function is executed",
            "$ref":"condition.schema.json"
        }
    }
}
```