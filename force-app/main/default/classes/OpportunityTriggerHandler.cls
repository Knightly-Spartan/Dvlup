public class OpportunityTriggerHandler {
    public static void filterOpportunities(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap) {
        Set<Id> accountIdSet = new Set<Id>();
        for (Opportunity opp : newOppList) {
            accountIdSet.add(opp.AccountId);
        }
    }
}