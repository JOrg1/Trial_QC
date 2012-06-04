global class BatchUpdateBulk implements Database.Batchable<sObject>{
    global String query;

    global BatchUpdateBulk(){
        this.query = 'SELECT Bulk_load__c, Name, Postal_Code__c FROM Address__c';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject s : scope) {
        	Address__c a = (Address__c) s;
        	a.Bulk_load__c = true;
            a.Name += ' - ' + a.Postal_Code__c;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {'steven.lemmo@roundcorner.com'});
        mail.setReplyTo('steven.lemmo@roundcorner.com');
        mail.setSenderDisplayName('Batch Update Bulk Processing');
        mail.setSubject('Batch Update Bulk Process Completed');
        mail.setPlainTextBody('Batch Update Bulk Process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        BatchUpdateBulk batch = new BatchUpdateBulk();
        batch.query += ' LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
    }
}