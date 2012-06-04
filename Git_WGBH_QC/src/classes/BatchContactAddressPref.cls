global class BatchContactAddressPref implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchContactAddressPref(){
        this.query = 'Select ID from Contact';
    }
    
    global BatchContactAddressPref(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchContactAddressPref', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        BatchContactAddressPref batch = new BatchContactAddressPref();
        batch.query += ' LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
    }
}