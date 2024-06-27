public with sharing class CTLocationTracingDataCleanupBatch implements Database.Batchable<Location_Tracing__c> {
    public List<Location_Tracing__c> start(Database.BatchableContext context) {
        return [SELECT Id FROM Location_Tracing__c WHERE Visit_Date__c < LAST_N_DAYS:30];
    }

    public void execute(Database.BatchableContext context, List<Location_Tracing__c> scope) {
        delete scope;
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Batch complete');
    }
}