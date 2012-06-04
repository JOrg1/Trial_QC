global class BatchPaymentRecurringDonationLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchPaymentRecurringDonationLink(){
    	// original - WHERE TaTransactions_Id__c != null and Recurring_Donation__c = null and bulk_load__c = true';
        this.query = 'SELECT id, Recurring_Donation__c, TaTransactions_Id__c, batch_process_count__c FROM TaPayment__c WHERE batch_process_count__c = 1';
    }
    
    global BatchPaymentRecurringDonationLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		List<sObject> scope2 = new List<sObject>();
   		List<sObject> scope3 = new List<sObject>();   		
        for(Sobject s : scope) {
            TaPayment__c pay = (TaPayment__c) s;
            //Batch condition.
            if(pay.TaTransactions_Id__c != null && pay.Recurring_Donation__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	pay.batch_process_count__c--;	
            }
        }
        if(scope2.size()>0) {
        	execute(scope2); 
        }
        if(scope3.size()>0) {
        	update scope3;
        }         
   }    

    global void execute(List<sObject> scope){
        List<String> rdTaIds = new List<String>();
        
        // 0     1  2    3    4     5
        //328858_02_I_PLEDGE#_03_01-01-2010
		Orphan__c[] orphans = new List<Orphan__c>();           
        for(Sobject s : scope){         
            TaPayment__c p = (TaPayment__c) s;
            try {
	            String[] oData = p.tatransactions_id__c.split('_');
	            rdTaIds.add(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3]);
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='TaPayment__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchPaymentRecurringDonationLink',
        			ta_id__c=p.tatransactions_id__c,
        			object_id__c=s.id)
        		);
        	}	            
        }
        
        List<Recurring_Donation__c> rds = [SELECT id, TaTransactions_Id_Short__c FROM Recurring_Donation__c WHERE TaTransactions_Id_Short__c IN :rdTaIds];
        Map<String, ID> rdsMap = new Map<String, ID>();
        for(Recurring_Donation__c rd : rds) {
            rdsMap.put(rd.TaTransactions_Id_Short__c, rd.Id);
        }
        
        for(Sobject s : scope){
            TaPayment__c p = (TaPayment__c) s;
            try {
	            String[] oData = p.tatransactions_id__c.split('_');
	            p.Recurring_Donation__c = rdsMap.get(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3]);
            	p.batch_process_count__c--;		            
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='TaPayment__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchPaymentRecurringDonationLink',
        			ta_id__c=p.tatransactions_id__c,
        			object_id__c=s.id)
        		);
        	}	               
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
        TaPayment__c p1 = new TaPayment__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Payment',
           gift_date__c = Date.today(), 
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert p1;
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           TaTransactions_Id_Short__c = '23456_01_I_1230987',
           Name = 'Test Contact RD',
           gift_date__c = Date.today(),
           bulk_load__c = true
        );
        insert rd1;
        
        Test.StartTest();
        BatchPaymentRecurringDonationLink batch = new BatchPaymentRecurringDonationLink();
        batch.query += ' AND TaTransactions_Id__c = \'23456_01_I_1230987_03_01\' LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        TaPayment__c tp1 = [SELECT Recurring_Donation__c FROM TaPayment__c WHERE TaTransactions_Id__c = :p1.TaTransactions_Id__c][0];
        System.AssertEquals(tp1.Recurring_Donation__c, rd1.id);
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchPaymentRecurringDonationLink', chainFlag);
    }
}