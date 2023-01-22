({
	populateFields : function(component, event, helper) {
        var base64Context = component.get("v.pageReference").state.inContextOfRef;
        
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        component.find("accId").set("v.value", addressableContext.attributes.recordId);
    },
    
    handleSuccess : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Record Created Successfully",
            "type": "success"
        });
        toastEvent.fire();
    }
})