global class BatchBulkflagProcessor implements Database.Batchable<sObject> {
	global static final String HOUSEHOLD_CHAIN = 'Household';
	global static final String TRANSACTION_CHAIN = 'Transaction';
	global static final String INTERACTION_CHAIN = 'Interaction';
	
    global String[] objectNamesChainHousehold = new String[]{'Address__c', 'Classification__c', 'Contact', 'Household__c', 'Relationships__c', 'Salutation__c'}; 
    global String[] objectNamesChainTransaction = new String[]{'Opportunity', 'TaPayment__c', 'Recurring_Donation__c', 'Pledge_Benefit__c'};
    global String[] objectNamesChainInteraction = new String[]{'Case','Task'};
    
    global String chainName;
    global Integer objectNumber;
    global String query;
    global Boolean chainFlag = false;
    global Boolean chain = false;
    
    global BatchBulkflagProcessor(String chainName, Integer objectNumber) {
    	this.chain = true;
    	this.chainName = chainName;
        this.objectNumber = objectNumber;
        String objectName = null;
        if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.HOUSEHOLD_CHAIN)) {
        	objectName = objectNamesChainHousehold[objectNumber - 1];
        }
        else if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.TRANSACTION_CHAIN)) {
            objectName = objectNamesChainTransaction[objectNumber - 1];
        }
        else if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.INTERACTION_CHAIN)) {
            objectName = objectNamesChainInteraction[objectNumber - 1];
        }
        this.query = 'SELECT id, bulk_load__c FROM ' + objectName + ' WHERE bulk_load__c = true';
    }
    
    global BatchBulkflagProcessor(String chainName, Integer objectNumber, Boolean chainFlag) {
        this(chainName, objectNumber);
        this.chainFlag = chainFlag;
    }
    
    global BatchBulkflagProcessor(String objectName) {
    	this.chain = false;
        this.query = 'SELECT id, bulk_load__c FROM ' + objectName + ' WHERE bulk_load__c = true';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject s : scope) {
           s.put('bulk_load__c', false);
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        if(chain) {
        	Integer nextObjectNumber = 0;
        	if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.HOUSEHOLD_CHAIN)) {
	            if(objectNumber < objectNamesChainHousehold.size())
	               nextObjectNumber = objectNumber + 1;
	        }
	        else if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.TRANSACTION_CHAIN)) {
	            if(objectNumber < objectNamesChainTransaction.size())
                   nextObjectNumber = objectNumber + 1;
	        }
	        else if(chainName.equalsIgnoreCase(BatchBulkflagProcessor.INTERACTION_CHAIN)) {
	            if(objectNumber < objectNamesChainInteraction.size())
                   nextObjectNumber = objectNumber + 1;
	        }
	        
	        if(nextObjectNumber > 0) {
	        	bdie.dispatchChainBatch('BatchBulkflagProcessor', chainName, nextObjectNumber, chainFlag);
	        }
	        else {
            	bdie.dispatchBatch('BatchBulkflagProcessor', chainFlag);
	        }
        }
        else {
        	bdie.dispatchBatch('BatchBulkflagProcessor', chainFlag);
        }
    }
    
    public static testMethod void testBatch() {
        Account a = new Account(
    	   Name = 'Joe Dirt and Co', 
    	   TaAccountId__c = 23456, 
    	   bulk_load__c = true
    	); 
        insert a;
        
        Test.StartTest();
        BatchBulkflagProcessor batch = new BatchBulkflagProcessor('Account');
        batch.query += ' AND TaAccountId__c = 23456 LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Account ta = [SELECT bulk_load__c FROM Account WHERE TaAccountId__c = :a.TaAccountId__c][0];
        System.AssertEquals(ta.bulk_load__c, false);
    }
}