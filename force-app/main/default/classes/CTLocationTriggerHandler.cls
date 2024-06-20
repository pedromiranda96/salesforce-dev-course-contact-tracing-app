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

    public static void afterUpdateHandler(List<Location__c> records, Map<Id, Location__c> oldRecords) {
        Set<Id> statusChanges = new Set<Id>();

        for(Location__c location : records) {
            Location__c old = oldRecords.get(location.Id);
            
            if(location.Status__c == 'Red' && old.Status__c != 'Red') {
                statusChanges.add(location.Id);
            }
        }

        List<Location_Tracing__c> traces = CTLocationTracingController.getLocationsByLocationIds(statusChanges);
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c trace : traces) {
            personIds.add(trace.Person__c);
        }

        List<Person__c> peopleToUpdate = new List<Person__c>();
        for(Id personId : personIds) {
            peopleToUpdate.add(new Person__c(
                Id = personId,
                Health_Status__c = 'Yellow'
            ));
        }
        
        if(peopleToUpdate.size() > 0) {
            update peopleToUpdate;
        }
    }
}