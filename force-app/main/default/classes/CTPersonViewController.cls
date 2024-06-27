public with sharing class CTPersonViewController {
    @AuraEnabled
    public static void updateHealthStatus(String recordId) {
        Person__c person = new Person__c(Id=recordId, Health_Status__c='Red');
        update person;
    }
}