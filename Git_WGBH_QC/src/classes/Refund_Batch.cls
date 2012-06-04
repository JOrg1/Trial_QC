global class Refund_Batch {
    Public static void Refund_Batch() {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' , ORDER_NUMBER__c , Sage_Response__c , REFERENCE__c , Refund__c ' +
            ' FROM transaction_batch__c WHERE Giving_Id__c != null AND Status__c= \'PROCESS\' AND Transaction_Type__c = \'REFUND\'';
        //BatchExecPayment_Batch reassign = new BatchExecPayment_Batch (strQ);
        if(Test.isRunningTest()) StrQ += ' Limit 10';
        BatchExecRefund_BATCH reassign = new BatchExecRefund_BATCH(strQ);
        
        if(!Test.IsRunningTest()) ID batchprocessid = Database.executeBatch(reassign,1);
    }
    static testMethod void TestBatchExecUpdateContactStatus() {
        Test.startTest();
            Refund_Batch();
        Test.StopTest();
        
    }     
}