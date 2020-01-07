component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "Workflow Implementation Factory", function() {
			var _library = "";

			beforeEach( function(){
				_library = CreateMock( object=new cfflow.models.implementation.WorkflowImplementationFactory() );
			} );

			describe( "Workflow classes", function(){
				describe( "registerWorkflowClass()", function(){
					it( "should enable later fetching of a workflow instance built using the given implementation classes", function(){
						var className              = CreateUUId();
						var storageClassName       = CreateUUId();
						var functionExecutorName   = CreateUUId();
						var conditionEvaluatorName = CreateUUId();
						var schedulerName          = CreateUUId();
						var mockStorageClass       = new tests.resources.TestStorageClass();
						var mockFunctionExecutor   = new tests.resources.TestFunctionExecutor();
						var mockConditionEvaluator = new tests.resources.TestConditionEvaluator();
						var mockScheduler          = new tests.resources.TestScheduler();

						_library.registerStorageClass( className=storageClassName, implementation=mockStorageClass );
						_library.registerFunctionExecutor( className=functionExecutorName, implementation=mockFunctionExecutor );
						_library.registerConditionEvaluator( className=conditionEvaluatorName, implementation=mockConditionEvaluator );
						_library.registerScheduler( className=schedulerName, implementation=mockScheduler );

						_library.registerWorkflowClass(
							  className          = className
							, storageClass       = storageClassName
							, functionExecutor   = functionExecutorName
							, conditionEvaluator = conditionEvaluatorName
							, scheduler          = schedulerName
						);

						var impl = _library.getWorkflowImplementation( className );

						expect( impl.getStorageClass() ).toBe( mockStorageClass );
						expect( impl.getFunctionExecutor() ).toBe( mockFunctionExecutor );
						expect( impl.getConditionEvaluator() ).toBe( mockConditionEvaluator );
						expect( impl.getScheduler() ).toBe( mockScheduler );
					} );
				} );

				describe( "getWorkflowImplementation( className )", function(){
					it( "should throw an informative error when the workflow class does not exist", function(){
						expect( function(){
							_library.getWorkflowImplementation( className=CreateUUId() );
						} ).toThrow( "cfflow.workflow.class.not.exists" );
					} );
				} );
			} );

			describe( "Storage classes", function(){
				describe( "registerStorageClass( className, object )", function(){
					it( "it should make the give storage class available to fetch by string name at a later date", function(){
						var className = CreateUUId();
						var mockStorageClass = new tests.resources.TestStorageClass();

						_library.registerStorageClass( className=className, implementation=mockStorageClass );

						expect( _library.getStorageClass( className=className ) ).toBe( mockStorageClass );
					} );

					it( "should raise an error when attempting to set an object that does not implement the IWorkflowInstanceStorage interface", function(){
						var className = CreateUUId();
						var mockStorageClass = CreateStub();

						expect( function(){
							_library.registerStorageClass( className=className, implementation=mockStorageClass );
						} ).toThrow( "expression" );
					} );
				} );

				describe( "getStorageClass( className )", function(){
					it( "should throw an informative error when the storage class does not exist", function(){
						expect( function(){
							_library.getStorageClass( className=CreateUUId() );
						} ).toThrow( "cfflow.storage.class.not.exists" );
					} );
				} );
			} );

			describe( "Function executors", function(){
				describe( "registerFunctionExecutor( className, object )", function(){
					it( "it should make the give function executor available to fetch by string name at a later date", function(){
						var className = CreateUUId();
						var mockFunctionExecutor = new tests.resources.TestFunctionExecutor();

						_library.registerFunctionExecutor( className=className, implementation=mockFunctionExecutor );

						expect( _library.getFunctionExecutor( className=className ) ).toBe( mockFunctionExecutor );
					} );

					it( "should raise an error when attempting to set an object that does not implement the IWorkflowFunctionExecutor interface", function(){
						var className = CreateUUId();
						var mockFunctionExecutor = CreateStub();

						expect( function(){
							_library.registerFunctionExecutor( className=className, implementation=mockFunctionExecutor );
						} ).toThrow( "expression" );
					} );
				} );

				describe( "getFunctionExecutor( className )", function(){
					it( "should throw an informative error when the function executor does not exist", function(){
						expect( function(){
							_library.getFunctionExecutor( className=CreateUUId() );
						} ).toThrow( "cfflow.function.executor.not.exists" );
					} );
				} );
			} );

			describe( "Condition evaluators", function(){
				describe( "registerConditionEvaluator( className, object )", function(){
					it( "it should make the give condition evaluator available to fetch by string name at a later date", function(){
						var className              = CreateUUId();
						var mockConditionEvaluator = new tests.resources.TestConditionEvaluator();

						_library.registerConditionEvaluator( className=className, implementation=mockConditionEvaluator );

						expect( _library.getConditionEvaluator( className=className ) ).toBe( mockConditionEvaluator );
					} );

					it( "should raise an error when attempting to set an object that does not implement the IWorkflowConditionEvaluator interface", function(){
						var className = CreateUUId();
						var mockConditionEvaluator = CreateStub();

						expect( function(){
							_library.registerConditionEvaluator( className=className, implementation=mockConditionEvaluator );
						} ).toThrow( "expression" );
					} );
				} );

				describe( "getConditionEvaluator( className )", function(){
					it( "should throw an informative error when the condition evaluator does not exist", function(){
						expect( function(){
							_library.getConditionEvaluator( className=CreateUUId() );
						} ).toThrow( "cfflow.condition.evaluator.not.exists" );
					} );
				} );
			} );

			describe( "Schedulers", function(){
				describe( "registerScheduler( className, object )", function(){
					it( "it should make the give scheduler available to fetch by string name at a later date", function(){
						var className     = CreateUUId();
						var mockScheduler = new tests.resources.TestScheduler();

						_library.registerScheduler( className=className, implementation=mockScheduler );

						expect( _library.getScheduler( className=className ) ).toBe( mockScheduler );
					} );

					it( "should raise an error when attempting to set an object that does not implement the IWorkflowScheduler interface", function(){
						var className     = CreateUUId();
						var mockScheduler = CreateStub();

						expect( function(){
							_library.registerScheduler( className=className, implementation=mockScheduler );
						} ).toThrow( "expression" );
					} );
				} );

				describe( "getScheduler( className )", function(){
					it( "should throw an informative error when the scheduler does not exist", function(){
						expect( function(){
							_library.getScheduler( className=CreateUUId() );
						} ).toThrow( "cfflow.scheduler.not.exists" );
					} );
				} );
			} );

			describe( "Functions", function(){
				describe( "registerFunction( id, object )", function(){
					it( "it should make the given function available to fetch by string id at a later date", function(){
						var id = CreateUUId();
						var mockFunction = new tests.resources.TestFunction();

						_library.registerFunction( id=id, implementation=mockFunction );

						expect( _library.getFunction( id=id ) ).toBe( mockFunction );
					} );

					it( "should raise an error when attempting to set an object that does not implement the IWorkflowFunctionExecutor interface", function(){
						var id = CreateUUId();
						var mockFunction = CreateStub();

						expect( function(){
							_library.registerFunction( id=id, implementation=mockFunction );
						} ).toThrow( "expression" );
					} );
				} );

				describe( "getFunction( id )", function(){
					it( "should throw an informative error when the function does not exist", function(){
						expect( function(){
							_library.getFunction( id=CreateUUId() );
						} ).toThrow( "cfflow.function.not.exists" );
					} );
				} );
			} );
		} );
	}

}