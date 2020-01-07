component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow", function() {
			var _workflowDef = "";
			var flowId       = CreateUUId();
			var flowTitle    = CreateUUId();
			var flowClass    = CreateUUId();

			beforeEach( body=function(){
				_workflowDef = new cfflow.models.definition.spec.Workflow(
					  id    = flowId
					, meta  = { title=flowTitle }
					, class = flowClass
				);

				_workflowDef = createMock( object=_workflowDef );
			} );

			describe( "getId()", function() {
				it( "should return the workflow id", function(){
					expect( _workflowDef.getId() ).toBe( flowId );
				} );
			} );

			describe( "getMeta()", function() {
				it( "should return the workflow meta", function(){
					expect( _workflowDef.getMeta() ).toBe( { title=flowTitle } );
				} );
			} );

			describe( "getClass()", function() {
				it( "should return the workflow class", function(){
					expect( _workflowDef.getClass() ).toBe( flowClass );
				} );
			} );

			describe( "getSteps()", function() {
				it( "should return empty array when no steps yet defined", function() {
					expect( _workflowDef.getSteps() ).toBe( [] );
				} );
			} );

			describe( "getInitialActions()", function() {
				it( "should return empty array when no initial actions yet defined", function() {
					expect( _workflowDef.getInitialActions() ).toBe( [] );
				} );
			} );

			describe( "addInitialAction()", function() {
				it( "should register and create a new action with the supplied arguments", function(){
					var newAction = _workflowDef.addInitialAction(
						  id          = "test-id"
						, meta        = { title="test-title" }
						, screen      = "test-screen"
						, condition   = _getCondition()
					);

					expect( _workflowDef.getInitialActions() ).toBe( [ newAction ] );

					expect( newAction.getId() ).toBe( "test-id" );
					expect( newAction.getMeta() ).toBe( { title="test-title" } );
					expect( newAction.getScreen() ).toBe( "test-screen" );
					expect( newAction.getCondition().getHandler() ).toBe( conditionHandler );
				} );
			} );

			describe( "addStep()", function() {
				it( "should register and create a new step with the supplied arguments", function(){
					var newStep = _workflowDef.addStep(
						  id   = "my-step"
						, meta =  { title = "My step" }
					);

					expect( _workflowDef.getSteps() ).toBe( [ newStep ] );
					expect( newStep.getId() ).toBe( "my-step" );
					expect( newStep.getMeta() ).toBe( { title="My step" } );
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the non-trivial elements of the workflow", function(){
					var steps = [];
					var stepSigs = [
						Hash( CreateUUId() ),
						Hash( CreateUUId() ),
						Hash( CreateUUId() )
					];

					for( var stepSig in stepSigs ) {
						var step = CreateStub();
						step.$( "getSignature", stepSig );
						steps.append( step );
					}
					_workflowDef.$( "getSteps", steps );

					expect( _workflowDef.getSignature() ).toBe( LCase( Hash(
						_workflowDef.getId() &
						_workflowDef.getClass() &
						stepSigs[ 1 ] &
						stepSigs[ 2 ] &
						stepSigs[ 3 ]
					) ) );
				} );
			} );
		} );

		describe( "WorkflowStep", function() {
			var _workflowStep   = "";
			var stepId          = CreateUUId();
			var stepTitle       = CreateUUId();
			var stepDescription = CreateUUId();

			beforeEach( body=function(){
				_workflowStep = CreateMock( object=new cfflow.models.definition.spec.WorkflowStep(
					  id   = stepId
					, meta = { title=stepTitle, description=stepDescription }
				) );
			} );

			describe( "getId()", function() {
				it( "should return the step id", function(){
					expect( _workflowStep.getId() ).toBe( stepId );
				} );
			} );

			describe( "getMeta()", function() {
				it( "should return the step meta", function(){
					expect( _workflowStep.getMeta() ).toBe( { title=stepTitle, description=stepDescription } );
				} );
			} );

			describe( "getActions()", function() {
				it( "should return empty array when no actions yet defined", function() {
					expect( _workflowStep.getActions() ).toBe( [] );
				} );
			} );

			describe( "addAction()", function() {
				it( "should register and create a new action with the supplied arguments", function(){
					var newAction = _workflowStep.addAction(
						  id          = "test-id"
						, meta        = { title="test-title" }
						, screen      = "test-screen"
						, condition   = _getCondition()
					);

					expect( _workflowStep.getActions() ).toBe( [ newAction ] );

					expect( newAction.getId() ).toBe( "test-id" );
					expect( newAction.getMeta() ).toBe( { title="test-title" } );
					expect( newAction.getScreen() ).toBe( "test-screen" );
					expect( newAction.getCondition().getHandler() ).toBe( conditionHandler );
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the non-trivial elements of the step", function(){
					var actions = [];
					var actionSigs = [
						Hash( CreateUUId() ),
						Hash( CreateUUId() ),
						Hash( CreateUUId() )
					];

					for( var actionSig in actionSigs ) {
						var action = CreateStub();
						action.$( "getSignature", actionSig );
						actions.append( action );
					}
					_workflowStep.$( "getActions", actions );

					expect( _workflowStep.getSignature() ).toBe( LCase( Hash(
						_workflowStep.getId() &
						actionSigs[ 1 ] &
						actionSigs[ 2 ] &
						actionSigs[ 3 ]
					) ) );
				} );
			} );

			describe( "getAutoActionTimers()", function(){
				it( "should return an empty array when none set", function(){
					expect( _workflowStep.getAutoActionTimers() ).toBe( [] );
				} );
			} );

			describe( "addAutoActionTimer()", function() {
				it( "should register and create a new action timer with the supplied arguments", function(){
					var newTimer = _workflowStep.addAutoActionTimer(
						  interval = 5000
						, count    = 10
					);

					expect( _workflowStep.getAutoActionTimers() ).toBe( [ newTimer ] );

					expect( newTimer.getInterval() ).toBe( 5000 );
					expect( newTimer.getCount() ).toBe( 10 );
				} );
			} );

			describe( "hasAutoActionTimers()", function(){
				it( "should return false when there are no timers", function(){
					expect( _workflowStep.hasAutoActionTimers() ).toBeFalse();
				} );
				it( "should return true when there are one or more timers", function(){
					var newTimer = _workflowStep.addAutoActionTimer(
						  interval = 5000
						, count    = 10
					);
					expect( _workflowStep.hasAutoActionTimers() ).toBeTrue();
				} );
			} );

			describe( "hasAutoActions()", function(){
				it( "should return false when no actions in the step are set to automatic", function(){
					_workflowStep.addAction(
						  id          = "test-id"
						, title       = "test-title"
						, condition   = _getCondition()
					);
					_workflowStep.addAction(
						  id          = "test-id-2"
						, title       = "test-title-two"
						, condition   = _getCondition()
					);

					expect( _workflowStep.hasAutoActions() ).toBeFalse();
				} );
				it( "should return true when one or more actions in the step are set to automatic", function(){
					_workflowStep.addAction(
						  id          = "test-id"
						, title       = "test-title"
						, condition   = _getCondition()
					);
					_workflowStep.addAction(
						  id          = "test-id-2"
						, title       = "test-title-two"
						, condition   = _getCondition()
						, isAutomatic = true
					);

					expect( _workflowStep.hasAutoActions() ).toBeTrue();
				} );
			} );
		} );

		describe( "WorkflowAction", function() {
			var _workflowAction  = "";
			var actionId         = CreateUUId();
			var actionTitle      = CreateUUId();

			beforeEach( body=function(){
				_workflowAction = CreateMock( object=new cfflow.models.definition.spec.WorkflowAction(
					  id   = actionId
					, meta = { title = actionTitle }
				) );
			} );

			describe( "getId()", function() {
				it( "should return the action id", function(){
					expect( _workflowAction.getId() ).toBe( actionId );
				} );
			} );

			describe( "getMeta()", function() {
				it( "should return the action meta", function(){
					expect( _workflowAction.getMeta() ).toBe( { title=actionTitle } );
				} );
			} );

			describe( "getCondition()", function(){
				it( "should return the set condition object", function(){
					_workflowAction.setCondition( _getCondition() );

					expect( _workflowAction.getCondition().getHandler() ).toBe( conditionHandler );
				} );
				it( "should return NULL when no condition set", function(){
					expect( _workflowAction.getCondition() ).toBeNull();
				} );
			} );

			describe( "hasCondition()", function(){
				it( "should return true when condition is set", function(){
					_workflowAction.setCondition( _getCondition() );

					expect( _workflowAction.hasCondition() ).toBe( true );
				} );
				it( "should return false when no condition set", function(){
					expect( _workflowAction.hasCondition() ).toBe( false );
				} );
			} );

			describe( "getConditionalResults()", function() {
				it( "should return empty array when no results yet defined", function() {
					expect( _workflowAction.getConditionalResults() ).toBe( [] );
				} );
			} );

			describe( "getDefaultResult()", function() {
				it( "should return null when no default result yet defined", function() {
					expect( _workflowAction.getDefaultResult() ).toBeNull();
				} );
			} );

			describe( "getIsManual()/getIsAutomatic()", function(){
				it( "should return true/false when isAutomatic is not set", function(){
					expect( _workflowAction.getIsManual() ).toBe( true );
					expect( _workflowAction.getIsAutomatic() ).toBe( false );
				} );
				it( "should return true/false when isAutomatic is set to false", function(){
					_workflowAction.setIsAutomatic( false );
					expect( _workflowAction.getIsManual() ).toBe( true );
					expect( _workflowAction.getIsAutomatic() ).toBe( false );
				} );
				it( "should return false/true when isAutomatic is set to true", function(){
					_workflowAction.setIsAutomatic( true );
					expect( _workflowAction.getIsManual() ).toBe( false );
					expect( _workflowAction.getIsAutomatic() ).toBe( true );
				} );
			} );

			describe( "addConditionalResult()", function() {
				it( "should register and create a new conditional result with the supplied arguments", function(){
					var newResult = _workflowAction.addConditionalResult(
						  id        = "test-id"
						, meta      = { title="test-title" }
						, type      = "join"
						, condition = _getCondition()
					);

					expect( _workflowAction.getConditionalResults() ).toBe( [ newResult ] );
					expect( newResult.getId() ).toBe( "test-id" );
					expect( newResult.getMeta() ).toBe( { title="test-title" } );
					expect( newResult.getType() ).toBe( "join" );
					expect( newResult.getIsDefault() ).toBe( false );
					expect( newResult.getCondition().getHandler() ).toBe( conditionHandler );
				} );
			} );

			describe( "setDefaultResult()", function() {
				it( "should register and create a new default result with the supplied arguments", function(){
					_workflowAction.setDefaultResult(
						  id   = "test-id"
						, meta = { title="test-title" }
						, type = "split"
					);
					newResult = _workflowAction.getDefaultResult();

					expect( newResult.getId() ).toBe( "test-id" );
					expect( newResult.getMeta() ).toBe( { title="test-title" } );
					expect( newResult.getType() ).toBe( "split" );
					expect( newResult.getIsDefault() ).toBe( true );
					expect( newResult.hasCondition() ).toBeFalse();
					expect( newResult.getCondition() ).toBeNull();
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the non-trivial elements of the action", function(){
					var results = [];
					var resultSigs = [
						Hash( CreateUUId() ),
						Hash( CreateUUId() ),
						Hash( CreateUUId() )
					];
					var defaultResult = CreateStub();
					var defaultResultSig = Hash( CreateUUId() );

					for( var resultSig in resultSigs ) {
						var result = CreateStub();
						result.$( "getSignature", resultSig );
						results.append( result );
					}
					defaultResult.$( "getSignature", defaultResultSig );
					_workflowAction.$( "getConditionalResults", results );
					_workflowAction.$( "getDefaultResult", defaultResult );

					expect( _workflowAction.getSignature() ).toBe( LCase( Hash(
						_workflowAction.getId() &
						_workflowAction.getScreen() &
						defaultResultSig &
						resultSigs[ 1 ] &
						resultSigs[ 2 ] &
						resultSigs[ 3 ]
					) ) );
				} );

				it( "should add the condition signature when a condition is set", function(){
					var results = [];
					var resultSigs = [
						Hash( CreateUUId() ),
						Hash( CreateUUId() ),
						Hash( CreateUUId() )
					];
					var defaultResult = CreateStub();
					var defaultResultSig = Hash( CreateUUId() );
					var condition = _getCondition();

					for( var resultSig in resultSigs ) {
						var result = CreateStub();
						result.$( "getSignature", resultSig );
						results.append( result );
					}
					defaultResult.$( "getSignature", defaultResultSig );
					_workflowAction.$( "getConditionalResults", results );
					_workflowAction.$( "getDefaultResult", defaultResult );
					_workflowAction.setCondition( condition );

					expect( _workflowAction.getSignature() ).toBe( LCase( Hash(
						_workflowAction.getId() &
						_workflowAction.getScreen() &
						defaultResultSig &
						condition.getSignature() &
						resultSigs[ 1 ] &
						resultSigs[ 2 ] &
						resultSigs[ 3 ]
					) ) );
				} );
			} );
		} );

		describe( "WorkflowResult", function() {
			var _workflowResult = "";
			var resultId        = CreateUUId();
			var resultTitle     = CreateUUId();
			var resultType      = "step";
			var resultIsDefault = true;

			beforeEach( body=function(){
				_workflowResult = CreateMock( object=new cfflow.models.definition.spec.WorkflowResult(
					  id        = resultId
					, meta      = { title=resultTitle }
					, type      = resultType
					, isDefault = resultIsDefault
				) );
			} );

			describe( "getId()", function() {
				it( "should return the result id", function(){
					expect( _workflowResult.getId() ).toBe( resultId );
				} );
			} );

			describe( "getMeta()", function() {
				it( "should return the result title", function(){
					expect( _workflowResult.getMeta() ).toBe( { title=resultTitle } );
				} );
			} );

			describe( "getType()", function(){
				it( "should return the result type", function(){
					expect( _workflowResult.getType() ).toBe( resultType );
				} );
			} );
			describe( "getIsDefault()", function(){
				it( "should return the result isDefault", function(){
					expect( _workflowResult.getIsDefault() ).toBe( resultIsDefault );
				} );
			} );
			describe( "getCondition()", function(){
				it( "should return the set condition object", function(){
					_workflowResult.setCondition( _getCondition() );

					expect( _workflowResult.getCondition().getHandler() ).toBe( conditionHandler );
				} );
				it( "should return NULL when no condition set", function(){
					expect( _workflowResult.getCondition() ).toBeNull();
				} );
			} );

			describe( "hasCondition()", function(){
				it( "should return true when condition is set", function(){
					_workflowResult.setCondition( _getCondition() );

					expect( _workflowResult.hasCondition() ).toBe( true );
				} );
				it( "should return false when no condition set", function(){
					expect( _workflowResult.hasCondition() ).toBe( false );
				} );
			} );
			describe( "getTransitions()", function() {
				it( "should return empty array when no transitions yet defined", function() {
					expect( _workflowResult.getTransitions() ).toBe( [] );
				} );
			} );

			describe( "getPreFunctions()", function() {
				it( "should return empty array when no functions yet defined", function() {
					expect( _workflowResult.getPreFunctions() ).toBe( [] );
				} );
			} );

			describe( "getPostFunctions()", function() {
				it( "should return empty array when no functions yet defined", function() {
					expect( _workflowResult.getPostFunctions() ).toBe( [] );
				} );
			} );

			describe( "addTransition()", function() {
				it( "should register and create a new step change with the supplied arguments", function(){
					var newTransition = _workflowResult.addTransition(
						  step   = "test-step"
						, status = "active"
					);

					expect( _workflowResult.getTransitions() ).toBe( [ newTransition ] );
					expect( newTransition.getStep() ).toBe( "test-step" );
					expect( newTransition.getStatus() ).toBe( "active" );
				} );
			} );

			describe( "addPreFunction()", function() {
				it( "should register and create a new pre function with the supplied arguments", function(){
					var newPreFunction = _workflowResult.addPreFunction(
						  id        = "test-id"
						, meta      = { title="test-title" }
						, handler   = "test-functionId"
						, condition = _getCondition()
					);

					expect( _workflowResult.getPreFunctions() ).toBe( [ newPreFunction ] );
					expect( newPreFunction.getId() ).toBe( "test-id" );
					expect( newPreFunction.getMeta() ).toBe( {title="test-title"} );
					expect( newPreFunction.getPreOrPost() ).toBe( "pre" );
					expect( newPreFunction.getCondition().getHandler() ).toBe( conditionHandler );
				} );
			} );

			describe( "addPostFunction()", function() {
				it( "should register and create a new Post function with the supplied arguments", function(){
					var newPostFunction = _workflowResult.addPostFunction(
						  id        = "test-id"
						, meta      = { title="test-title" }
						, handler   = "test-functionId"
						, condition = _getCondition()
					);

					expect( _workflowResult.getPostFunctions() ).toBe( [ newPostFunction ] );
					expect( newPostFunction.getId() ).toBe( "test-id" );
					expect( newPostFunction.getMeta() ).toBe( {title="test-title"} );
					expect( newPostFunction.getPreOrPost() ).toBe( "post" );
					expect( newPostFunction.getCondition().getHandler() ).toBe( conditionHandler );
				} );
			} );

			describe( "setType()", function(){
				it( "should raise an informative error when value is neither 'step', 'split' or 'join'", function(){
					_workflowResult.setType( "step" );
					_workflowResult.setType( "split" );
					_workflowResult.setType( "join" );

					var raised = false;
					try {
						_workflowResult.setType( "somethingelse" );
					} catch( "workflow.result.invalid.type" e ) {
						raised = true;
					}

					expect( raised ).toBeTrue();
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the non-trivial elements of the result", function(){
					var transitions = [];
					var transitionSigs = [
						Hash( CreateUUId() ),
						Hash( CreateUUId() ),
						Hash( CreateUUId() )
					];

					for( var transitionSig in transitionSigs ) {
						var transition = CreateStub();
						transition.$( "getSignature", transitionSig );
						transitions.append( transition );
					}
					_workflowResult.$( "getTransitions", transitions );

					expect( _workflowResult.getSignature() ).toBe( LCase( Hash(
						_workflowResult.getId() &
						_workflowResult.getType() &
						_workflowResult.getIsDefault() &
						_workflowResult.getCondition() &
						transitionSigs[ 1 ] &
						transitionSigs[ 2 ] &
						transitionSigs[ 3 ]
					) ) );
				} );
			} );
		} );

		describe( "WorkflowTransition", function() {
			var _transition = "";
			var stepId   = CreateUUId();
			var statusId = "skipped";

			beforeEach( body=function(){
				_transition = new cfflow.models.definition.spec.WorkflowTransition(
					  step   = stepId
					, status = statusId
				);
			} );

			describe( "getStep()", function() {
				it( "should return the step", function(){
					expect( _transition.getStep() ).toBe( stepId );
				} );
			} );

			describe( "getStatus()", function() {
				it( "should return the new status", function(){
					expect( _transition.getStatus() ).toBe( statusId );
				} );
			} );

			describe( "setStatus()", function(){
				it( "should raise an informative error when value is neither 'active', 'pending', 'complete' or 'skipped'", function(){
					_transition.setStatus( "active" );
					_transition.setStatus( "pending" );
					_transition.setStatus( "complete" );
					_transition.setStatus( "skipped" );

					var raised = false;
					try {
						_transition.setStatus( "somethingelse" );
					} catch( "workflow.stepchange.invalid.status" e ) {
						raised = true;
					}

					expect( raised ).toBeTrue();
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the step and status", function(){

					expect( _transition.getSignature() ).toBe( LCase( Hash(
						_transition.getStep() &
						_transition.getStatus()
					) ) );
				} );
			} );
		} );

		describe( "WorkflowFunction", function() {
			var _function         = "";
			var functionId        = CreateUUId();
			var functionTitle     = CreateUUId();
			var functionPreOrPost = "pre";
			var functionHandler   = CreateUUId();

			beforeEach( body=function(){
				_function = new cfflow.models.definition.spec.WorkflowFunction(
					  id        = functionId
					, meta      = { title=functionTitle }
					, preOrPost = functionPreOrPost
				);
			} );

			describe( "getId()", function(){
				it( "should return the function id", function(){
					expect( _function.getId() ).toBe( functionId );
				} );
			} );
			describe( "getMeta()", function(){
				it( "should return the function meta", function(){
					expect( _function.getMeta() ).toBe( { title=functionTitle } );
				} );
			} );
			describe( "getPreOrPost()", function(){
				it( "should return the function preOrPost", function(){
					expect( _function.getPreOrPost() ).toBe( functionPreOrPost );
				} );
			} );
			describe( "getCondition()", function(){
				it( "should return the set condition object", function(){
					_function.setCondition( _getCondition() );

					expect( _function.getCondition().getHandler() ).toBe( conditionHandler );
				} );
				it( "should return NULL when no condition set", function(){
					expect( _function.getCondition() ).toBeNull();
				} );
			} );

			describe( "hasCondition()", function(){
				it( "should return true when condition is set", function(){
					_function.setCondition( _getCondition() );

					expect( _function.hasCondition() ).toBe( true );
				} );
				it( "should return false when no condition set", function(){
					expect( _function.hasCondition() ).toBe( false );
				} );
			} );
			describe( "setPreOrPost()", function(){
				it( "should raise an informative error when value is neither 'pre' nor 'post'", function(){
					_function.setPreOrPost( "pre" );
					_function.setPreOrPost( "post" );

					var raised = false;
					try {
						_function.setPreOrPost( "somethingelse" );
					} catch( "workflow.function.invalid.preOrPost" e ) {
						raised = true;
					}

					expect( raised ).toBeTrue();
				} );
			} );

			describe( "getArgs()", function(){
				it( "should return empty struct when none set", function(){
					expect( _function.getArgs() ).toBe( {} );
				} );
				it( "should return the args that have been set", function(){
					var args = { test=CreateUUId() };
					_function.setArgs( args );
					expect( _function.getArgs() ).toBe( args );
				} );
			} );
		} );

		describe( "WorkflowCondition", function() {
			var _condition = "";
			var handler    = CreateUUId();

			beforeEach( function(){
				_condition = new cfflow.models.definition.spec.WorkflowCondition( handler=handler );
			} );

			describe( "getHandler()", function() {
				it( "should return the handler", function(){
					expect( _condition.getHandler() ).toBe( handler );
				} );
			} );

			describe( "getArgs()", function() {
				it( "should return an empty struct when args not set", function(){
					expect( _condition.getArgs() ).toBe( {} );
				} );

				it( "should return the args that have been set", function(){
					var args = { test=true, fubar=CreateUUId() };
					_condition.setArgs( args );
					expect( _condition.getArgs() ).toBe( args );
				} );
			} );

			describe( "getSignature()", function(){
				it( "should return a hash checksum of the handler and args", function(){
					expect( _condition.getSignature() ).toBe( LCase( Hash(
						_condition.getHandler() &
						SerializeJson( _condition.getArgs() )
					) ) );
				} );
			} );
		} );

		describe( "WorkflowTimer", function() {
			var _timer = "";
			var interval = 3000;
			var count    = 100;

			beforeEach( function(){
				_timer = new cfflow.models.definition.spec.WorkflowTimer(
					  interval = interval
					, count    = count
				);
			} );

			describe( "getInterval()", function(){
				it( "should return the timer interval", function(){
					expect( _timer.getInterval() ).toBe( interval );
				} );
			} );

			describe( "getCount()", function(){
				it( "should return the timer count", function(){
					expect( _timer.getCount() ).toBe( count );
				} );
			} );

		} );
	}

// helpers
	private any function _getCondition() {
		var condition = CreateMock( "cfflow.models.definition.spec.WorkflowCondition" );

		variables.conditionHandler = CreateUUId();
		variables.conditionArgs    = { test=true, another=CreateUUId() };

		condition.setHandler( conditionHandler );
		condition.setArgs( conditionArgs );

		return condition;
	}

}