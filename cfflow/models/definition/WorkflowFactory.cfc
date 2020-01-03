component singleton {

	public any function getWorkflow() {
		return new spec.Workflow( argumentCollection=arguments );
	}

	public any function getCondition() {
		return new spec.WorkflowCondition( argumentCollection=arguments );
	}

}