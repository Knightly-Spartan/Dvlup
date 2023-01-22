({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var recordTypeId = pageRef.state.RecordTypeId;
        var base64Context = pageRef.state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var decodedContext = JSON.parse(window.atob(base64Context));
        component.set("v.accId", decodedContext.attributes.recordId);
		
        //Set default values for the new Contact        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact",
            "defaultFieldValues": {
                'RecordTypeId' : recordTypeId,
                'AccountId' : component.get("v.accId")
            }
        });
        createRecordEvent.fire();
    }
})