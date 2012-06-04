global class BatchExecCampainMemberReport implements Database.Batchable<sObject>{
    global final String Query;

    global BatchExecCampainMemberReport(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
            
        DoBatchDataImport(scope);
    }
    
    global void DoBatchDataImport(List<sObject> scope) {
        List<Campaign_Member_Report__c> lstCampMemRpt = new List<Campaign_Member_Report__c>();
        
        for(sObject s : scope) {           
           lstCampMemRpt.add((Campaign_Member_Report__c)s);           
        }
        
        if(lstCampMemRpt.size() > 0){
            
            CampainMemberReport obj = new CampainMemberReport();
            lstCampMemRpt = obj.getCampainMember(lstCampMemRpt);
            lstCampMemRpt = obj.getclassificationsummary(lstCampMemRpt);
            lstCampMemRpt = obj.getaccountsummary(lstCampMemRpt);
            lstCampMemRpt = obj.getopportunitysummary(lstCampMemRpt);
            lstCampMemRpt = obj.getcceftaliassummary(lstCampMemRpt);
            lstCampMemRpt = obj.getbiosummary(lstCampMemRpt);
            
            for(Campaign_Member_Report__c cmr:lstCampMemRpt) {
                cmr.IsProccessed__c = true;
            }
            Update lstCampMemRpt;
        }
        

    }
    
    global void finish(Database.BatchableContext BC) {
       
       
        //System.debug('####Update Completed...');
    }

    /*static testMethod void TestBatchExecShopiniterItemGroupImport() {
       Test.startTest();

        Test.StopTest();     
    } */
}