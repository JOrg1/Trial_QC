global class BatchExecExtendCCDate_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global final String Query;
 
    global BatchExecExtendCCDate_Batch(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoExtendCCdate(scope);
    }

    void DoExtendCCdate(List<sObject> scope) {
        Transaction_Batch__c ObjTrasBatch = (Transaction_Batch__c)scope[0];
        SageTransactionProcess.UpdateExpireDateAndRePayment(ObjTrasBatch.id);

    }  

    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }
    
     static testMethod void TestBatchExecExtendCCDate_Batch() {
       Test.startTest();
        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Pledge';
        o.CloseDate = system.today().addDays(10);
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 15;
        insert o;
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'test';
        o1.StageName = 'Pledge';
        o1.CloseDate = system.today().addDays(10);
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 16;                
        insert o1;
        
        CC_Alias__c objcca = new CC_Alias__c ();
        objcca.GUID__c = 'test';
        insert objcca;
        
        Transaction_Batch__c tb = new Transaction_Batch__c();
        tb.Giving_Id__c = o1.Id;
        tb.Merchant_Id__c = o1.Id;
        tb.Merchant_Key__c = '66776666';
        tb.GUID__c = 'test';
        tb.UpdateCCDate__c = false;
        tb.needToRePaymentReq__c = false;
        tb.isCCDateExpired__c  = true;
        insert tb;        
        
        String query='SELECT  Id FROM transaction_batch__c Where UpdateCCDate__c = false and needToRePaymentReq__c = false And isCCDateExpired__c  = true';
        BatchExecExtendCCDate_Batch reassign = new BatchExecExtendCCDate_Batch (query);
       
        ID batchprocessid = Database.executeBatch(reassign,1);
 
        Test.StopTest();     
        
    }
}