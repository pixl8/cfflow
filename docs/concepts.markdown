---
layout: page
title: Concepts
nav_order: 2
---

# Concepts and terminology overview

The concepts for **CfFlow** map to those of the OSWorfklow project. Understanding the key terms and concepts below is essential to developing your own workflows with CfFlow.

## Key terms list

* steps and statuses
* actions
* results
* conditions
* functions
* workflow instance

## Steps and statuses

Workflows are made up of **steps**. The **status** of any **workflow instance** is a _combination of the status of all the steps in the workflow_. For example, in a _split_ flow, the status of a flow could be "Preparing social media campaign, Preparing Print Copy". In CfFlow, a **step** can have one of the following statuses:

* pending
* active
* skipped
* completed 

## Actions

An **Action** triggers the transition of step statuses in a worklfow instance. For example, an action might **complete** the currently active step and set the next step to **active**. Actions are either defined on a step, or as an **initial action** on a workflow.

**Actions** must be defined to be triggered either _manually_ or _automatically_. Manual actions will require a developer to provide a mechanism for end-users to choose and submit the action, e.g. a button. Automatic actions are triggered instantly, or by timers defined in the workflow, when a step becomes active.

**Actions** can have zero or more **Conditions**. The action will only be executed or made available when the conditions evaluate to true.

### Step actions

**Steps** have zero or more **actions**. _A step with zero actions would terminate the workflow_.


### Initial actions

A workflow has _one or more_ **initial actions**. The purpose of these is to be able to define how the workflow is started and which step(s) become active when the flow starts.


## Action results

**Results** define the step transitions that occur for an action. **Actions** must always have a single default, **unconditional result**. In addition, they may also have zero or more **conditional results** that are only chosen when a defined **condition** evaluates to true.

Only one result will be chosen and acted upon.

## Functions

**Results** can have zero or more **pre/post functions**. These functions are code that runs that can effect the payload and/or state, or just perform some other action like "send email".