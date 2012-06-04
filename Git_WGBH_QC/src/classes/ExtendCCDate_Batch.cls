global class ExtendCCDate_Batch {
    Public static Boolean IsTest;
    Public static void ExtendCCDate_Batch() {
        
        String strQ = '';        
        StrQ = 'SELECT  Id FROM transaction_batch__c Where Giving_Id__c != null AND (Status__c= \'PROCESS\' or Status__c = \'FAIL\' )  AND Transaction_Type__c = \'PAYMENT\' AND UpdateCCDate__c = false and needToRePaymentReq__c = false And isCCDateExpired__c  = true';
            
        BatchExecExtendCCDate_Batch reassign = new BatchExecExtendCCDate_Batch(strQ);

        if(IsTest!=true) ID batchprocessid = Database.executeBatch(reassign,1);
    }  
    
    static testMethod void  TestPayment_Batch() {

        Test.startTest();
        try {
            ExtendCCDate_Batch.IsTest = true;
            ExtendCCDate_Batch.ExtendCCDate_Batch();
            
        }
        Catch(Exception ex) {}
        Test.StopTest();     
        
    }
}