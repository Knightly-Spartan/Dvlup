({
    checkboxHandler: function (cmp, event, helper) {      
    var oldValue= event.getParam("oldValue");
    var newValue = event.getParam("value");
    console.log("old value: " + oldValue);
    console.log("new value: " + newValue);
    // Identify the new checkbox value
    if(oldValue.length < newValue.length){
        cmp.set("v.checkboxValue", helper.getDifference(oldValue, newValue));
    }
   }
})