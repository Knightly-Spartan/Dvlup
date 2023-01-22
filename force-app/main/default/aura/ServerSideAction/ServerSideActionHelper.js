({
	fetchRecords : function(component, event) {
        let searchKey = component.get("v.searchKey");
        
        let action = component.get("c.getExpenses");
        action.setParams({"name":searchKey});
        
        action.setCallback(this, function(response){
            console.log('Inside setCallback');
            
            let state = response.getState();
            if (state === "SUCCESS") {
                let accounts = response.getReturnValue();
                component.set("v.accounts", accounts);
            }
        });
        
        console.log('Before enqueueAction');
        $A.enqueueAction(action);
        console.log('After enqueueAction');
	}
})