global class BatchJobs implements Database.Batchable<sObject>{
    global String query;

    global BatchJobs(){
        this.query = 'Select id, pledge_number__c From Opportunity';    	
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){       
        for(Sobject s : scope) {
        	Opportunity opp = (Opportunity) s;
            if(opp.pledge_number__c != null && opp.pledge_number__c.contains('.')) {
                opp.pledge_number__c = opp.pledge_number__c.split('\\.')[0];
            }
        }
       	update scope;  
    }

    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {'steven.lemmo@roundcorner.com'});
        mail.setReplyTo('steven.lemmo@roundcorner.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        BatchJobs batch = new BatchJobs();
        batch.query += ' LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
        
        Batch_Job__c bj = new Batch_Job__c(
	        Batch_Job_Name__c = 'NoName'
	    );
	    insert bj;
        Test.StopTest();
    }
}