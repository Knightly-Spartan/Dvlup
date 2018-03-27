@isTest 
private class TestVerifyDate {
static testMethod void TestVerifyDate() {
  VerifyDate.CheckDates(System.today(),System.today().addDays(10));
   VerifyDate.CheckDates(System.today(),System.today().addDays(78));
}
}