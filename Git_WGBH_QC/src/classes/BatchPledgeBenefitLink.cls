global class BatchPledgeBenefitLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchPledgeBenefitLink(){
    	// original - WHERE TaTransactions_Id__c != null and opportunity__c = null and Recurring_Pledge__c = null';
        this.query = 'Select TaTransactions_Id__c, TaTransactions_Id_Short__c, TaTransaction_Benefits_Id__c, opportunity__c, Recurring_Pledge__c, batch_process_count__c From Pledge_Benefit__c WHERE batch_process_count__c = 2';
    }
    
    global BatchPledgeBenefitLink(Boolean chainFlag){
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
            Pledge_Benefit__c pb = (Pledge_Benefit__c) s;
            //Batch condition.
            if(pb.TaTransactions_Id__c != null && pb.opportunity__c == null && pb.Recurring_Pledge__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	pb.batch_process_count__c--;	
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
        List<String> oppTaIds = new List<String>();
        List<String> rdTaIds = new List<String>();
        
        // 0     1  2    3
        //328858_02_I_PLEDGE#
        // 0     1  2 3      4      5
        //328858_02_I_GF_01-01-2010_03
        for(Sobject s : scope){         
            Pledge_Benefit__c pb = (Pledge_Benefit__c) s;
           	oppTaIds.add(pb.TaTransactions_Id__c);
           	rdTaIds.add(pb.TaTransactions_Id_Short__c);
        }
        
        List<Opportunity> opps = [SELECT TaTransactions_Id__c FROM Opportunity WHERE TaTransactions_Id__c IN :oppTaIds];
        Map<String, Id> oppsIdMap = new Map<String, Id>();
        for(Opportunity opp : opps) {
            oppsIdMap.put(opp.TaTransactions_Id__c, opp.Id);
        }
        List<Recurring_Donation__c> rds = [SELECT TaTransactions_Id__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c IN :rdTaIds];
        Map<String, Id> rdsIdMap = new Map<String, Id>();
        for(Recurring_Donation__c rd : rds) {
            rdsIdMap.put(rd.TaTransactions_Id__c, rd.Id);
        }
		
		Orphan__c[] orphans = new List<Orphan__c>();      
        for(Sobject s : scope){
	        Pledge_Benefit__c pb = (Pledge_Benefit__c) s;        	
        	try {
	            Id oppId = oppsIdMap.get(pb.TaTransactions_Id__c);
	            Id rdId = rdsIdMap.get(pb.TaTransactions_Id_Short__c);
	            
	            if(oppId != null) {
	            	pb.opportunity__c = oppId;
	            }
	            else if(rdId != null) {
	            	pb.Recurring_Pledge__c = rdId;
	            }
	            else {
	            	orphans.add( new Orphan__c(
                        orphan_type__c='Object',
                        classname__c='Pledge_Benefit__c',
                        exception_message__c='Opp not found : ' + pb.TaTransactions_Id__c,
                        batchname__c='BatchPledgeBenefitLink',
                        ta_id__c=pb.TaTransaction_Benefits_Id__c,
                        object_id__c=s.id)
                    );
	            }
            	pb.batch_process_count__c--;		            
        	}
        	catch (Exception ex) {
        		System.debug(ex);
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Pledge_Benefit__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchPledgeBenefitLink',
        			ta_id__c=pb.TaTransaction_Benefits_Id__c,
        			object_id__c=s.id)
        		);
        	}
        }
 
        update scope;	
		if(orphans.size()>0) insert orphans;         	
    }
    
    public static testMethod void testBatch() {
        Opportunity gf = new Opportunity(
           tatransactions_Id__c = '23456_01_I_GF_01-01-2010_01_01', 
           Name = 'Test Gift',
           CloseDate = Date.today(),
           StageName = 'Closed Won',
           gift_date__c = Date.today(), 
           bulk_load__c = true
        );
        insert gf;      
        Recurring_Donation__c rd = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_00_I_1234387_03',
           Name = 'Test RD',
           gift_date__c = Date.today(),
           bulk_load__c = true
        );
        insert rd;
        Pledge_Benefit__c pbgf = new Pledge_Benefit__c(
           TaTransactions_Id__c = '23456_01_I_GF_01-01-2010_01_01',
           TaTransactions_Id_Short__c = '23456_01_I_GF_01-01-2010_01_01',
           Name = 'Gift pb',
           bulk_load__c = true,
           batch_process_count__c =2
        );
        insert pbgf;
        Pledge_Benefit__c pb = new Pledge_Benefit__c(
           TaTransactions_Id__c = '23456_00_I_1234387_03_01',
           TaTransactions_Id_Short__c = '23456_00_I_1234387_03',
           Name = 'Opp pb',
           bulk_load__c = true,
           batch_process_count__c =2
        );
        insert pb;
        
        Test.StartTest();
        BatchPledgeBenefitLink batch = new BatchPledgeBenefitLink();
        batch.query += ' AND TaTransactions_Id__c IN (\'23456_01_I_GF_01-01-2010_01_01\', \'23456_00_I_1234387_03_01\') LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Pledge_Benefit__c tpbgf = [SELECT opportunity__c, Recurring_Pledge__c FROM Pledge_Benefit__c WHERE TaTransactions_Id__c = :pbgf.TaTransactions_Id__c][0];
        System.AssertEquals(tpbgf.Recurring_Pledge__c, null);
        System.AssertEquals(tpbgf.opportunity__c, gf.id);
        Pledge_Benefit__c tpb = [SELECT opportunity__c, Recurring_Pledge__c FROM Pledge_Benefit__c WHERE TaTransactions_Id__c = :pb.TaTransactions_Id__c][0];
        System.AssertEquals(tpb.Recurring_Pledge__c, rd.id);
        System.AssertEquals(tpb.opportunity__c, null);
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchPledgeBenefitLink', chainFlag);
    }
}