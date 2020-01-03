component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow definition validator", function() {
			var validator = "";
			var workflow = "";

			beforeEach( body=function(){
				workflow = _getValidWorkflowDefinition();
				validator = createMock( object=new cfflow.models.definition.validation.WorkflowSchemaValidator() );
			} );

			describe( "validate( struct )", function() {
				it( "should return true for a valid workflow definition", function(){
					var result = false;
					try {
						result = validator.validate( workflow );
					} catch( any e ) {
						debug( e );
					}

					expect( result ).toBe( true );
				} );
				it( "should raise an error when there is no version info", function(){
					workflow.delete( "version" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when version info is empty", function(){
					workflow.version = "";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when version info is not equal to 1.0.0", function(){
					workflow.version = "2.0.0";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when there is no workflow entry", function(){
					workflow.delete( "workflow" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when the workflow entry is not a struct", function(){
					workflow.workflow = "test";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when the workflow entry has no id", function(){
					workflow.workflow.delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when the workflow entry has no title", function(){
					workflow.workflow.delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when the workflow entry has no class", function(){
					workflow.workflow.delete( "class" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when the workflow entry has no steps", function(){
					workflow.workflow.steps = [];
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more steps has no id", function(){
					workflow.workflow.steps[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );

					workflow.workflow.steps[1].id = "";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more steps has no title", function(){
					workflow.workflow.steps[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );

					workflow.workflow.steps[1].title = "";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more step actions has no ID", function(){
					workflow.workflow.steps[1].actions[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more step actions has no title", function(){
					workflow.workflow.steps[1].actions[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more step actions has no default result", function(){
					workflow.workflow.steps[1].actions[1].delete( "defaultResult" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when default result has no id", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when default action result has no title", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when default action result has no type", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.delete( "type" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when default action result have an invalid type", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.type = "blah";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );

				it( "should raise an error when one or more condition results has no id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional results has no title", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional results has no type", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].delete( "type" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional results have an invalid type", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].type = "blah";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when default result has no transitions", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.delete( "transitions" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result has no transitions", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].delete( "transitions" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result transitions has no step", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.transitions[1].delete( "step" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result transitions has no status", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.transitions[1].delete( "status" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result transitions has an invalid status", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.transitions[1].status = "blah";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result transitions has no step", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].transitions[1].delete( "step" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result transitions has no status", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].transitions[1].delete( "status" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result transitions has an invalid status", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].transitions[1].status = "blah";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result pre function has no id", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.pre[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result pre function has no title", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.pre[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result pre function has no handler", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.pre[1].delete( "handler" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result post function has no id", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.post[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result post function has no title", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.post[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result post function has no handler", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.post[1].delete( "handler" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result pre function has no id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].functions.pre[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result pre function has no title", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].functions.pre[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result pre function has no handler", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].functions.pre[1].delete( "handler" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result post function has no id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].functions.post[1].delete( "id" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result post function has no title", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].functions.post[1].delete( "title" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result post function has no handler", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].functions.post[1].delete( "handler" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more steps share the same id", function(){
					workflow.workflow.steps[2].id = workflow.workflow.steps[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more actions within a step share the same id", function(){
					workflow.workflow.steps[1].actions[2].id = workflow.workflow.steps[1].actions[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional action results share the same id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].id = workflow.workflow.steps[1].actions[1].conditionalResults[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional action results share the same condition", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].condition = workflow.workflow.steps[1].actions[1].conditionalResults[1].condition;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );

				it( "should raise an error when one or more default result pre functions share the same id", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.pre[2].id = workflow.workflow.steps[1].actions[1].defaultResult.functions.pre[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more default result post functions share the same id", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.functions.post[2].id = workflow.workflow.steps[1].actions[1].defaultResult.functions.post[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result pre functions share the same id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[1].functions.pre[2].id = workflow.workflow.steps[1].actions[1].conditionalResults[1].functions.pre[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more conditional result post functions share the same id", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].functions.post[2].id = workflow.workflow.steps[1].actions[1].conditionalResults[2].functions.post[1].id;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more transitions in conditional results refers to a non-existant step", function(){
					workflow.workflow.steps[1].actions[1].conditionalResults[2].transitions[1].step = "asdlkfjlaskdjf";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more transitions in the default result refers to a non-existant step", function(){
					workflow.workflow.steps[1].actions[1].defaultResult.transitions[1].step = "asdlkfjlaskdjf";
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when there are no initial actions", function(){
					workflow.workflow.delete( "initialActions" );
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
				it( "should raise an error when one or more initial actions attempts to define the isAutomatic property", function(){
					workflow.workflow.initialActions[1].isAutomatic = true;
					expect( function(){
						validator.validate( workflow );
					} ).toThrow( "preside.workflow.definition.validation.error" );
				} );
			} );

		});
	}

// PRIVATE HELPERS
	private struct function _getValidWorkflowDefinition() {
		return {
			"version":"1.0.0",
			"workflow":{
				"id":"my-workflow",
				"title":"My workflow",
				"class":"my.workflow.class",
				"initialActions":[{
					"id":"action-1",
					"title":"Action 1",
					"defaultResult":{
						"id":"result-1",
						"title":"Result 1",
						"type":"step",
						"transitions":[{
							"step":"step-1",
							"status":"active"
						}],
					}
				}],
				"steps":[{
					"id":"step-1",
					"title":"Step 1",
					"autoActionTimers":[{
						"interval":"10m",
						"count":10
					} ],
					"actions":[{
						"id":"action-1",
						"title":"Action 1",
						"condition":{
							"handler":"some.handler",
							"args":{
								"test":true,
								"this":[1,2,3,4]
							}
						},
						"isAutomatic":true,
						"defaultResult":{
							"id":"result-1",
							"title":"Result 1",
							"type":"step",
							"transitions":[{
								"step":"step-1",
								"status":"complete"
							},{
								"step":"step-2",
								"status":"active"
							}],
							"functions":{
								"pre":[{
									"id":"function.id",
									"title":"Function title",
									"handler":"function.handler",
									"args":{
										"anything":"goes",
										"here":true
									},
									"condition":{
										"handler":"function.condition",
										"args":{
											"test":false,
											"thisIsInteresting":[1,2,3,4]
										}
									}
								},{
									"id":"function.id.2",
									"title":"Function title",
									"handler":"function.handler.2",
									"condition":{
										"handler":"function.condition"
									}
								}],
								"post":[{
									"id":"function.id",
									"title":"Function title",
									"handler":"function.handler",
									"condition":{
										"handler":"function.condition"
									}
								},{
									"id":"function.id.2",
									"title":"Function title",
									"handler":"function.handler.2",
									"condition":{
										"handler":"function.condition",
										"args":{
											"test":false,
											"thisIsInteresting":[1,2,3,4]
										}
									}
								}]
							}
						},
						"conditionalResults":[{
							"id":"result-2",
							"title":"Result 2",
							"type":"join",
							"condition":{
								"handler":"test.condition.one",
								"args":{
									"test":false,
									"thisIsInteresting":[1,2,3,4]
								}
							},
							"transitions":[{
								"step":"step-1",
								"status":"complete"
							},{
								"step":"step-2",
								"status":"active"
							}],
							"functions":{
								"pre":[{
									"id":"function.id",
									"title":"Function title",
									"handler":"function.handler",
									"condition":{
										"handler":"function.condition",
										"args":{
											"test":false,
											"thisIsInteresting":[1,2,3,4]
										}
									}
								},{
									"id":"function.id.2",
									"title":"Function title",
									"handler":"function.handler.2",
									"condition":{
										"handler":"function.condition"
									}
								}]
							}
						},{
							"id":"result-3",
							"title":"Result 3",
							"type":"split",
							"condition":{
								"handler":"test.condition.two",
								"args":{
									"test":false,
									"thisIsInteresting":[1,2,3,4]
								}
							},
							"transitions":[{
								"step":"step-1",
								"status":"complete"
							},{
								"step":"step-2",
								"status":"active"
							}],
							"functions":{
								"post":[{
									"id":"function.id",
									"title":"Function title",
									"handler":"function.handler",
									"condition":{
										"handler":"function.condition"
									}
								},{
									"id":"function.id.2",
									"title":"Function title",
									"handler":"function.handler.2",
									"condition":{
										"handler":"function.condition"
									}
								}]
							}
						} ]
					},{
						"id":"action-2",
						"title":"Action 2",
						"defaultResult":{
							"id":"result-1",
							"title":"Result 1",
							"type":"step",
							"transitions":[{
								"step":"step-2",
								"status":"complete"
							}]
						}
					}]
				},{
					"id":"step-2",
					"title":"Step 2",
					"actions":[]
				}]
			}
		};
	}
}