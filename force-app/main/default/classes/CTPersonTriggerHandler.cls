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
}