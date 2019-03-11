({
    
    // Load expenses from Salesforce
	doInit: function(component, event, helper) {

    // Create the action
    var action = component.get("c.getItems");

    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            component.set("v.items", response.getReturnValue());
        }
        else {
            console.log("Failed with state: " + state);
        }
    });

    // Send action off to be executed
    $A.enqueueAction(action);
	},
    
    clickCreateCamping: function(component, event, helper) {
        
        if(helper.validateCampingForm(component)){
	        // Create the new expense
	        var newCamping = component.get("v.newItem");
	        helper.createItem(component, newCamping);
	    }
    }
})