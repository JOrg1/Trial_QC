global class BatchCaseLink implements Database.Batchable<sObject> {
    global String query;
    global Boolean chainFlag = false;

    global BatchCaseLink(){
    	// original - 'WHERE ta_interactions_Id__c != null and ContactId = null and Household__c = null and AccountId = null';
        this.query = 
        	'Select ta_interactions_Id__c, program_code__c, Program__c, Household__c, ContactId, CaseNumber, AccountId, batch_process_count__c ' + 
        	'From Case ' +
        	'Where batch_process_count__c = 2';
    }
    
    global BatchCaseLink(Boolean chainFlag){
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
            Case c = (Case) s;
            //Batch condition.
            if(c.ta_interactions_Id__c != null && c.ContactId == null && c.Household__c == null && c.AccountId == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	c.batch_process_count__c--;	
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
        
        // 0     1  2  3  4   5          6  7
        //328858_02_I_SO_BAR_MM-DD-YYYY_01_01
        //328858_02_I_SO_BAR   
		Orphan__c[] orphans = new List<Orphan__c>();               
        for(Sobject s : scope){
            Case cas = (Case) s;
        	try {            
	            String[] sData = cas.ta_interactions_Id__c.split('_');
	            
	            if(sData[2] == 'C' || sData[2] == 'G' || sData[2] == 'F' || sData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(sData[0]));
	            }
	            if(sData[2] == 'I') {
	                if(sData[1] == '00') {
	                    householdTaIds.add(Integer.valueOf(sData[0]));
	                }
	                else {
	                    contactTaIds.add(sData[0] + '_' + sData[1] + '_' + sData[2]);
	                }
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Case',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchCaseLink',
        			ta_id__c=cas.ta_interactions_Id__c,
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
            Case cas = (Case) s;
			try {            
	            String[] sData = cas.ta_interactions_Id__c.split('_');
	            
	            if(sData[2] == 'C' || sData[2] == 'G' || sData[2] == 'F' || sData[2] == 'O') {
	                cas.AccountId = accountsMap.get(sData[0]);
	            }
	            if(sData[2] == 'I') {
	                if(sData[1] == '00') {
	                    cas.Household__c = householdsMap.get(sData[0]);
	                }
	                else {
	                    cas.ContactId = contactsMap.get(sData[0] + '_' + sData[1] + '_' + sData[2]);
	                }
	            }
	            cas.batch_process_count__c--;
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Case',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchCaseLink',
        			ta_id__c=cas.ta_interactions_Id__c,
        			object_id__c=s.id)
        		);
        	}		            
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
    	//this.query += ' LIMIT 1 '; 
    	Contact c = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
    	   bulk_load__c=true
    	);
    	insert c;   	
    	Account a = new Account(
    	   Name = 'Joe Dirt and Co', 
    	   TaAccountId__c = 23456,
    	   bulk_load__c=true
    	); 
    	insert a;    	     	
    	Household__c h = new Household__c(
    	   Name = 'Mr. & Mrs. Joe Dirt', 
    	   Ta_Account_Id__c = 23456,
    	   bulk_load__c=true
    	);  
    	insert h;  	     	   	
    	Case case1 = new Case(
    	   ta_interactions_Id__c = '23456_01_I_SO_BAR',
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Jazz',
    	   Status='Open',
    	   contact_date__c=System.today(),
    	   bulk_load__c=true,
    	   batch_process_count__c=2
    	);   	
    	insert case1; 
    	Case case2 = new Case(
    	   ta_interactions_Id__c = '23456_00_I_SO_BAR',
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Jazz',
    	   Status='Open',
    	   contact_date__c=System.today(),
    	   bulk_load__c=true,
    	   batch_process_count__c=2
    	);   	
    	insert case2;   
    	Case case3 = new Case(
    	   ta_interactions_Id__c = '23456_00_C_SO_BAR',
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Jazz',
    	   Status='Open',
    	   contact_date__c=System.today(),
    	   bulk_load__c=true,
    	   batch_process_count__c=2
    	);   	
    	insert case3;       	    	  	 	
        
        Test.StartTest();
		BatchCaseLink batch = new BatchCaseLink();
		batch.query += ' AND ta_interactions_Id__c IN (\'23456_01_I_SO_BAR\', \'23456_00_I_SO_BAR\', \'23456_00_C_SO_BAR\') LIMIT 10 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
		
		Case tcase1 = [SELECT ContactId, Household__c, AccountId FROM Case WHERE ta_interactions_Id__c = :case1.ta_interactions_Id__c][0];
		System.AssertEquals(tcase1.ContactId, c.id);
		Case tcase2 = [SELECT ContactId, Household__c, AccountId FROM Case WHERE ta_interactions_Id__c = :case2.ta_interactions_Id__c][0];
		System.AssertEquals(tcase2.Household__c, h.id);		
		Case tcase3 = [SELECT ContactId, Household__c, AccountId FROM Case WHERE ta_interactions_Id__c = :case3.ta_interactions_Id__c][0];
		System.AssertEquals(tcase3.AccountId, a.id);								
    }
    
    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchCaseLink', chainFlag);
    }
}