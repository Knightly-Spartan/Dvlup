({
	myAction : function(component, event, helper) {
		var action = component.get("c.getTasks");
        action.setCallback(this, function(data) {
        component.set("v.tasks", data.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})