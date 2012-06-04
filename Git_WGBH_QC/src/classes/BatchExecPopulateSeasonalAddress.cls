global class BatchExecPopulateSeasonalAddress implements Database.Batchable<sObject>{
    global final String Query;

    global BatchExecPopulateSeasonalAddress(String q){Query=q;}

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
            
            PopulateseasonalAddress obj = new PopulateseasonalAddress(lstAddress);
        }
        

    }
    
    global void finish(Database.BatchableContext BC) {
       
       
        //System.debug('####Update Completed...');
    }

    /*static testMethod void TestBatchExecPopulateSeasonalAddress() {
       Test.startTest();

        Test.StopTest();     
    } */
}