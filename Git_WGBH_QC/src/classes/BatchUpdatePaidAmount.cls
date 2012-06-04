global class BatchUpdatePaidAmount{
    Static string strQuery = 'Select Id, payment_amount__c, paid_amount__c, Recurring_Donation_Opportunity__c From Opportunity Where (Gift_Kind__c = \'Installment\' or Gift_Kind__c = \'Sustaining Gift\') and (payment_amount__c = null or payment_amount__c = 0) and Recurring_Donation_Opportunity__c = null';
    Public static void BatchUpdatePaidAmount(String ParentId){
        if(NVL(ParentId) != ''){
            strQuery += ' and Id = \'' + ParentId + '\'';
        }
        callBatch(strQuery);
    }
    Public static void BatchUpdatePaidAmount(){
        //strQuery += ' and Id in(\'006Z0000002ZvPq\',\'006Z0000002ZvPZIA0\')';
        callBatch(strQuery);
    }
    static void callBatch(String query){
        ID batchprocessid;
        BatchExecUpdatePaidAmount reassign;

        if(Test.isRunningTest()) query += ' Limit 100';
        reassign = new BatchExecUpdatePaidAmount(query);
        
        batchprocessid = Database.executeBatch(reassign,100);        
    }
    Static String NVL(String val){
        if(val == null)
            return '';
        else
            return val.trim();
    }
    static testMethod void TestBatchUpdatePaidAmount() {
        Test.startTest();
            BatchUpdatePaidAmount.BatchUpdatePaidAmount();
            BatchUpdatePaidAmount.BatchUpdatePaidAmount(null);
        Test.StopTest(); 
    }
}