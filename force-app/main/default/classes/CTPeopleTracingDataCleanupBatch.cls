public with sharing class CTPeopleTracingDataCleanupBatch implements Database.Batchable<People_Tracing__c> {
    public List<People_Tracing__c> start(Database.BatchableContext context) {
        return [SELECT Id FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS:30];
    }

    public void execute(Database.BatchableContext context, List<People_Tracing__c> scope) {
        delete scope;
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Batch complete');
    }
}