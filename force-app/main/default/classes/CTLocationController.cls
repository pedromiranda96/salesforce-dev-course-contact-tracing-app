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

    /**
     * Updates the red score of a batch of locations
     */

    public static void updateRedScore(Set<Id> locationIds) {
        List<AggregateResult> results = [
            SELECT Location__c, COUNT(Id) Total FROM Location_Tracing__c
            WHERE
                Person__r.Health_Status__c = 'Red'
                AND Visit_date__c = LAST_N_DAYS:10
                AND Location__c IN :locationIds
            GROUP BY Location__c
        ];

        List<Location__c> locationsToUpdate = new List<Location__c>();

        for(AggregateResult result : results) {
            String locationId = String.valueOf(result.get('Location__c'));
            Integer redScore = Integer.valueOf(result.get('Total'));
            String status = CTLocationController.getStatusByRedScore(redScore);

            locationsToUpdate.add(new Location__c(
                Id = locationId,
                Red_Score__c = redScore,
                Status__c = status
            ));
        }

        if(locationsToUpdate.size() > 0) {
            update locationsToUpdate;
        }
    }

    public static String getStatusByRedScore(Integer redScore) {
        if(redScore == 0) return 'Green';
        if(redScore <= 5) return 'Yellow';
        if(redScore <= 10) return 'Orange';
        return 'Red';
    }
}