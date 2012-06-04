global class BatchOppLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchOppLink(){
    	// original - WHERE tatransactions_id__c != null and household__c = null and AccountId = null and Oppty_Related_Contact__c = null ';   
        this.query = 'SELECT id, accountId, household__c, Oppty_Related_Contact__c, tatransactions_id__c, batch_process_count__c FROM Opportunity WHERE batch_process_count__c = 1';
    }
    
    global BatchOppLink(Boolean chainFlag){
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
            if(	opp.tatransactions_id__c != null && opp.household__c == null && opp.AccountId == null && opp.Oppty_Related_Contact__c == null ) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	opp.batch_process_count__c--;	
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
    	List<Integer> accountTaIds = new List<Integer>();    	
        List<Integer> householdTaIds = new List<Integer>();
        List<String> contactTaIds = new List<String>();
        
        // 0     1  2    3    4  5
        //328858_02_I_PLEDGE#_03_01
		Orphan__c[] orphans = new List<Orphan__c>();         
        for(Sobject s : scope){        	
            Opportunity opp = (Opportunity) s;
            try {
	            String[] oData = opp.tatransactions_id__c.split('_');
	            
	            if(oData[2] == 'C' || oData[2] == 'G' || oData[2] == 'F' || oData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(oData[0]));
	            }
	            if(oData[2] == 'I') {
	                if(oData[1] == '00') {
	                    householdTaIds.add(Integer.valueOf(oData[0]));
	                }
	                else {
	                    contactTaIds.add(oData[0] + '_' + oData[1] + '_' + oData[2]);
	                    householdTaIds.add(Integer.valueOf(oData[0]));
	                }
	            }		               
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Opportunity',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchOppLink',
        			ta_id__c=opp.tatransactions_id__c,
        			object_id__c=s.id)
        		);
        	}	                 	
        }
        
        List<Account> accounts = [SELECT id, TaAccountId__c FROM Account WHERE TaAccountId__c IN :accountTaIds];
        Map<String, ID> accountsMap = new Map<String, ID>();
        for(Account account : accounts) {
            accountsMap.put(String.valueOf(account.TaAccountId__c), account.Id);
        }               
        List<Household__c> households = [SELECT id, Ta_Account_Id__c FROM Household__c WHERE Ta_Account_Id__c IN :householdTaIds];
        Map<String, ID> householdsMap = new Map<String, ID>();
        for(Household__c household : households) {
            householdsMap.put(String.valueOf(household.Ta_Account_Id__c), household.Id);
        }
        List<Contact> contacts = [SELECT id, TaContactId__c FROM Contact WHERE TaContactId__c IN :contactTaIds];
        Map<String, ID> contactsMap = new Map<String, ID>();
        for(Contact contact : contacts) {
            contactsMap.put(contact.TaContactId__c, contact.Id);
        }
        
        for(Sobject s : scope){
            Opportunity opp = (Opportunity) s;
            try {            
	            String[] oData = opp.tatransactions_id__c.split('_');
	
	            if(oData[2] == 'C' || oData[2] == 'G' || oData[2] == 'F' || oData[2] == 'O') {
	                opp.AccountId = accountsMap.get(oData[0]);
	            }            
	            if(oData[2] == 'I') {
	                if(oData[1] == '00') {
	                    opp.Household__c = householdsMap.get(oData[0]);
	                }
	                else {
	                    opp.Oppty_Related_Contact__c = contactsMap.get(oData[0] + '_' + oData[1] + '_' + oData[2]);
	                    if(householdsMap.get(oData[0]) != null) {
	                    	opp.Household__c = householdsMap.get(oData[0]);
	                    }
	                }
	            }
            	opp.batch_process_count__c--;	            
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Opportunity',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchOppLink',
        			ta_id__c=opp.tatransactions_id__c,
        			object_id__c=s.id)
        		);
        	}	            
            
            //Setting bulk here for perf reasons
            opp.bulk_load__c = false;          
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;         
    }
    
    public static testMethod void testBatch() {
    	Contact c = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
    	   bulk_load__c = true
    	);
    	insert c;   	
    	Account a = new Account(
    	   Name = 'Joe Dirt and Co', 
    	   TaAccountId__c = 23456,
    	   bulk_load__c = true
    	); 
    	insert a;    	     	
    	Household__c h = new Household__c(
    	   Name = 'Mr. & Mrs. Joe Dirt', 
    	   Ta_Account_Id__c = 23456,
    	   bulk_load__c = true
    	);  
    	insert h;  	     	   	
    	Opportunity o1 = new Opportunity(
    	   tatransactions_Id__c = '23456_01_I_1230987_03_01',
    	   Name = 'Test Contact Opporutnity',
    	   CloseDate = Date.today(),
    	   StageName = 'Cultivation',
    	   gift_date__c = Date.today(), 
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert o1;    	
    	Opportunity o2 = new Opportunity(
    	   tatransactions_Id__c = '23456_00_I_1234387_03_01',
    	   Name = 'Test Household Opporutnity',
    	   CloseDate = Date.today(),
    	   StageName = 'Cultivation',
    	   gift_date__c = Date.today(), 
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert o2;    	
    	Opportunity o3 = new Opportunity(
    	   tatransactions_Id__c = '23456_00_C_1344987_03_01',
    	   Name = 'Test Account Opporutnity',
    	   CloseDate = Date.today(),
    	   StageName = 'Cultivation',
    	   gift_date__c = Date.today(), 
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);    	    	    	
    	insert o3;
        
        Test.StartTest();
		BatchOppLink batch = new BatchOppLink();
		batch.query += ' AND tatransactions_Id__c IN (\'23456_01_I_1230987_03_01\', \'23456_00_I_1234387_03_01\', \'23456_00_C_1344987_03_01\') LIMIT 3 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
		
		Opportunity to1 = [SELECT Oppty_Related_Contact__c, Household__c, AccountId FROM Opportunity WHERE tatransactions_Id__c = :o1.tatransactions_Id__c][0];
		System.AssertEquals(to1.Oppty_Related_Contact__c, c.id);
		Opportunity to2 = [SELECT Oppty_Related_Contact__c, Household__c, AccountId FROM Opportunity WHERE tatransactions_Id__c = :o2.tatransactions_Id__c][0];
		System.AssertEquals(to2.Household__c, h.id);		
		Opportunity to3 = [SELECT Oppty_Related_Contact__c, Household__c, AccountId FROM Opportunity WHERE tatransactions_Id__c = :o3.tatransactions_Id__c][0];
		System.AssertEquals(to3.AccountId, a.id);								
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchOppLink', chainFlag);
    }
}