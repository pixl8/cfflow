---
layout: page
title: Extending CfFlow
nav_order: 3
parent: Guides
has_children: true
---

# Extending the engine

## Implementing storage classes and schedulers

CfFlow is a relatively low level engine and **requires** you to implement your own:

* [storage class](extending/statestorage.html) to store workflow state
* [scheduler](extending/scheduler.html) to handle delayed execution of automatic step actions

Combinations of storage classes and schedulers must then be bundled into a [Workflow class](extending/workflowclass.html) that your workflow definitions can then specify.

## Registering functions and conditions

Functions and conditions are [core concepts](concepts.html) of CfFlow. The engine comes with a set of pre-defined [functions](../reference/functions.html) and [conditions](../reference/conditions.html) but you are also able to register your own. 

See [Creating a custom function](extending/functions.html) and [Creating a custom condition](extending/conditions.html).

