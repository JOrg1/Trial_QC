global class BatchRdOppPartialClose implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;
    
    global BatchRdOppPartialClose(){
        this.query = 'Select (Select StageName From Donations__r) From Recurring_Donation__c r WHERE r.TaTransactions_Id__c != null';
    }
    
    global BatchRdOppPartialClose(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Opportunity> opps = new List<Opportunity>();
		Orphan__c[] orphans = new List<Orphan__c>();          
        for(Sobject s : scope){
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            try {
	            List<Opportunity> opportunities = rd.Donations__r;
	            
	            if(opportunities != null && opportunities.size() > 0) {
	            	boolean allClosed = true;
					for(Opportunity opp : opportunities) {
					    if(opp.StageName != 'Closed Won') {
					        allClosed = false;
					        break;
					    }
					}
					for(Opportunity opp : opportunities) {
	                    if(opp.StageName == 'Closed Won' && allClosed == false) {
	                        opp.StageName = 'Partial Close';
	                        opps.add(opp);
	                    }
	                }
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Recurring_Donation__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchRdOppPartialClose',
        			ta_id__c=rd.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	            
        }
        update opps;
		if(orphans.size()>0) insert orphans;         
    }
    
    public static testMethod void testBatch() {
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           Name = 'Test RD 1',
           gift_date__c = Date.today(), 
           bulk_load__c = true
        );
        insert rd1;
        Opportunity o11 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Opporutnity 1',
           StageName = 'Closed Won',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           Recurring_Donation__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 1
        );
        insert o11;
        Opportunity o12 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_02',
           Name = 'Test Opporutnity 2',
           StageName = 'Pledged',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           Recurring_Donation__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 2
        );
        insert o12;
        
        Test.StartTest();
        BatchRdOppPartialClose batch = new BatchRdOppPartialClose();
        batch.query += ' AND TaTransactions_Id__c IN (\'23456_01_I_1230987_03\') LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Opportunity[] to = [SELECT StageName FROM Opportunity WHERE tatransactions_Id__c IN (:o11.tatransactions_Id__c, :o12.tatransactions_Id__c)];
        System.AssertEquals(to[0].StageName, 'Partial Close');
        System.AssertEquals(to[1].StageName, 'Pledged');
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchRdOppPartialClose', chainFlag);
    }
}