---
layout: page
title: Built in functions
nav_order: 3
parent: Reference
---

# Built in functions
{: .no_toc }

CfFlow comes with a small set of pre-built functions that you may use in your workflow definitions. This page details the functions available. For example, you may use the built-in `state.Append` function in your YAML workflow definition:

```yaml
defaultResult:
  functions:
    pre:
      ref: state.Append
      args:
        myvariable: someValue
```

# Functions
{: .no_toc }

* TOC
{:toc}

## State functions

### state.Append

The `state.Append` function allows you to append a struct of args to the current workflow instance's state.

#### Args
{: .no_toc }

Any args set in the args struct will be treated as the data to append to the current worklfow instance's state.

#### Example
{: .no_toc }


```yaml
defaultResult:
  functions:
    pre:
      ref: state.Append
      args:
        myvariable: someValue
        anothervariable: $some.token.replacer
```

### state.Set

The `state.Set` function allows you to explicitly set the current workflow instances state. This means that **any existing state will be overwritten with what is set here**.

#### Args
{: .no_toc }

Any args set in the args struct will be treated as the data to set to the current worklfow instance's state.

#### Example
{: .no_toc }


```yaml
defaultResult:
  functions:
    pre:
      ref: state.Set
      args:
        myvariable: someValue
        anothervariable: $some.token.replacer
```

### state.Delete

The `state.Delete` function allows you to delete specific keys from the current workflow instance's state.

#### Args
{: .no_toc }


| Name | Description |
|-------|--------|
| `keys` | Required. A single simple value with the key to delete, or an array of simple values representing the keys to delete |


#### Examples
{: .no_toc }

##### Single key
{: .no_toc }

```yaml
defaultResult:
  functions:
    pre:
      ref: state.Delete
      args:
        keys: somestatevariable
```

##### Array of keys
{: .no_toc }

```yaml
defaultResult:
  functions:
    pre:
      ref: state.Delete
      args:
        keys: 
        - somestatevariable
        - anotherstatevariable
```
