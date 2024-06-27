public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<Location__c> {
    public List<Location__c> start(Database.BatchableContext context) {
        List<String> healthStatuses = new List<string> { 'Red', 'Orange', 'Yellow' };
        
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;

        return [SELECT Id, Status__c, Status_Update_Date__c FROM Location__c WHERE Status_Update_Date__c = :fourteenDaysAgo AND Status__c IN :healthStatuses];
    }

    public void execute(Database.BatchableContext context, List<Location__c> scope) {
        for(Location__c location : scope) {
            location.Status__c = 'Green';
        }
    }

    public void finish(Database.BatchableContext context) {}
}