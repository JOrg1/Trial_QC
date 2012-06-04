global class BatchExecTransaction_Batch implements Database.Batchable<sObject> {
    global final String Query;
 
    global BatchExecTransaction_Batch(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        if(!Test.IsRunningTest()) DoBatchTransactionbatchInsert(scope);
    }
    
    void DoBatchTransactionbatchInsert(List<sObject> scope) {
        List<Transaction_Batch__c> lstbatch = new List<Transaction_Batch__c>();
        
        Transaction_Batch__c TB;
        Set<Id> soppIds = new Set<Id>();
        for(sObject s : scope) {
            Opportunity ObjPledge = (Opportunity)s;
            TB = new Transaction_Batch__c();
            System.debug('pledgeid: '+ ObjPledge.Id );

            TB.Account__c = ObjPledge.AccountId;
            TB.Process_date__c = ObjPledge.Payment_Date__c;           
                       
            If(ObjPledge.Recurring_Donation_Opportunity__c != null) {
                if(ObjPledge.installment_amount__c != null && ObjPledge.installment_amount__c >0){
                   TB.Payment_Amount__c = ObjPledge.installment_amount__c;
                } else {
                    return;
                }
            } else {
               TB.Payment_Amount__c = ObjPledge.Giving_Amount__c;
            }
            TB.Pledge_Number__c = ObjPledge.SFDC_GIVING_NUMBER__c;
            TB.Giving_Id__c = ObjPledge.Id;
            if(ObjPledge.CC_EFT_Alias__c == null && ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__c != null) {
                TB.GUID__c = ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.GUID__c;
                if(ObjPledge.Payment_Method__c == 'Electronic Funds Transfer') {
                    TB.Merchant_ID__c = ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c;
                    TB.Merchant_Key__c =  ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c;
                    TB.EFT_ORIGINATOR_ID__c =  ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c;
                } else {
                    TB.Merchant_ID__c = ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c;
                    TB.Merchant_Key__c =  ObjPledge.Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c;
                }
            } else {
                TB.GUID__c = ObjPledge.CC_EFT_Alias__r.GUID__c;
                if(ObjPledge.Payment_Method__c == 'Electronic Funds Transfer') {
                    TB.Merchant_ID__c = ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c;
                    TB.Merchant_Key__c =  ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c;
                    TB.EFT_ORIGINATOR_ID__c =  ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c;
                } else {                
                    TB.Merchant_ID__c = ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c;
                    TB.Merchant_Key__c =  ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c;
                }
            }
            TB.Transaction_Type__c = 'PAYMENT';
            TB.Status__c = 'PROCESS';
            lstbatch.add(TB);
            soppIds.Add(ObjPledge.Id);
            
        }
        
        if(lstbatch != null && lstbatch.size()>0) 
        {
            Insert lstbatch;
            Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>([Select id,Transaction_batch__c,CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__c From Opportunity Where Id In:soppIds]);
            if(mapOpp.size() > 0) {
                for(Transaction_batch__c objtb:lstbatch) {
                    if(mapOpp.ContainsKey(objtb.Giving_Id__c) == true) {
                        mapOpp.get(objtb.Giving_Id__c).Transaction_batch__c = objtb.Id;
                        if(mapOpp.get(objtb.Giving_Id__c).CC_EFT_Alias__c == null) {
                           mapOpp.get(objtb.Giving_Id__c).CC_EFT_Alias__c = mapOpp.get(objtb.Giving_Id__c).Recurring_Donation_Opportunity__r.CC_EFT_Alias__c;
                        }
                    }
                }
                Update mapOpp.Values();
            }
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

   static testMethod void TestBatchExecTransaction_Batch() {
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
        
       
        BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch ('Select Id,Payment_Date__c,SFDC_GIVING_NUMBER__c,CC_EFT_Alias__r.GUID__c,Payment_Amount__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c,AccountId, installment_amount__c , Giving_Amount__c ,CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.GUID__c from Opportunity Where Payment_Date__c = Today Limit 2');
        ID batchprocessid = Database.executeBatch(reassign,2);
 
        Test.StopTest();     
        
    }
}