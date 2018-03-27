public with sharing class NewCaseListController {
    public List<Case> getNewCases() {
        List<Case> results = Database.query(
            'SELECT Id, CaseNumber, Origin, Status, Account.Name ' +
            'FROM Case ' 
    );
    return results;
}

}