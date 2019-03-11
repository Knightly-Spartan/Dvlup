({
    //method to fetch all the questions 
	doInit : function(component, event, helper) {
        helper.fetchQuestions(component);
	},
    
    //will be called when the user will change question in picklist
    changeque : function(component, event, helper) {
        helper.changeQuestion(component,event);
	},
    
    //will be called when the user will vote for any answer
    getVote : function(component, event, helper) {
        helper.increaseVote(component,event);
	}
})