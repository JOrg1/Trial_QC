global class BatchBiosLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchBiosLink(){
    	// original - WHERE TABio_Id__c != null and Related_To__c = null and Household__c = null';
        this.query = 'SELECT id, Related_To__c, Household__c, TABio_Id__c, RecordTypeId, batch_process_count__c FROM Bios__c WHERE batch_process_count__c = 1';
    }
    
    global BatchBiosLink(Boolean chainFlag){
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
            Bios__c bios = (Bios__c) s;
            //Batch condition.
            if(bios.TABio_Id__c != null && bios.Related_To__c == null && bios.Household__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	bios.batch_process_count__c--;	
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
        List<Integer> householdTaIds = new List<Integer>();
    	List<String> contactTaIds = new List<String>();
    	
    	List<String> biosRecordTypeNames = new List<String>();
        
        // 0     1  2   3   4
        //328858_02_I_TYPE_XXX
		Orphan__c[] orphans = new List<Orphan__c>();             
        for(Sobject s : scope){
        	try {        	
	            Bios__c bios = (Bios__c) s;
	            String[] cData = bios.TABio_Id__c.split('_');
	            
	            if(cData[2] == 'I') {
	            	if(cData[1] == '00') {
	                    householdTaIds.add(Integer.valueOf(cData[0]));
	            	}
	            	else {
	            		contactTaIds.add(cData[0] + '_' + cData[1] + '_' + cData[2]);
	            	}
	            }
	            biosRecordTypeNames.add(cData[3]);
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Bios__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchBiosLink',
        			ta_id__c=((Bios__c)s).TABio_Id__c,
        			object_id__c=s.id)
        		);
        	}	            
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
        
        List<RecordType> recordTypes = [Select Id, Name From RecordType WHERE SobjectType = 'Bios__c' AND Name IN :biosRecordTypeNames];
        Map<String, ID> recordIdsMap = new Map<String, ID>();
        for(RecordType recordType : recordTypes) {
            recordIdsMap.put(recordType.Name, recordType.Id);
        }
        
        for(Sobject s : scope){
            Bios__c bios = (Bios__c) s;
            String[] cData = bios.TABio_Id__c.split('_');
            
            if(cData[2] == 'I') {
                if(cData[1] == '00') {
                    bios.Household__c = householdsMap.get(cData[0]);
                }
                else {
                    bios.Related_To__c = contactsMap.get(cData[0] + '_' + cData[1] + '_' + cData[2]);
                }
            }
            bios.RecordTypeId = recordIdsMap.get(cData[3]);
            bios.batch_process_count__c--;
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;           
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchBiosLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
    	Contact c = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '12345_01_I',
    	   bulk_load__c = true
    	);
    	insert c;
    	Bios__c b1 = new Bios__c(
    	   TABio_Id__c = '12345_01_I_Education_01',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert b1;
    	
    	Household__c h = new Household__c(
    	   Name = 'Mr. & Mrs. Joe Dirt', 
    	   Ta_Account_Id__c = 12345,
    	   bulk_load__c = true
    	);
    	insert h;
    	Bios__c b2 = new Bios__c(
           TABio_Id__c = '12345_00_I_Education_02',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
        );
        insert b2;
        
        Test.StartTest();
		BatchBiosLink batch = new BatchBiosLink();
		batch.query += ' and TABio_Id__c in ( \'12345_01_I_Education_01\', \'12345_00_I_Education_02\') LIMIT 3 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
		
		Bios__c tb1 = [SELECT Related_To__c FROM Bios__c WHERE TABio_Id__c = :b1.TABio_Id__c][0];
		System.AssertEquals(tb1.Related_To__c, c.id);
		
		Bios__c tb2 = [SELECT Household__c FROM Bios__c WHERE TABio_Id__c = :b2.TABio_Id__c][0];
		System.AssertEquals(tb2.Household__c, h.id);
    }
}