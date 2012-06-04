global class BatchExecRemoveSeasonalAddress implements Database.Batchable<sObject>{
    global final String Query;

    global BatchExecRemoveSeasonalAddress(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        
        DoBatchDataImport(scope);
    }
    
    void DoBatchDataImport(List<sObject> scope) {
        List<Address__c> lstAddress = new List<Address__c>();
        
        for(sObject s : scope) {           
           lstAddress.add((Address__c)s);           
        }
        
        if(lstAddress.size() > 0){
            
            RemoveseasonalAddress obj = new RemoveseasonalAddress(lstAddress);
        }
        

    }
    
    global void finish(Database.BatchableContext BC) {
       
       
        //System.debug('####Update Completed...');
    }

    /*static testMethod void TestBatchExecRemoveSeasonalAddress() {
       Test.startTest();

        Test.StopTest();     
    } */
}