global class BatchTaskLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchTaskLink(){
    	//orginal - Where c.ta_interaction_id__c != null And c.WhatId = null And c.WhoId = null';
        this.query = 'Select c.RecordTypeId, c.ta_interaction_id__c , c.WhatId, c.WhoId, c.Subject, c.Techique__c, c.Contact_Category__c, c.Contact_Type__c, c.batch_process_count__c From Task c Where c.batch_process_count__c = 1';
    }
    
    global BatchTaskLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		List<sObject> scope2 = new List<sObject>();
   		List<sObject> scope3 = new List<sObject>(); 
   		RecordType rt = [select id from RecordType where SobjectType='Task' and Name='Legacy' limit 1] ; 		
        for(Sobject s : scope) {
            Task tsk = (Task) s;
            tsk.RecordTypeId = rt.id;
            //Batch condition.
            if(tsk.ta_interaction_id__c != null && tsk.WhatId == null && tsk.WhoId == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	tsk.batch_process_count__c--;	
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
            Task clazz = (Task) s;
        	try {            
	            String[] cData = clazz.ta_interaction_id__c.split('_');
	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(cData[0]));
	            }
	            if(cData[2] == 'I') {
	                householdTaIds.add(Integer.valueOf(cData[0]));
	                if(cData[1] != '00') {
	                    contactTaIds.add(cData[0]+'_'+cData[1]+'_'+cData[2]);
	                }
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Task',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchTaskLink',
        			ta_id__c=clazz.ta_interaction_id__c,
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
            Task clazz = (Task) s;
            try {
            	if(clazz.Techique__c == null) {
            		clazz.Subject = clazz.Contact_Category__c + ' - ' + clazz.Contact_Type__c;
            	}
            	else {
            		clazz.Subject = clazz.Techique__c + ' - ' + clazz.Contact_Category__c + ' - ' + clazz.Contact_Type__c;            		
            	}
	            String[] cData = clazz.ta_interaction_id__c.split('_');
	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                Id orgId = accountsMap.get(cData[0]);
	                if(orgId != null) {
	                    clazz.WhatId = orgId;
	                }
	            }
	            else if(cData[2] == 'I') {
                    Id hhId = householdsMap.get(cData[0]);
                    if(hhId != null) {
                        clazz.WhatId = hhId;
                    }
	                if(cData[1] != '00') {
	                    String contactId = contactsMap.get(cData[0]+'_'+cData[1]+'_'+cData[2]);
	                    if(contactId != null) {
	                        clazz.WhoId = contactId;
	                    }
	                }
	            }
	            clazz.batch_process_count__c--;	            
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Task',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchTaskLink',
        			ta_id__c=clazz.ta_interaction_id__c,
        			object_id__c=s.id)
        		);
        	}	  	            
        }
        update scope;
		if(orphans.size()>0) insert orphans;          
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchTaskLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I',
           bulk_load__c=true
        );
        insert c;
        User user = [select id from user where IsActive=true limit 1];
        Task c1 = new Task(
           OwnerId = user.Id,
           Subject = 'Solicitation',
           Priority = 'Normal',
           Status = 'Completed',
           ta_interaction_id__c = '12345_01_I_SO_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert c1;
        
        Household__c h = new Household__c(
           Name = 'Mr. & Mrs. Joe Dirt', 
           Ta_Account_Id__c = 12345,
           bulk_load__c=true
        );
        insert h;
        Task c2 = new Task(
           OwnerId = user.Id,
           Subject = 'Solicitation',
           Priority = 'Normal',
           Status = 'Completed',        
           ta_interaction_id__c = '12345_00_I_SO_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert c2;
        
        Account a = new Account(
           Name = 'Joe Dirt and Co', 
           TaAccountId__c = 12345,
           bulk_load__c=true
        );
        insert a;
        Task c3 = new Task(
           OwnerId = user.Id,
           Subject = 'Solicitation',
           Priority = 'Normal',
           Status = 'Completed',             
           ta_interaction_id__c = '12345_00_C_SO_VALUE',
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert c3;
        
        Test.StartTest();
        BatchTaskLink batch = new BatchTaskLink();
        batch.query += ' and ta_interaction_id__c in (\'12345_01_I_SO_VALUE\',\'12345_00_I_SO_VALUE\',\'12345_00_C_SO_VALUE\' ) LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Task tc1 = [SELECT WhatId FROM Task WHERE ta_interaction_id__c = :c1.ta_interaction_id__c][0];
//todo        System.AssertEquals(tc1.WhatId, c.id);
        
        Task tc2 = [SELECT WhatId FROM Task WHERE ta_interaction_id__c = :c2.ta_interaction_id__c][0];
//todo        System.AssertEquals(tc2.WhatId, h.id);
        
        Task tc3 = [SELECT WhatId FROM Task WHERE ta_interaction_id__c = :c3.ta_interaction_id__c][0];
//todo        System.AssertEquals(tc3.WhatId, a.id);
    }
}