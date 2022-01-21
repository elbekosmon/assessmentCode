public class PaymentTriggerHelper {
    //Insert--Records
    public void afterInsert(List<Payment__c> newRecordList){
        Set<id> contactIds = new Set<id>();
        Set<id> projectIds = new Set<id>();
        for(Payment__c paymentRecords : newRecordList){
            if(paymentRecords.Contact__c != null){
                contactIds.add(paymentRecords.Contact__c);
            }
            if(paymentRecords.Project__c != null){
                projectIds.add(paymentRecords.Project__c);
            }
        }
        updateContactRecords(contactIds);
        updateProjectRecords(projectIds);
    }
    //Update Records
    public void afterUpdate(List<Payment__c> oldRecordList, Map<Id,Payment__c> oldRecordMap, List<Payment__c> newRecordList, Map<Id,Payment__c> newRecordMap){
        Set<id> contactIds = new Set<id>();
        Set<id> projectIds = new Set<id>();
        for(Payment__c paymentRecords : newRecordList){
            Payment__c oldPaymentsRecords = oldRecordMap.get(paymentRecords.id);
            if(paymentRecords.Contact__c != oldPaymentsRecords.Contact__c || paymentRecords.Amount__c != oldPaymentsRecords.Amount__c){
                IF(paymentRecords.Contact__c != null){
                    contactIds.add(paymentRecords.Contact__c);
                }
                IF(oldPaymentsRecords.Contact__c != null){
                    contactIds.add(oldPaymentsRecords.Contact__c);
                }
            }
            if(paymentRecords.Project__c != oldPaymentsRecords.Project__c || paymentRecords.Amount__c != oldPaymentsRecords.Amount__c){
                IF(paymentRecords.Project__c != null){
                    projectIds.add(paymentRecords.Project__c);
                }
                IF(oldPaymentsRecords.Project__c != null){
                    projectIds.add(oldPaymentsRecords.Project__c);
                }
            }
        }
        updateContactRecords(contactIds);
        updateProjectRecords(projectIds);
    } 
    //Delete Records
    public void afterDelete(List<Payment__c> oldRecordList, Map<Id,Payment__c> oldRecordMap){
        Set<id> contactIds = new Set<id>();
        Set<id> projectIds = new Set<id>();
        for(Payment__c paymentRecords : oldRecordList){
            if(paymentRecords.Contact__c != null){
                contactIds.add(paymentRecords.Contact__c);
            }
            if(paymentRecords.Project__c != null){
                projectIds.add(paymentRecords.Project__c);
            }
        }
        updateContactRecords(contactIds);
        updateProjectRecords(projectIds);
    }
    //For update Contact's Fields   Total amount of Payments most Recent Payment
    // -----------------------------------------
    public void updateContactRecords(set<id> contactIds ){
        List <Contact> contactListToUpdate = new List <Contact> ();
        List <AggregateResult> agrList = new List <AggregateResult>();
        agrList = [Select Sum(Amount__c)sumAmount,MAX(Payment_Date__c)mostRecentPayment,
                   Contact__c From Payment__c Where Contact__c IN:contactIds
                   Group By Contact__c];
        if(agrList.size() > 0){
            for(AggregateResult agr :agrList){
                Decimal sum = (Decimal)agr.get('sumAmount');
                Date mostRecentPayment = (Date)agr.get('mostRecentPayment');
                System.debug('Result of aggrgate query:' + sum);
                Id accId  = (Id)agr.get('Contact__c');
                Contact conobj = new Contact();
                conobj.id =accId;
                conobj.TotalAmountOfPay__c = sum;
                conobj.RecentDateOfPayment__c	= mostRecentPayment;
                contactListToUpdate.add(conobj);
                
            }
        }
        if(contactListToUpdate.size()>0){
            Update contactListToUpdate;    
        } 
    }
    //For update project's Field   Total amount of Payments
    // -----------------------------------------
    public void updateProjectRecords(set<id> projectIds ){
        List <Project__c> projectListToUpdate = new List <Project__c> ();
        List <AggregateResult> agrList = new List <AggregateResult>();
        agrList = [Select Sum(Amount__c)sumAmount,
                   Project__c From Payment__c Where Project__c IN:projectIds
                   Group By Project__c];
        if(agrList.size() > 0){
            for(AggregateResult agr :agrList){
                Decimal sum = (Decimal)agr.get('sumAmount');
                System.debug('Result of aggrgate query:' + sum);
                Id accId  = (Id)agr.get('Project__c');
                Project__c proobj = new Project__c();
                proobj.id =accId;
                proobj.Total_Amount_Of_Payment__c = sum;
                
                projectListToUpdate.add(proobj);
                
            }
        }
        if(projectListToUpdate.size()>0){
            Update projectListToUpdate;    
        } 
    }
}