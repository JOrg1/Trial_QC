global class BatchRecurringDonationLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchRecurringDonationLink(){
        // original - WHERE TaTransactions_Id__c != null and Household__c = null and Organization__c = null and Contact__c = null';
        this.query = 'Select r.Id, r.TaTransactions_Id__c, r.Organization__c, r.Household__c, r.Contact__c, batch_process_count__c From Recurring_Donation__c r WHERE r.batch_process_count__c = 2';
    }
    
    global BatchRecurringDonationLink(Boolean chainFlag){
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
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            //Batch condition.
            if(rd.TaTransactions_Id__c != null && rd.Household__c == null && rd.Organization__c == null && rd.Contact__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	rd.batch_process_count__c--;	
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
        
        // 0     1  2    3    4
        //328858_02_I_PLEDGE#_01
		Orphan__c[] orphans = new List<Orphan__c>();           
        for(Sobject s : scope){         
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            try {
	            String[] rdData = rd.TaTransactions_Id__c.split('_');
	            
	            if(rdData[2] == 'C' || rdData[2] == 'G' || rdData[2] == 'F' || rdData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(rdData[0]));
	            }
	            if(rdData[2] == 'I') {
	                if(rdData[1] == '00') {
	                    householdTaIds.add(Integer.valueOf(rdData[0]));
	                }
	                else {
	                    contactTaIds.add(rdData[0] + '_' + rdData[1] + '_' + rdData[2]);
	                    householdTaIds.add(Integer.valueOf(rdData[0]));
	                }
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Recurring_Donation__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchRecurringDonationLink',
        			ta_id__c=rd.TaTransactions_Id__c,
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
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            try {
	            String[] rdData = rd.TaTransactions_Id__c.split('_');
	
	            if(rdData[2] == 'C' || rdData[2] == 'G' || rdData[2] == 'F' || rdData[2] == 'O') {
	                rd.Organization__c = accountsMap.get(rdData[0]);
	            }            
	            if(rdData[2] == 'I') {
	                if(rdData[1] == '00') {
	                    rd.Household__c = householdsMap.get(rdData[0]);
	                }
	                else {
	                    rd.Contact__c = contactsMap.get(rdData[0] + '_' + rdData[1] + '_' + rdData[2]);
	                    if(householdsMap.get(rdData[0]) != null) {
		                    rd.Household__c = householdsMap.get(rdData[0]);
	                    }
	                }
	            } 
	            rd.bulk_load__c = true; // this was set on insert, we need to set on batch link. trigger turns it off. 
	            rd.batch_process_count__c--;	
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Recurring_Donation__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchRecurringDonationLink',
        			ta_id__c=rd.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	    	                    
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;          
    }
    
    public static testMethod void testBatch() {
        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '23456_01_I',
           bulk_load__c =true
        );
        insert c;       
        Account a = new Account(
           Name = 'Joe Dirt and Co', 
           TaAccountId__c = 23456,
           bulk_load__c =true
        ); 
        insert a;               
        Household__c h = new Household__c(
           Name = 'Mr. & Mrs. Joe Dirt', 
           Ta_Account_Id__c = 23456,
           bulk_load__c =true
        );  
        insert h;               
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           Name = 'Test Contact RD',
           gift_date__c = Date.today(),
           bulk_load__c=true,
           batch_process_count__c = 2
        );
        insert rd1;      
        Recurring_Donation__c rd2 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_00_I_1234387_03',
           Name = 'Test Household RD',
           gift_date__c = Date.today(),
           bulk_load__c = true,
           batch_process_count__c = 2         
        );
        insert rd2;      
        Recurring_Donation__c rd3 = new Recurring_Donation__c (
           TaTransactions_Id__c = '23456_00_C_1344987_03',
           Name = 'Test Account RD',
           gift_date__c = Date.today(),
           bulk_load__c = true,
           batch_process_count__c = 2         
        );                      
        insert rd3;
        
        Test.StartTest();
        BatchRecurringDonationLink batch = new BatchRecurringDonationLink();
        batch.query += ' AND TaTransactions_Id__c IN (\'23456_01_I_1230987_03\', \'23456_00_I_1234387_03\', \'23456_00_C_1344987_03\') LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Recurring_Donation__c trd1 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd1.TaTransactions_Id__c][0];
        System.AssertEquals(trd1.Contact__c, c.id);
        Recurring_Donation__c trd2 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd2.TaTransactions_Id__c][0];
        System.AssertEquals(trd2.Household__c, h.id);        
        Recurring_Donation__c trd3 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd3.tatransactions_Id__c][0];
        System.AssertEquals(trd3.Organization__c, a.id);                               
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchRecurringDonationLink', chainFlag);
    }
}