global class BatchSalutationLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchSalutationLink(){
    	// original - WHERE TA_Salutations_Id__c != null and Contact__c = null and Household__c = null and Account__c = null';
        this.query = 'SELECT id, Contact__c, Account__c, TA_Salutations_Id__c, batch_process_count__c FROM Salutation__c WHERE batch_process_count__c = 1';
    }
    
    global BatchSalutationLink(Boolean chainFlag){
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
            Salutation__c c = (Salutation__c) s;
        }
        if(scope2.size()>0) {
        	execute(scope2); 
        }
        if(scope3.size()>0) {
        	update scope3;
        }         
   }    
    

    global void execute(List<sObject> scope){
    }
    
    public static testMethod void testBatch() {
    	//this.query += ' LIMIT 1 '; 
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
    	Salutation__c s1 = new Salutation__c(
    	   ta_salutations_Id__c = '23456_01_I_ENDOW',
    	   salutation_code__c = 'EDDOW',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	
    	insert s1;
    	Salutation__c s2 = new Salutation__c(
    	   ta_salutations_Id__c = '23456_00_I_ENDOW',
    	   salutation_code__c = 'EDDOW',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert s2;   
    	Salutation__c s3 = new Salutation__c(
    	   ta_salutations_Id__c = '23456_00_C_ENDOW',
    	   salutation_code__c = 'EDDOW',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert s3;        	 	
        
        Test.StartTest();
		BatchSalutationLink batch = new BatchSalutationLink();
		batch.query += ' and ta_salutations_Id__c in (\'23456_01_I_ENDOW\',\'23456_00_I_ENDOW\', \'23456_00_C_ENDOW\' ) LIMIT 3 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
    }
    
    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchSalutationLink', chainFlag);
    }
}