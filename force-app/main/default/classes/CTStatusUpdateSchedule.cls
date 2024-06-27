public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON = '0 0 2 * * ?';

    public void execute(SchedulableContext context) {
        CTUpdatePersonStatusBatch peopleStatusUpdateBatch = new CTUpdatePersonStatusBatch();
        Database.executeBatch(peopleStatusUpdateBatch, 2000);
        
        CTUpdateLocationStatusBatch locationStatusUpdateBatch = new CTUpdateLocationStatusBatch();
        Database.executeBatch(locationStatusUpdateBatch, 2000);
    }
}