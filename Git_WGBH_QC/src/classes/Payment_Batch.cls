global class Payment_Batch {
    Public static Boolean IsTest;
    Public static void Payment_Batch() {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' , ORDER_NUMBER__c , Sage_Response__c , REFERENCE__c , EFT_ORIGINATOR_ID__c, isCCDateExpired__c,needToRePaymentReq__c ' +
            ' FROM transaction_batch__c WHERE Giving_Id__r.StageName=\'Pledged\' AND Giving_Id__c != null AND (Status__c= \'PROCESS\' or Status__c = \'FAIL\' )  AND Transaction_Type__c = \'PAYMENT\' AND Submit_Count__c < 3';
        BatchExecPayment_Batch reassign = new BatchExecPayment_Batch (strQ);
        
        if(IsTest!=true) ID batchprocessid = Database.executeBatch(reassign,1);
    }
    
    Public static void PaymentTest(String TransactionBatchId) {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' , ORDER_NUMBER__c , Sage_Response__c , REFERENCE__c , EFT_ORIGINATOR_ID__c, isCCDateExpired__c,needToRePaymentReq__c ' +
            ' FROM transaction_batch__c WHERE Giving_Id__r.StageName=\'Pledged\' AND Giving_Id__c != null AND (Status__c= \'PROCESS\' or Status__c = \'FAIL\' )  AND Transaction_Type__c = \'PAYMENT\' AND Submit_Count__c < 3 And Id= \'' + TransactionBatchId + '\'';
                system.Debug('-----------StrQ=' + StrQ);
        BatchExecPayment_Batch reassign = new BatchExecPayment_Batch (strQ);
        
        if(IsTest!=true) ID batchprocessid = Database.executeBatch(reassign,1);
    }
    Public static void RequestPaymentExpiredDate() {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' , ORDER_NUMBER__c , Sage_Response__c , REFERENCE__c , isCCDateExpired__c,needToRePaymentReq__c ' +
            ' FROM transaction_batch__c WHERE Giving_Id__c != null AND (Status__c= \'PROCESS\' or Status__c = \'FAIL\' )  AND Transaction_Type__c = \'PAYMENT\' AND Submit_Count__c < 3 And needToRePaymentReq__c = true';

        BatchExecPayment_Batch reassign2 = new BatchExecPayment_Batch (strQ);
        
        if(IsTest!=true) ID batchprocessid = Database.executeBatch(reassign2,1);
    }
    static testMethod void  TestPayment_Batch() {

        Test.startTest();
        try {
            Payment_Batch.IsTest = true;
            Payment_Batch.RequestPaymentExpiredDate();
            Payment_Batch.Payment_Batch();
             Payment_Batch.PaymentTest('');
        }
        Catch(Exception ex) {}
        Test.StopTest();     
        
    }
}