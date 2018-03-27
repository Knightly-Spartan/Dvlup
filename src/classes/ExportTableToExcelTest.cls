@isTest
public class ExportTableToExcelTest {
      //TestMethod: Create test data and call the controller methods
  @isTest private static void testController() {
    
    //Create Test Data
    List<Account> accountList = new List<Account>();
    accountList.add(new Account(Name='Test Account'));
    insert accountList;
    
    Opportunity opp = new Opportunity(Name='Test Deal',
                                      AccountId=accountList.get(0).Id,
                                      StageName='Prospecting',
                                      CloseDate=System.today()+30);
    insert opp;
    opp = [SELECT Id, CreatedDate FROM Opportunity WHERE Id = :opp.Id];
      
    Test.startTest();
    //Create controller instance and call methods  
    ExportTableToExcelController controller = new ExportTableToExcelController();
    controller.startDate = opp.CreatedDate.addDays(-1).date();
    controller.endDate = opp.CreatedDate.addDays(1).date();
    controller.fetchData();
    controller.exportExcelSheet();
    Test.stopTest();
  }
}