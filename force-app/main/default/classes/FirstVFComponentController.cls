public class FirstVFComponentController {
    public Account acc {get;set;}
    public String accId {
        get;
        set{
            accId = value;
            System.debug('accIdd '+accId);
            acc = [SELECT Name, OwnerId, Owner.Name, Industry, Phone FROM Account WHERE Id = :accId];
        }
    }
    
    public FirstVFComponentController() {
        System.debug('accIdd '+accId);
    }
}