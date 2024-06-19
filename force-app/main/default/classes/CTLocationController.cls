public with sharing class CTLocationController {
    /**
     * Get last 100 locations with health status changes
     * @return List<Location__c>
     */
    public static List<Location__c> getRecentStatusChanges() {
        return [
            SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
            FROM Location__c
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
    }

    public static Map<String, Integer> getStatusCount() {
        Map<String, Integer> statusCountMap = new Map<String, Integer>();

        for(AggregateResult result : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]) {
            statusCountMap.put(
                String.valueOf(result.get('Status__c')),
                Integer.valueOf(result.get('total'))
            );
        }

        return statusCountMap;
    }

    /**
     * Searches for person records matching the search term
     * @return List<Location__c>
     */
    public static List<Location__c> searchLocations(String searchTerm) {
        String searchPattern = searchTerm + '%';

        return [
            SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
            FROM Location__c
            WHERE
                Name LIKE :searchPattern
                OR Pincode__c LIKE :searchPattern
                OR Address__c LIKE :searchPattern
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
    }

    /**
     * Gets a location record by ID
     * @return Location__c
     */
    public static Location__c getLocationById(String locationId) {
        List<Location__c> locations = [
            SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
            FROM Location__c
            WHERE Id = :locationId
            LIMIT 1
        ];

        if(locations == null || locations.size() == 0) {
            return null;
        }

        return locations[0];
    }
}