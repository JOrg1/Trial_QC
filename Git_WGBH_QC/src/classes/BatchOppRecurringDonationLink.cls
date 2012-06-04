global class BatchOppRecurringDonationLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchOppRecurringDonationLink() {
    	// original - WHERE tatransactions_id__c != null and transaction_type_value__c = \'PL\' and gift_kind_value__c IN (\'IN\', \'SG\') and pledge_status_value__c IN (\'PF\', \'UF\') and Recurring_Donation__c = null';
        this.query = 'SELECT id, Recurring_Donation__c, tatransactions_id__c, transaction_type_value__c, gift_kind_value__c, pledge_status_value__c, batch_process_count__c FROM Opportunity WHERE batch_process_count__c = 2 ';
    }
    
    global BatchOppRecurringDonationLink(Boolean chainFlag){
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
            Opportunity opp = (Opportunity) s;
            //Batch condition.
            if(	opp.tatransactions_id__c != null && 
            	opp.transaction_type_value__c == 'PL' &&            		
            	( opp.gift_kind_value__c == 'IN' || opp.gift_kind_value__c == 'SG') &&             		
            	( opp.pledge_status_value__c == 'PF' || opp.pledge_status_value__c == 'UF') &&             		
            	opp.Recurring_Donation__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	//todo: opp.batch_process_count__c--;	
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
        
        // 0     1  2    3    4  5
        //328858_02_I_PLEDGE#_03_01
		Orphan__c[] orphans = new List<Orphan__c>();         
        for(Sobject s : scope){         
            Opportunity opp = (Opportunity) s;
            try {
	            String[] oData = opp.tatransactions_id__c.split('_');
	            rdTaIds.add(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3] + '_' + oData[4]);
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Opportunity',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchOppRecurringDonationLink',
        			ta_id__c=opp.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	            
        }
        
        List<Recurring_Donation__c> rds = [SELECT id, TaTransactions_Id__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c IN :rdTaIds];
        Map<String, ID> rdsMap = new Map<String, ID>();
        for(Recurring_Donation__c rd : rds) {
            rdsMap.put(rd.TaTransactions_Id__c, rd.Id);
        }
        
        for(Sobject s : scope){
            Opportunity opp = (Opportunity) s;
            try {
	            String[] oData = opp.tatransactions_id__c.split('_');
	            opp.Recurring_Donation__c = rdsMap.get(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3] + '_' + oData[4]);
	            //todo: opp.batch_process_count__c--;	
            }
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Opportunity',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchOppRecurringDonationLink',
        			ta_id__c=opp.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	                
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
        Opportunity o1 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Contact Opporutnity',
           CloseDate = Date.today(),
           StageName = 'Cultivation',
           gift_date__c = Date.today(), 
           transaction_type_value__c = 'PL', 
           gift_kind_value__c = 'IN',
           pledge_status_value__c = 'PF',  
           bulk_load__c = true,
           batch_process_count__c = 2
        );
        insert o1;
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           Name = 'Test Contact RD',
           gift_date__c = Date.today(),
           bulk_load__c = true
        );
        insert rd1;
        
        Test.StartTest();
        BatchOppRecurringDonationLink batch = new BatchOppRecurringDonationLink();
        batch.query += ' AND tatransactions_Id__c = \'23456_01_I_1230987_03_01\' LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Opportunity to1 = [SELECT Recurring_Donation__c FROM Opportunity WHERE tatransactions_Id__c = :o1.tatransactions_Id__c][0];
        System.AssertEquals(to1.Recurring_Donation__c, rd1.id);
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchOppRecurringDonationLink', chainFlag);
    }
}