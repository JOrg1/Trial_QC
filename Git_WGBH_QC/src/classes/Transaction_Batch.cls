global class Transaction_Batch {
    Public static void Transaction_Batch() {
        String Query = '';
        
        Query += 'Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c,CC_EFT_Alias__r.GUID__c,';
        Query += ' CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c, CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c , AccountId , ';
        Query += ' installment_amount__c , Giving_Amount__c , payment_method__c , Recurring_Donation_Opportunity__c, ';
        Query += ' CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.GUID__c, ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c , ';
      
        Query += ' CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c, CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c ,CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c , ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c , ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c ';
   
        Query += ' from Opportunity Where ';
        Query += ' Status__c = \'PROCESS\' AND ';
        Query += ' StageName = \'Pledged\' AND ';
        Query += ' TRANSACTION_BATCH__c = null AND ' ;
        Query += ' (payment_method__c =\'Charge Card\' or payment_method__c = \'Electronic Funds Transfer\') AND ';
        Query += ' schedule_start_date__c <= Today AND ';
        //Query += ' (Gift_Kind__c = \'One Payment\' or Recurring_Donation_Opportunity__c != null)';
        Query += ' ((Gift_Kind__c = \'One Payment\' And Giving_Amount__c != null And Giving_Amount__c >0 ) Or (Recurring_Donation_Opportunity__c != null And installment_amount__c != null  And installment_amount__c >0))';
       
        if(Test.IsRunningTest()) {
            Query += ' limit 1';
        }

        if(!Test.IsRunningTest()) {
        
            BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch(Query);
            ID batchprocessid = Database.executeBatch(reassign,200);
        }
    }

    Public static void Transaction_Batch_SingleRecord(String TransID) {
        String Query = '';
        
        Query += 'Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c,CC_EFT_Alias__r.GUID__c,';
        Query += ' CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c, CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c , AccountId , ';
        Query += ' installment_amount__c , Giving_Amount__c , payment_method__c , ';
        Query += ' CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.GUID__c, ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c , ';
      
        Query += ' CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c, CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c ,CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c , ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_ID__c, Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_Merchant_Key__c , ';
        Query += ' Recurring_Donation_Opportunity__r.CC_EFT_Alias__r.Merchant_Account__r.EFT_ORIGINATOR_ID__c ';
   
        Query += ' from Opportunity Where ';
        Query += ' Status__c = \'PROCESS\' AND ';
        Query += ' StageName = \'Pledged\' AND ';
        Query += ' TRANSACTION_BATCH__c = null AND ' ;
        Query += ' (payment_method__c =\'Charge Card\' or payment_method__c = \'Electronic Funds Transfer\') AND ';
        Query += ' schedule_start_date__c <= Today AND ';
        //Query += ' (Gift_Kind__c = \'One Payment\' or Recurring_Donation_Opportunity__c != null)';
        Query += ' ((Gift_Kind__c = \'One Payment\' And Giving_Amount__c != null And Giving_Amount__c >0 ) Or (Recurring_Donation_Opportunity__c != null And installment_amount__c != null  And installment_amount__c >0))';

        if(TransID!=null && TransID!='') Query += ' and ID=\'' + TransID + '\'';
        
        if(Test.IsRunningTest()) {
            Query += ' limit 1';
        }

        if(!Test.IsRunningTest()) {
        
            BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch(Query);
            ID batchprocessid = Database.executeBatch(reassign,200);
        }
    }
    
    static testMethod void  TestTransaction_Batch() {
      
        Opportunity o1 = new Opportunity();
        o1.Name = 'test';
        o1.StageName = 'Pledge';
        o1.CloseDate = system.today().addDays(10);
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 20;                
        insert o1;
        
        Test.startTest();
        Transaction_Batch.Transaction_Batch();
        Test.StopTest();     
        
    }
}