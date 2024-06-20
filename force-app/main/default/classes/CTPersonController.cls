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

    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        for(AggregateResult result : [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c]) {
            healthStatusCountMap.put(
                String.valueOf(result.get('Health_Status__c')),
                Integer.valueOf(result.get('total'))
            );
        }

        return healthStatusCountMap;
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

    /**
     * Gets the IDs of the cohabitants of a group of people
     */

     public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> processedIds) {
        List<String> healthStatuses = new List<String>{
            'Green',
            'Yellow'
        };

        List<People_Tracing__c> traces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :personIds OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Cohabitant'
                AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
        ];

        Set<Id> cohabitantIds = new Set<Id>();

        for(People_Tracing__c trace : traces) {
            if(!processedIds.contains(trace.Person_1__c)) {
                cohabitantIds.add(trace.Person_1__c);
                processedIds.add(trace.Person_1__c);
            }

            if(!processedIds.contains(trace.Person_2__c)) {
                cohabitantIds.add(trace.Person_2__c);
                processedIds.add(trace.Person_2__c);
            }
        }

        return cohabitantIds;
     }

     /**
      * Gets the IDs of the neighbours of a group of people
      */
 
      public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> processedIds) {
         List<People_Tracing__c> traces = [
             SELECT Id, Person_1__c, Person_2__c
             FROM People_Tracing__c
             WHERE
                 (Person_1__c IN :personIds OR Person_2__c IN :personIds)
                 AND Contact_Type__c = 'Neighbour'
                 AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
         ];
 
         Set<Id> neighbourIds = new Set<Id>();
 
         for(People_Tracing__c trace : traces) {
            if(!processedIds.contains(trace.Person_1__c)) {
                neighbourIds.add(trace.Person_1__c);
                processedIds.add(trace.Person_1__c);
            }

            if(!processedIds.contains(trace.Person_2__c)) {
                neighbourIds.add(trace.Person_2__c);
                processedIds.add(trace.Person_2__c);
            }
         }
 
         return neighbourIds;
      }

      /**
       * Gets the IDs of the primary contacts of a group of people
       */
  
       public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> processedIds) {
            List<String> healthStatuses = new List<String>{
                'Green',
                'Yellow'
            };

          List<People_Tracing__c> traces = [
              SELECT Id, Person_1__c, Person_2__c
              FROM People_Tracing__c
              WHERE
                  (Person_1__c IN :personIds OR Person_2__c IN :personIds)
                  AND Contact_Type__c = 'Other'
                  AND Contact_Date__c = LAST_N_DAYS:10
                  AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
          ];
  
          Set<Id> primaryContactIds = new Set<Id>();
  
          for(People_Tracing__c trace : traces) {
            if(!processedIds.contains(trace.Person_1__c)) {
                primaryContactIds.add(trace.Person_1__c);
                processedIds.add(trace.Person_1__c);
            }

            if(!processedIds.contains(trace.Person_2__c)) {
                primaryContactIds.add(trace.Person_2__c);
                processedIds.add(trace.Person_2__c);
            }
          }
  
          return primaryContactIds;
       }

       /**
        * Gets the IDs of the secondary contacts of a group of people, based on their primary contacts
        */
   
        public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> processedIds) {
             List<String> healthStatuses = new List<String>{
                 'Green',
                 'Yellow'
             };
 
           List<People_Tracing__c> traces = [
               SELECT Id, Person_1__c, Person_2__c
               FROM People_Tracing__c
               WHERE
                   (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds)
                   AND Contact_Type__c = 'Other'
                   AND Contact_Date__c = LAST_N_DAYS:10
                   AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
           ];
   
           Set<Id> secondaryContactIds = new Set<Id>();
   
           for(People_Tracing__c trace : traces) {
                if(!processedIds.contains(trace.Person_1__c)) {
                    secondaryContactIds.add(trace.Person_1__c);
                    processedIds.add(trace.Person_1__c);
                }

                if(!processedIds.contains(trace.Person_2__c)) {
                    secondaryContactIds.add(trace.Person_2__c);
                    processedIds.add(trace.Person_2__c);
                }
           }
   
           return secondaryContactIds;
        }
}