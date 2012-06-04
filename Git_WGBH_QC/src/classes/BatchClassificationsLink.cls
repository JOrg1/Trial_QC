global class BatchClassificationsLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchClassificationsLink(){
    	// original - Where c.Contact__c = null and c.Organization__c = null and c.Household__c = null'
        // this.query = 'Select c.ta_classification_id__c , c.Contact__c, c.Organization__c, c.Id, c.Household__c From Classification__c c Where c.Contact__c = null and c.Organization__c = null and c.Household__c = null';
        this.query = 'Select c.ta_classification_id__c , c.Contact__c, c.Organization__c, c.Id, c.Household__c, c.batch_process_count__c From Classification__c c Where c.batch_process_count__c = 2';

    }
    
    global BatchClassificationsLink(Boolean chainFlag){
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
            Classification__c c = (Classification__c) s;
            //Batch condition.
            if(c.Contact__c == null && c.Organization__c == null && c.Household__c == null) {
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
        
        // 0   1 2  3 4
        //xxx_00_C__a_b
		Orphan__c[] orphans = new List<Orphan__c>();         
        for(Sobject s : scope){
            Classification__c c = (Classification__c) s;
        	try {            
	            String[] cData = c.ta_classification_id__c.split('_');
	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(cData[0]));
	            }
	            if(cData[2] == 'I') {
	                if(cData[1] == '00') {
	                    householdTaIds.add(Integer.valueOf(cData[0]));
	                }
	                else {
	                    contactTaIds.add(cData[0]+'_'+cData[1]+'_'+cData[2]);
	                }
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Classification__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchClassificationsLink',
        			ta_id__c=c.ta_classification_id__c,
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
            Classification__c c = (Classification__c) s;
            try {
	            String[] cData = c.ta_classification_id__c.split('_');
	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                Id orgId = accountsMap.get(cData[0]);
	                if(orgId != null) {
	                    c.Organization__c = orgId;
	                }
	            }
	            else if(cData[2] == 'I') {
	                if(cData[1] == '00') {
	                    Id hhId = householdsMap.get(cData[0]);
	                    if(hhId != null) {
	                        c.Household__c = hhId;
	                    }
	                }
	                else {
	                    String contactId = contactsMap.get(cData[0]+'_'+cData[1]+'_'+cData[2]);
	                    if(contactId != null) {
	                        c.Contact__c = contactId;
	                    }
	                }
	            }
	            c.batch_process_count__c--;
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Classification__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchClassificationsLink',
        			ta_id__c=c.ta_classification_id__c,
        			object_id__c=s.id)
        		);
        	}	  	            
        }
        update scope;
		if(orphans.size()>0) insert orphans;          
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchClassificationsLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I',
           bulk_load__c = true
        );
        insert c;
        Classification__c c1 = new Classification__c(
           ta_classification_id__c = '12345_01_I_CODE_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 2
        );
        insert c1;
        
        Household__c h = new Household__c(
           Name = 'Mr. & Mrs. Joe Dirt', 
           Ta_Account_Id__c = 12345,
           bulk_load__c = true          
        );
        insert h;
        Classification__c c2 = new Classification__c(
           ta_classification_id__c = '12345_00_I_CODE_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 2
        );
        insert c2;
        
        Account a = new Account(
           Name = 'Joe Dirt and Co', 
           TaAccountId__c = 12345,
           bulk_load__c = true        
        );
        insert a;
        Classification__c c3 = new Classification__c(
           ta_classification_id__c = '12345_00_C_CODE_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 2
        );
        insert c3;
        
        Test.StartTest();
        BatchClassificationsLink batch = new BatchClassificationsLink();
        batch.query += ' and ta_classification_id__c in (\'12345_01_I_CODE_VALUE\',\'12345_00_I_CODE_VALUE\',\'12345_00_C_CODE_VALUE\' ) LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Classification__c tc1 = [SELECT Contact__c FROM Classification__c WHERE ta_classification_id__c = :c1.ta_classification_id__c][0];
        System.AssertEquals(tc1.Contact__c, c.id);
        
        Classification__c tc2 = [SELECT Household__c FROM Classification__c WHERE ta_classification_id__c = :c2.ta_classification_id__c][0];
        System.AssertEquals(tc2.Household__c, h.id);
        
        Classification__c tc3 = [SELECT Organization__c FROM Classification__c WHERE ta_classification_id__c = :c3.ta_classification_id__c][0];
        System.AssertEquals(tc3.Organization__c, a.id);
    }
}