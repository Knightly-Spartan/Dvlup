public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getTransactionTotals(Id accountId, String selectedTimeframe, Integer selectedQuantity) {
        Map<String, Decimal> result = new Map<String, Decimal>();
        Decimal totalIncome = 0;
        Decimal totalExpense = 0;
        System.debug('accountId: ' + accountId);
        System.debug('selectedTimeframe: ' + selectedTimeframe);
        System.debug('selectedQuantity: ' + selectedQuantity);

        // Separate method call to create the query for totalIncome and totalExpense
        String incomeQuery = createQuery('Income', accountId, selectedTimeframe, selectedQuantity);
        String expenseQuery = createQuery('Expense', accountId, selectedTimeframe, selectedQuantity);
        System.debug('incomeQuery: ' + incomeQuery);
        System.debug('expenseQuery: ' + expenseQuery);

        List<AggregateResult> incomeResults = Database.query(incomeQuery);
        List<AggregateResult> expenseResults = Database.query(expenseQuery);
        System.debug('incomeResults: ' + incomeResults);
        System.debug('expenseResults: ' + expenseResults);

        totalIncome = !incomeResults.isEmpty() ? (Decimal) incomeResults[0].get('totalAmount') : 0;
        totalExpense = !expenseResults.isEmpty() ? (Decimal) expenseResults[0].get('totalAmount') : 0;

        result.put('TotalIncome', totalIncome);
        result.put('TotalExpense', totalExpense);
        return result;
    }

    public static String createQuery(String type, Id accountId, String selectedTimeframe, Integer selectedQuantity) {
        String timeframeFilter;

        // Assign appropriate filter based on the selectedTimeframe
        switch on selectedTimeframe {
            when 'Days'   { timeframeFilter = 'Last_N_Days'; }
            when 'Weeks'  { timeframeFilter = 'Last_N_Weeks'; }
            when 'Months' { timeframeFilter = 'Last_N_Months'; }
            when 'Years'  { timeframeFilter = 'Last_N_Years'; }
            when else     { timeframeFilter = 'Last_N_Days'; }
        }

        // Construct the SOQL query
        String query = 'SELECT SUM(Amount__c) totalAmount FROM Transaction__c ';
        query += 'WHERE Transaction_Account__r.ParentId = \'' + accountId + '\' AND Type__c = \'' + type + '\' AND TransactionDate__c = ' + timeframeFilter + ':' + selectedQuantity;

        return query;
    }
}