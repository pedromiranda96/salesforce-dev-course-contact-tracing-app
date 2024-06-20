public with sharing class CTLocationTriggerHandler {
    public static void beforeInsertHandler(List<Location__c> records) {
        for(Location__c location : records) {
            location.Status__c = 'Green';
        }
    }

    public static void beforeUpdateHandler(List<Location__c> records, Map<Id, Location__c> oldRecords) {
        for(Location__c location : records) {
            Location__c old = oldRecords.get(location.Id);

            if(location.Status__c != old.Status__c) {
                location.Status_Update_Date__c = Date.today();
            }
        }
    }
}