global class BatchDeleteBulk implements Database.Batchable<sObject>{
    global String query;

    global BatchDeleteBulk(){
        this.query = 'Select id from ReplaceMe';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){

        for(Sobject s : scope){ 
        }
        delete scope;
    }

    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {'steven.lemmo@roundcorner.com'});
        mail.setReplyTo('steven.lemmo@roundcorner.com');
        mail.setSenderDisplayName('Batch Bulk Delete Processing');
        mail.setSubject('Batch Bulk Delete Completed');
        mail.setPlainTextBody('Batch Bulk Delete process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        BatchDeleteBulk batch = new BatchDeleteBulk();
        batch.query = ' Select id from Contact LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
    }
}