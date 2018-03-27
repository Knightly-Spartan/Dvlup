trigger RollUpTrigger on Contact (after insert, after update, after delete, after undelete) {
    if (trigger.isInsert && trigger.isAfter) {
        RollUpTriggerHandler.AfterInsert(trigger.new);
    } else if (trigger.isUpdate && trigger.isAfter) {
        RollUpTriggerHandler.AfterUpdate(trigger.new, trigger.oldMap);
    } else if (trigger.isDelete && trigger.isAfter) {
        RollUpTriggerHandler.AfterDelete(trigger.old);
    } else if (trigger.isUndelete && trigger.isAfter) {
        RollUpTriggerHandler.AfterUndelete(trigger.new);
    }
}