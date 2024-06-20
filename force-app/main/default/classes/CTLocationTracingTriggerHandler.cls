public with sharing class CTLocationTracingTriggerHandler {
    public static void beforeInsertHandler(List<Location_Tracing__c> records) {
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(records);

        for(Location_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found');
        }
    }
}