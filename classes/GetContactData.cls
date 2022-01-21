public class GetContactData {  
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [Select id, FirstName, LastName,RecentDateOfPayment__c,TotalAmountOfPay__c,
                              (Select id,Amount__c,Payment_Date__c from Payments__r ORDER BY Payment_Date__c ASC) from Contact where TotalAmountOfPay__c!=null];
    }
}