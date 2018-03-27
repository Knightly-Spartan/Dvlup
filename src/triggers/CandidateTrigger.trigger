trigger CandidateTrigger on Candidate__c (before insert, before update) {
	CandidateTriggerHandler handler = new CandidateTriggerHandler();
    if (Trigger.isBefore && Trigger.isInsert) {
    	handler.beforeInsert(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        handler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
}