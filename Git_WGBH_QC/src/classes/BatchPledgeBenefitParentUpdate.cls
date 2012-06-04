global class BatchPledgeBenefitParentUpdate implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchPledgeBenefitParentUpdate(){
    	// original - where p.bulk_load__c = true';
        this.query = 'Select p.opportunity__r.Benefit_Exists__c, p.opportunity__c, p.Recurring_Pledge__r.Benefit_Exists__c, p.Recurring_Pledge__c, p.batch_process_count__c From Pledge_Benefit__c p where p.batch_process_count__c = 1';
    }
    
    global BatchPledgeBenefitParentUpdate(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
    	Map<ID, Opportunity> opps = new Map<ID, Opportunity>();
    	Map<ID, Recurring_Donation__c> rds = new Map<ID, Recurring_Donation__c>();
		Orphan__c[] orphans = new List<Orphan__c>();      	
        for(Sobject s : scope){
            Pledge_Benefit__c pb = (Pledge_Benefit__c) s;
            try {
	            if(pb.opportunity__c != null) {
	                pb.opportunity__r.Benefit_Exists__c = true;
	                opps.put(pb.opportunity__c, pb.opportunity__r);
	            }
	            else if(pb.Recurring_Pledge__c != null) {
	                pb.Recurring_Pledge__r.Benefit_Exists__c = true;
	                rds.put(pb.opportunity__c, pb.Recurring_Pledge__r);
	            }
	            pb.batch_process_count__c--;
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Pledge_Benefit__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchPledgeBenefitParentUpdate',
        			ta_id__c=pb.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	            
        }
        update scope;
        update opps.values();
        update rds.values();
		if(orphans.size()>0) insert orphans;           
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchPledgeBenefitParentUpdate', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        BatchPledgeBenefitParentUpdate batch = new BatchPledgeBenefitParentUpdate();
        batch.query += ' LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
    }
}