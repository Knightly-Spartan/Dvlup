({
    
    createItem: function(component, camping) {
        
        var action = component.get("c.saveItem");
        action.setParams({
            "item": camping
        });
    	action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var items = component.get("v.items");
            items.push(response.getReturnValue());
            component.set("v.items", items);
        }
    	});
    	$A.enqueueAction(action);
    },
    
    validateCampingForm: function(component) {
      
     	var validQuantity = true;
        var validPrice = true;

        var nameField = component.find("campname");
        var campname = nameField.get("v.value");
        
        var quantityField = component.find("quantity");
        var quantity = quantityField.get("v.value");
        
        var priceField = component.find("price");
        var price = priceField.get("v.value");
        
        if ($A.util.isEmpty(campname) || $A.util.isEmpty(quantity) || $A.util.isEmpty(price)){
            validQuantity = false;
            validPrice = false;
            nameField.set("v.errors", [{message:"Camping name, quantity or price can't be blank."}]);
        }
        else {
            nameField.set("v.errors", null);
        }
		
		return(validQuantity && validPrice);        
	}
})