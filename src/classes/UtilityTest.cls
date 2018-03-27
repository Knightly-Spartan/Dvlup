public class UtilityTest {

    public Candidate__c createCandidate(Integer i, Boolean isInsert) {
        Candidate__c can = new Candidate__c();
        can.First_Name__c = 'Test' + i;
        can.Last_Name__c = 'Test' + i;
        can.Email__c = 'Test' + i + '@test.com';
        can.Date_Of_Birth__c = System.today().addDays(-7000);
        if(isInsert) {
            insert can;
        }
        return can;        
    }

    public Contact createContact(Integer i) {
        Contact con = new Contact();
        con.FirstName = 'Test' + i;
        con.LastName = 'Test' + i;
        con.Email = 'Test' + i + '@test.com';
        return con;        
    }
}