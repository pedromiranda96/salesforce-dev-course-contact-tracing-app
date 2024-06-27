public with sharing class CTPersonTabController {
    @AuraEnabled
    public static UserInformation getPersonDetails(String recordId) {
        UserInformation info = new UserInformation();

        Person__c person = CTPersonController.getPersonById(recordId);
        if(person == null) {
            return null;
        }

        info.name = person.Name;
        info.phone = person.Mobile__c;
        info.token = person.Token__c;
        info.status = person.Health_Status__c;
        info.statusUpdateDate = person.Status_Update_Date__c;
        info.contacts = new List<CloseContact>();

        List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(recordId);
        if(traces != null && traces.size() > 0) {
            for(People_Tracing__c trace : traces) {
                CloseContact contact = new CloseContact();
                Set<Id> uniqueIds = new Set<Id>();
                uniqueIds.add(recordId);
                
                if(!uniqueIds.contains(trace.Person_1__c)) {
                    contact.id = trace.Person_1__c;
                    contact.token = trace.Person_1__r.Token__c;
                    contact.status = trace.Person_1__r.Health_Status__c;
                    contact.contactDate = trace.Contact_Date__c;
                }
                
                if(!uniqueIds.contains(trace.Person_2__c)) {
                    contact.id = trace.Person_2__c;
                    contact.token = trace.Person_2__r.Token__c;
                    contact.status = trace.Person_2__r.Health_Status__c;
                    contact.contactDate = trace.Contact_Date__c;
                }

                info.contacts.add(contact);
            }

            info.contactsCount = info.contacts.size();
        }

        return info;
    }

    public class UserInformation {
        @AuraEnabled
        public String name;
        
        @AuraEnabled
        public String phone;
        
        @AuraEnabled
        public String token;
        
        @AuraEnabled
        public String status;
        
        @AuraEnabled
        public Date statusUpdateDate;

        @AuraEnabled
        public Integer contactsCount = 0;

        @AuraEnabled
        public List<CloseContact> contacts;
    }

    public class CloseContact {
        @AuraEnabled
        public String id;
        
        @AuraEnabled
        public String token;
        
        @AuraEnabled
        public Date contactDate;
        
        @AuraEnabled
        public String status;
    }
}