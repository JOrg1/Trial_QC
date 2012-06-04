global class BatchExecBatch_Transactions implements Database.Batchable<sObject> {
    global final String Query;
 
    global BatchExecBatch_Transactions(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchTransactionsInsert(scope);
    }
    
    void DoBatchTransactionsInsert(List<sObject> scope) {
        List<Transaction_Batch__c> lstbatch = new List<Transaction_Batch__c>();
        
        Transaction_Batch__c TB;
        Set<Id> sRefundIds = new Set<Id>();
        for(sObject s : scope) {
            Refund__c ObjPledge = (Refund__c)s;
            TB = new Transaction_Batch__c();
            TB.Account__c =  ObjPledge.Giving__r.Accountid;
            TB.Refund__c = ObjPledge.Id;
            TB.Process_date__c = ObjPledge.Refund_Date__c;
            TB.GUID__c = ObjPledge.CC_Alias__r.GUID__c;
            TB.Payment_Amount__c = ObjPledge.Refund_Amount__c;
            TB.Pledge_Number__c = ObjPledge.Giving__r.SFDC_GIVING_NUMBER__c;
            TB.Merchant_ID__c = ObjPledge.CC_Alias__r.Merchant_Account__r.Merchant_ID__c;
            TB.Merchant_Key__c =  ObjPledge.CC_Alias__r.Merchant_Account__r.Merchant_Key__c;
            TB.Giving_Id__c = ObjPledge.Giving__c;            
            TB.Transaction_Type__c = 'REFUND';
            TB.Status__c = 'PROCESS';
            lstbatch.add(TB);
            sRefundIds.Add(ObjPledge.Id);
        }
        
        if(lstbatch != null && lstbatch.size()>0) 
        {
            Insert lstbatch;
            
            Map<Id,Refund__c> mapRef = new Map<Id,Refund__c>([Select id,Transaction_batch__c From Refund__c Where Id In: sRefundIds]);
            if(mapRef.size() > 0) {
                for(Transaction_batch__c objtb:lstbatch) {
                    if(mapRef.ContainsKey(objtb.Refund__c) == true) {
                        mapRef.get(objtb.Refund__c).Transaction_batch__c = objtb.Id;
                    }
                }
                Update mapRef.Values();
            }
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }
    
   static testMethod void TestBatchExecBatch_Transactions() {
       Test.startTest();
        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Pledge';
        o.CloseDate = system.today().addDays(10);
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 150;
        o.Gift_Kind__c='One Payment';
        insert o;
        
        Refund__c rf = new Refund__c();
        rf.Refund_Amount__c = 15;
        rf.Refund_Date__c = system.today().addDays(10);
        rf.Giving__c = o.Id;
        insert rf;
        
        //Opportunity o1 = new Opportunity();
        //o1.Refund_Amount__c = 100;
        //o1.Refund_Date__c = system.today().addDays(10);
                     
        //insert o1;
        
       
        BatchExecBatch_Transactions reassign = new BatchExecBatch_Transactions ('Select ID,Refund_Date__c,CC_Alias__r.GUID__c,Refund_Amount__c,Giving__r.SFDC_GIVING_NUMBER__c,CC_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_Alias__r.Merchant_Account__r.Merchant_Key__c,Giving__c,Giving__r.AccountID from Refund__c where ID=\'' + rf.id + '\'');
        ID batchprocessid = Database.executeBatch(reassign,2);
 
        Test.StopTest();     
        
    }
   
}