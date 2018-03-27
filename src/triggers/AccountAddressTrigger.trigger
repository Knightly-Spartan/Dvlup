trigger AccountAddressTrigger on Account (before insert, before update) {
    
    if(Trigger.isInsert && Trigger.isBefore) {
        for(Account acc : Trigger.New) {
            if(acc.Match_Billing_Address__c == True){
                acc.BillingPostalCode = acc.ShippingPostalCode;
            }
        }
    }
    else if(Trigger.isUpdate && Trigger.isBefore) {
        for(Account acc : Trigger.New) {
            if(acc.Match_Billing_Address__c != Trigger.oldMap.get(acc.Id).Match_Billing_Address__c
               && acc.Match_Billing_Address__c == True) {
            	acc.BillingPostalCode = acc.ShippingPostalCode;
            }
        }
    }
}