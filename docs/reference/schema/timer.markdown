---
layout: page
title: Timer
parent: Workflow schema
grand_parent: Reference
---

# Timer

## Summary

```yaml
interval: string
count: integer
```

## Properties

| Name | Required | Type | Description |
|-------|--------|--------|
| `interval` | `true` | `string` | String interval representation, e.g. `3h` = 3 hours. See [interval format](../intervalFormat.html) for reference. |
| `count` | `true` | `integer` | Number of times to repeat this interval (repeats end when an automatic action becomes available to execute) |

## JSON schema

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "timer.schema.json",
    "type": "object",
    "title": "Workflow timer",
    "required":[ "interval" ],
    "additionalProperties": false,
    "description":"A timer is a combination of an 'interval' that defines the length of time to wait and a 'count' that describes the maximum number of times the timer will be executed.",
    "properties":{
        "interval":{ "type":"string", "description":"The interval to wait for this timer in CfFlow timer format. e.g. 1h for 1 hour, 1m for 1 minute, etc. Valid units are: s=second, m=minute, h=hour, d=day, w=week, y=year." },
        "count":{ "type":"integer", "description":"How many failed attempts to execute auto actions at this timer interval before giving up or moving on to the next interval timer configuration." }
    }
}
```