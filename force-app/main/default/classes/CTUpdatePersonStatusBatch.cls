public with sharing class CTUpdatePersonStatusBatch implements Database.Batchable<Person__c> {
    public List<Person__c> start(Database.BatchableContext context) {
        List<String> healthStatuses = new List<string> { 'Red', 'Orange', 'Yellow' };
        
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;

        return [SELECT Id, Health_Status__c, Status_Update_Date__c FROM Person__c WHERE Status_Update_Date__c = :fourteenDaysAgo AND Health_Status__c IN :healthStatuses];
    }

    public void execute(Database.BatchableContext context, List<Person__c> scope) {
        for(Person__c person : scope) {
            person.Health_Status__c = 'Green';
        }
    }

    public void finish(Database.BatchableContext context) {}
}