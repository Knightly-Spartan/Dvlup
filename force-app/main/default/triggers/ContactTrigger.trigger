trigger ContactTrigger on Contact (after insert, after update, after delete, before update) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        ContactTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isAfter && Trigger.isInsert) {
        ContactTriggerHandler.afterInsert(Trigger.new);
    } 
    else if(Trigger.isAfter && Trigger.isUpdate) {
        ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    } 
    else if(Trigger.isAfter && Trigger.isDelete) {
        ContactTriggerHandler.afterDelete(Trigger.old);
    }
    
}