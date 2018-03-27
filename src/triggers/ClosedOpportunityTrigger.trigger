trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> taskList = new List<Task>();
    
    for(Opportunity opp : Trigger.new) {
        
        if(Trigger.isInsert) {
            if(Opp.StageName == 'Closed Won') {
                taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
            }
        }
        
        if(Trigger.isUpdate) {
            if(Opp.StageName != Trigger.oldMap.get(opp.Id).StageName
            	&& Opp.StageName == 'Closed Won') {
                taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
            }
        }       
    }

    if(taskList.size()>0) {        
        insert taskList;        
    }    
}