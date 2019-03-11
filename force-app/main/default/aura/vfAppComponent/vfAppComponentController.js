({
	sendData : function(component, event, helper) {
        var eventForVF = $A.get("e.c:vfAppComponent");
        event.setParam("inp1": component.find('num1').getvalue(),
            		   "inp2": component.find('num2').getvalue());
	}
})