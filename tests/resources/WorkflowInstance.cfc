component implements="cfflow.models.instances.IWorkflowInstance" {

	public string function getWorkflowId(){
		return CreateUUId();
	}

	public struct function getState(){
		return {};
	}
	public void function setState( required struct state ){
	}

	public string function getStatus( required string step ){
		return "pending";
	}
	public void function setStatus( required string step, required string status ){
	}

}