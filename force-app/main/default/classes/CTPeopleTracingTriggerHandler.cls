public with sharing class CTPeopleTracingTriggerHandler {
    public static void beforeInsertHandler(List<People_Tracing__c> records) {
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(records);

        for(People_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found');
        }
    }
}