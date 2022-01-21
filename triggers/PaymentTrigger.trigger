trigger PaymentTrigger on Payment__c (after insert, after Update, after Delete) {
    PaymentTriggerHelper handler = new PaymentTriggerHelper();
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){ 
            handler.afterInsert(trigger.new);
        }else if(Trigger.isUpdate){
            handler.afterUpdate(trigger.old, trigger.oldmap, trigger.new, Trigger.newmap);
        }else if(Trigger.isDelete){
            handler.afterDelete(trigger.old, trigger.oldmap);
        }
    }
}