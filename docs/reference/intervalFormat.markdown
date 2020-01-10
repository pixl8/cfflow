---
layout: page
title: Interval format
nav_order: 4
parent: Reference
---

# Interval format

CfFlow makes use of a custom interval format to easily define time intervals. Format examples:

* `3d` = 3 days
* `1y` = 1 year
* `-2m` = minus two minutes (could be used as a time offset in a date condition)

The format is always `{numeric measure}{time unit}`. Allowable time units are:

| Unit | Description |
|-------|-------|
| `s` | seconds |
| `m` | minutes |
| `h` | hours |
| `d` | days |
| `w` | weeks |
| `y` | years |