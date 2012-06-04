// Insert refund item to transaction batch from refund__c object

global class Batch_Transactions {
    Public Static void Batch_Transactions() {
       String query = 'select Id,CC_Alias__c,Giving__c,Giving__r.AccountId,Refund_Amount__c,Refund_Date__c,Refund_Method__c,Refund_Status__c,Refund_Status_Formula__c,RFP_Submitted__c,Giving__r.SFDC_GIVING_NUMBER__c,CC_Alias__r.GUID__c,CC_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_Alias__r.Merchant_Account__r.Merchant_Key__c from Refund__c where TRANSACTION_BATCH__c = null And Status__c = \'PROCESS\' And Refund_Method__c= \'Charge Card\'';
       if(Test.isRunningTest()) query += '  Limit 100';
       BatchExecBatch_Transactions reassign = new BatchExecBatch_Transactions (query);
       //BatchExecRefund_Batch reassign = new BatchExecRefund_Batch ('select CC_Alias__c,Giving__c,Refund_Amount__c,Refund_Date__c,Refund_Method__c,Refund_Status__c,Refund_Status_Formula__c,RFP_Submitted__c,Giving__r.SFDC_GIVING_NUMBER__c,CC_Alias__r.GUID__c,CC_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_Alias__r.Merchant_Account__r.Merchant_Key__c from Refund__c where ID=\'a15Q0000000aizP\'');
        
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
   static testMethod void TestBatch_Transactions() {
       Test.startTest();
       Batch_Transactions.Batch_Transactions();
       Test.StopTest();  
    }    
}