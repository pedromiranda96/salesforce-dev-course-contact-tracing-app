public with sharing class CTPersonController {
    /**
     * Generates a MD5-based hash from a mobile number to be used as a token
     * @return String
     */
    public static String getToken(String mobileNumber) {
        Blob value = Blob.valueOf(mobileNumber);
        Blob hash = Crypto.generateDigest('MD5', value);

        return EncodingUtil.base64Encode(hash);
    }

    /**
     * Get last 100 people with health status changes
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges() {
        return [
            SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
            FROM Person__c
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
    }

    /**
     * Searches for person records matching the search term
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm) {
        String searchPattern = searchTerm + '%';

        return [
            SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE
                Name LIKE :searchPattern
                OR Mobile__c LIKE :searchPattern
                OR Token__c LIKE :searchPattern 
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
    }

    /**
     * Gets a person record by ID
     * @return Person__c
     */
    public static Person__c getPersonById(String personId) {
        List<Person__c> people = [
            SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
            FROM Person__c
            WHERE Id = :personId
            LIMIT 1
        ];

        if(people == null || people.size() == 0) {
            return null;
        }

        return people[0];
    }
}