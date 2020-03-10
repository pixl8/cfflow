# Changelog

## v0.6.0

* Add and document a set of built-in state functions

## v0.5.3

* Fix issue with nested structs in arg replacers being replaced by reference

## v0.5.2

* Make arg substitution recursive for nested struct args

## v0.5.1

* Fix datatype typo

## v0.5.0

* Add a flexible system for arg token substitution. Register your own substitution providers for custom token substitution

## v0.4.6

*  Fix test after private method refactor

## v0.4.5

* Make getters public so that developers can hook into advanced things if they like

## v0.4.4

* Avoid morphing configured function and condition args when substituing variables
* Tweak definitions (tidy up)

## v0.4.3

* Refactor json validator again - updating the underlying java lib

## v0.4.2

* Refactor schema validator again to be more universally usable

## v0.4.1

* Refactor json schema validator to be more useful

## v0.4.0

* Make function and condition references in the schema use 'ref' rather than 'id'.

## v0.3.1

* Add a string.IsEmpty condition to the library

## v0.3.0

* Allow fetching of step metadata when doing getSteps(), getActiveSteps() and getActiveStep()
* Allow conditions to be defined with NOT=true to use the inverse condition
* Ship a load of built-in conditions

## v0.2.1

* Refactor 'recordTransition' to be 'recordAction' and add the current state to it (more accurate and useful)

## v0.2.0

* Add recording of state transitions and completeness state to workflow state abstraction
* Substitute arg vars for function execution
* Do variable substitution for instance state and condition args
* Add concept of 'and' + 'or' into conditions so that conditions can be endlessly complicated
* Swap out condition and function implementation to one where developers must register referenced conditions and functions

## v0.1.2

* Implement all the interface implementation proxies
* Ensure workflowId is passed through to setStepStatus() when performing transitions

## v0.1.1

* Ensure workflow id is passed to instanceExists() method

## v0.1.0

* Initial release