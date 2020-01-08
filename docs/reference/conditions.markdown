---
layout: page
title: Built in conditions
nav_order: 1
parent: Reference
---

# Built in conditions
{: .no_toc }

CfFlow comes with a set of pre-built conditions that you may use in your workflow definitions. This page details the conditions available. For example, you may use the built-in `state.Exists` condition in your YAML workflow definition:

```yaml
condition:
  id: state.Exists
  args:
    key: product_id
```

# Conditions
{: .no_toc }

* TOC
{:toc}

## State conditions

### state.Exists

The `state.Exists` condition allows you to check for the existance a variable within the current state of a workflow.

#### Args
{: .no_toc }

| Name | Description |
|-------|--------|---------
| `key` | Required. The name of the variable to check the existance of. |

#### Example
{: .no_toc }


```yaml
condition:
  id: state.Exists
  args:
    key: product_id
```

## String conditions


### string.IsEqual

The `string.IsEqual` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsEqual
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsEqual
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.IsEqualNoCase

The `string.IsEqualNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsEqualNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsEqualNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.IsGreaterThan

The `string.IsGreaterThan` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsGreaterThan
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsGreaterThan
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.IsGreaterThanNoCase

The `string.IsGreaterThanNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsGreaterThanNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsGreaterThanNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.IsLessThan

The `string.IsLessThan` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsLessThan
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsLessThan
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.IsLessThanNoCase

The `string.IsLessThanNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsLessThanNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.IsLessThanNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.RegexMatch

The `string.RegexMatch` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.RegexMatch
  args:
    pattern: test
    value: $state_var

condition:
  id: string.RegexMatch
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.RegexMatchNoCase

The `string.RegexMatchNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.RegexMatchNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.RegexMatchNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.Contains

The `string.Contains` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.Contains
  args:
    pattern: test
    value: $state_var

condition:
  id: string.Contains
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.ContainsNoCase

The `string.ContainsNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.ContainsNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.ContainsNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.StartsWith

The `string.StartsWith` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.StartsWith
  args:
    pattern: test
    value: $state_var

condition:
  id: string.StartsWith
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.StartsWithNoCase

The `string.StartsWithNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.StartsWithNoCase
  args:
    pattern: test
    value: $state_var

condition:
  id: string.StartsWithNoCase
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.EndsWith

The `string.EndsWith` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.EndsWith
  args:
    pattern: test
    value: $state_var

condition:
  id: string.EndsWith
  args:
    pattern: 
    - pattern_1
    - pattern_2
    - pattern_3
    value: $state_var

```

### string.EndsWithNoCase

The `string.EndsWithNoCase` condition allows you to compare an input string against a pattern.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `pattern` | Required. The pattern to match. Can be an `array` of string patterns or a String |
| `value` | Required. The input value to match against the pattern. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.EndsWithNoCase
  args:
    pattern: test
    value: $state_var

```yaml
condition:
  id: string.EndsWithNoCase
  args:
  	pattern:  
	  - pattern_1
	  - pattern_2
	  - pattern_3
    value: $state_var

```

## Boolean

### bool.IsTrue

The `bool.IsTrue` condition allows you to evaluate whether a given value is true or not. The evaluation is a strict comparison and will only match when the value is `true` exactly.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare. |

#### Example
{: .no_toc }

```yaml
condition:
  id: bool.IsTrue
  args:
    value: $state_variable
```

### bool.IsFalse

The `bool.IsFalse` condition allows you to evaluate whether a given value is true or not. The evaluation is a strict comparison and will only return **false** when the value is `true` exactly; it will return **true** in all other circumstances.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare. |

#### Example
{: .no_toc }

```yaml
condition:
  id: bool.IsFalse
  args:
    value: $state_variable
```

### bool.IsTruthy

The `bool.IsTruthy` condition allows you to evaluate whether a given value is true or not. The comparison is a loose comparison that will treat non-zero numbers as `true` as well as the string, `yes`. 

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare. |

#### Example
{: .no_toc }

```yaml
condition:
  id: bool.IsTruthy
  args:
    value: $state_variable
```

### bool.IsFalsey

The `bool.IsFalsey` condition allows you to evaluate whether a given value is true or not. The comparison is a loose comparison that will treat non-zero numbers as `true` as well as the string, `yes`. These values will all return **false**, anything not boolean or evaluating to false will return **true**.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare. |

#### Example
{: .no_toc }

```yaml
condition:
  id: bool.IsFalsey
  args:
    value: $state_variable
```