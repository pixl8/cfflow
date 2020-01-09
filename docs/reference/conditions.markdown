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

### string.IsEmpty

The `string.IsEmpty` condition allows you to evaluate whether the given string `value` is empty or not.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The input value to check. Remember that you may use `$var` subsitution for state values |

#### Example
{: .no_toc }


```yaml
condition:
  id: string.IsEmpty
  args:
    value: $state_var
```

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

## Boolean conditions

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

## Numeric conditions

### number.IsEqual

The `number.IsEqual` condition compares two numbers, a `value` against a `match`. It returns `true` if the numbers are equal.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsEqual
  args:
    value: $state_variable
    match: 10
```

### number.IsLessThan

The `number.IsLessThan` condition compares two numbers, a `value` against a `match`. It returns `true` if the `value` arg is less than the `match` arg.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsLessThan
  args:
    value: $state_variable
    match: 10
```

### number.IsLessThanOrEqualTo

The `number.IsLessThanOrEqualTo` condition compares two numbers, a `value` against a `match`. It returns `true` if the `value` arg is less or equal to the `match` arg.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsLessThanOrEqualTo
  args:
    value: $state_variable
    match: 10
```

### number.IsGreaterThan

The `number.IsGreaterThan` condition compares two numbers, a `value` against a `match`. It returns `true` if the `value` arg is greater than the `match` arg.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsGreaterThan
  args:
    value: $state_variable
    match: 10
```

### number.IsGreaterThanOrEqualTo

The `number.IsGreaterThanOrEqualTo` condition compares two numbers, a `value` against a `match`. It returns `true` if the `value` arg is greater than or equal to the `match` arg.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsGreaterThanOrEqualTo
  args:
    value: $state_variable
    match: 10
```

### number.IsWithin

The `number.IsWithin` condition compares two numbers, `value` and `match` and returns true if the difference between them is less than or equal to a given `range`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` value. |
| `match` | Required. The value to compare against the `value` value. |
| `range` | Required. The acceptable difference between `match` and `value`. |

#### Example
{: .no_toc }

```yaml
condition:
  id: number.IsWithin
  args:
    value: $state_variable
    match: $another_state_variable
    range: 5
```

## Date conditions

### date.IsFuture

The `date.IsFuture` condition allows you to validate whether the given date `value` is in the future. You may optionally provide an offset to offset the current date for the calculation.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the current date. |
| `offset` | Optional. Offset the current date. Must be in CfFlow friendly date format. e.g. `-2d`, or `3w`, or `-18y` |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsFuture
  args:
    value: $event_date

condition:
  id: number.IsFuture
  args:
    value: $date_of_birth
    offset: -18y
```

### date.IsPast

The `date.IsPast` condition allows you to validate whether the given date `value` is in the past. You may optionally provide an offset to offset the current date for the calculation.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the current date. |
| `offset` | Optional. Offset the current date. Must be in CfFlow friendly date format. e.g. `-2d`, or `3w`, or `-18y` |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsPast
  args:
    value: $event_date

condition:
  id: number.IsPast
  args:
    value: $date_of_birth
    offset: -18y
```

### date.IsToday

The `date.IsToday` condition allows you to validate whether the given date `value` is today. You may optionally provide an offset to offset the current date for the calculation.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the current date. |
| `offset` | Optional. Offset the current date. Must be in CfFlow friendly date format. e.g. `-2d`, or `3w`, or `-18y` |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsToday
  args:
    value: $event_date

condition:
  id: number.IsToday
  args:
    value: $event_date
    offset: 5d
```

### date.IsBefore

The `date.IsBefore` condition allows you to validate whether the given date `value` is before the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsBefore
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsBefore
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsOnOrBefore

The `date.IsOnOrBefore` condition allows you to validate whether the given date `value` is on or before the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsOnOrBefore
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsOnOrBefore
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsAfter

The `date.IsAfter` condition allows you to validate whether the given date `value` is after the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsAfter
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsAfter
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsOnOrAfter

The `date.IsOnOrAfter` condition allows you to validate whether the given date `value` is on or after the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsOnOrAfter
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsOnOrAfter
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsEqual

The `date.IsEqual` condition allows you to validate whether the given date `value` is exactly the same as the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsEqual
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsEqual
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsSameDay

The `date.IsSameDay` condition allows you to validate whether the given date `value` is the same _day_ as the given date `match`.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsSameDay
  args:
    value: $event_date
    match: $booking_open_date

condition:
  id: number.IsSameDay
  args:
    value: $dob
    match: 2018-01-01
```

### date.IsWithin

The `date.IsWithin` condition allows you to validate whether the given date `value` and the given date `match` are within a given `range` of each other.

#### Args
{: .no_toc }

| Name | Description |
|-------|-------|
| `value` | Required. The value to compare against the `match` date. |
| `match` | Required. The value to compare against the `value` date. |
| `range` | Required. Allowable difference between the dates. Must be in CfFlow friendly date format. e.g. `2d`, or `3w`, or `18y` |

#### Examples
{: .no_toc }

```yaml
condition:
  id: number.IsWithin
  args:
    value: $event_date
    match: 2020-12-25
    range: 7d
```