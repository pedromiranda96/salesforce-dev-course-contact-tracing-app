public with sharing class CTPersonTriggerHandler {
    public static void beforeInsertHandler(List<Person__c> records) {
        for(Person__c person : records) {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    public static void beforeUpdateHandler(List<Person__c> records, Map<Id, Person__c> oldRecords) {
        for(Person__c person : records) {
            Person__c old = oldRecords.get(person.Id);

            if(person.Health_Status__c != old.Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdateHandler(List<Person__c> records, Map<Id, Person__c> oldRecords) {
        Set<Id> peopleWithStatusChanges = new Set<Id>();
        Set<Id> peopleInRedStatus = new Set<Id>();

        for(Person__c person : records) {
            Person__c old = oldRecords.get(person.Id);

            if(person.Health_Status__c != old.Health_Status__c) {
                peopleWithStatusChanges.add(person.Id);

                if(person.Health_Status__c == 'Red') {
                    peopleInRedStatus.add(person.Id);
                }
            }
        }

        Set<Id> processedIds = new Set<Id>();
        Set<Id> peopleInOrangeStatus = new Set<Id>();
        Set<Id> peopleInYellowStatus = new Set<Id>();

        processedIds.addAll(peopleInRedStatus);

        peopleInOrangeStatus.addAll(CTPersonController.getCohabitants(peopleInRedStatus, processedIds));

        Set<Id> primaryContactIds = CTPersonController.getPrimaryContacts(peopleInRedStatus, processedIds);
        peopleInOrangeStatus.addAll(primaryContactIds);

        peopleInYellowStatus.addAll(CTPersonController.getNeighbours(peopleInRedStatus, processedIds));
        
        peopleInYellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContactIds, processedIds));

        List<Person__c> peopleToUpdate = new List<Person__c>();

        for(Id personId : peopleInOrangeStatus) {
            peopleToUpdate.add(new Person__c(Id = personId, Health_Status__c = 'Orange'));
        }

        for(Id personId : peopleInYellowStatus) {
            peopleToUpdate.add(new Person__c(Id = personId, Health_Status__c = 'Yellow'));
        }

        if(peopleToUpdate != null && peopleToUpdate.size() > 0) {
            update peopleToUpdate;
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(peopleWithStatusChanges);
        if(locationTraces != null && locationTraces.size() > 0) {
            Set<Id> locationIds = new Set<Id>();

            for(Location_Tracing__c trace : locationTraces) {
                locationIds.add(trace.Location__c);
            }

            CTLocationController.updateRedScore(locationIds);
        }

    }
}