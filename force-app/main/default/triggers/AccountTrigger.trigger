trigger AccountTrigger on Account (after update) {
    if (trigger.isAfter && trigger.isUpdate) {
        AccountTriggerHandler.updateContactPhone(Trigger.new, Trigger.oldMap);
    }
}