public with sharing class CTDataCleanupSchedule implements Schedulable {
    public static final String CRON = '0 0 2 * * ?';

    public void execute(SchedulableContext context) {
        CTPeopleTracingDataCleanupBatch peopleCleanupBatch = new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(peopleCleanupBatch, 2000);

        CTLocationTracingDataCleanupBatch locationCleanupBatch = new CTLocationTracingDataCleanupBatch();
        Database.executeBatch(locationCleanupBatch, 2000);
    }
}