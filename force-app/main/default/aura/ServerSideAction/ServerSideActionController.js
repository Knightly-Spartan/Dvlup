({
	doInit : function(component, event, helper) {
		component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'text'}
        ]);
	},
    search :  function(component, event, helper) {
    	helper.fetchRecords(component, event);
	}
})