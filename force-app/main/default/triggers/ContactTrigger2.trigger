trigger ContactTrigger2 on Contact (before update, after update) {
    if (trigger.isBefore && trigger.isUpdate) {
        for (Contact con : trigger.new) {
            if (con.Phone != trigger.oldMap.get(con.Id).Phone) {
                con.MobilePhone = con.Phone;
            }
			if (con.FirstName != trigger.oldMap.get(con.Id).FirstName) {
                if (con.FirstName.startsWith('X')) {
                    con.addError('FirstName Cannot Start with X');
                }
            }
        }
    }
    
    
    if (trigger.isAfter && trigger.isUpdate) {
        List<Account> accsToUpdate = new List<Account>();
        for (Contact con : trigger.new) {
            if (con.Phone != trigger.oldMap.get(con.Id).Phone) {
                Account acc = new Account(Id = con.AccountId);
                acc.Phone = con.Phone;
                accsToUpdate.add(acc);
            }
        }
        
        if (!accsToUpdate.isEmpty()) {
            upsert accsToUpdate;
        }
    }
}