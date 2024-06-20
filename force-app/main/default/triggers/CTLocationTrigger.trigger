trigger CTLocationTrigger on Location__c (before insert, after insert, before update, after update) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      CTLocationTriggerHandler.beforeInsertHandler(Trigger.new);
    }

    when BEFORE_UPDATE {
      CTLocationTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
    }
  }
}