public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInformation getLocationDetails(String recordId) {
        LocationInformation info = new LocationInformation();

        Location__c location = CTLocationController.getLocationById(recordId);
        if(location == null) {
            return null;
        }

        info.name = location.Name;
        info.redScore = Integer.valueOf(location.Red_Score__c);
        info.pinCode = location.Pincode__c;
        info.status = location.Status__c;
        info.statusUpdateDate = location.Status_Update_Date__c;
        info.visits = new List<Visit>();

        List<Location_Tracing__c> traces = CTLocationTracingController.getVisitors(recordId);
        if(traces != null && traces.size() > 0) {
            for(Location_Tracing__c trace : traces) {
                Visit visit = new Visit();

                visit.id = trace.Person__c;
                visit.token = trace.Person__r.Token__c;
                visit.status = trace.Person__r.Health_Status__c;
                visit.visitDate = trace.Visit_Date__c;

                info.visits.add(visit);
            }

            info.visitsCount = info.visits.size();
        }

        return info;
    }

    public class LocationInformation {
        @AuraEnabled
        public String name;
        
        @AuraEnabled
        public Integer redScore;
        
        @AuraEnabled
        public String pinCode;
        
        @AuraEnabled
        public String status;
        
        @AuraEnabled
        public Date statusUpdateDate;

        @AuraEnabled
        public Integer visitsCount = 0;

        @AuraEnabled
        public List<Visit> visits;
    }

    public class Visit {
        @AuraEnabled
        public String id;
        
        @AuraEnabled
        public String token;
        
        @AuraEnabled
        public Date visitDate;
        
        @AuraEnabled
        public String status;
    }
}