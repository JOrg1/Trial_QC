global class BatchContactLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchContactLink(){
    	// original - WHERE c.TaContactId__c != null AND c.Household__c = null AND c.AccountId = null';
        this.query = 'SELECT c.TaContactId__c, c.AccountId, batch_process_count__c FROM Contact c WHERE batch_process_count__c = 1';
    }
    
    global BatchContactLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		
   }    
    

    global void execute(List<sObject> scope){
                 
    }

    public static testMethod void testBatch() {
    	Contact c1 = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert c1;  
    	Contact c2 = new Contact(
    	   FirstName = 'Jane', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_C',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert c2;      	 	
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
        
        Test.StartTest();
		BatchContactLink batch = new BatchContactLink();
		batch.query += ' and  c.TaContactId__c in (\'23456_01_I\', \'23456_01_C\') LIMIT 3 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchContactLink', chainFlag);
    }
}