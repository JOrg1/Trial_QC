global class BatchExecGivingSummaryGrace implements Database.Batchable<sObject> {
    global final String Query;
    global boolean IsTest;    
    global BatchExecGivingSummaryGrace (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchGivingSummaryGrace(scope);
    }
    
    void DoBatchGivingSummaryGrace(List<sObject> scope) {
        List<Giving_Summary__c> lstGivingSummary = new List<Giving_Summary__c>();
        
        for(sObject s : scope) {
            Giving_Summary__c g= (Giving_Summary__c)s;
            g.Member_Yr_Status__c = 'Grace';
            lstGivingSummary.add(g);
        }
        if(lstGivingSummary.size()>0) update lstGivingSummary;
        system.debug('#####' +lstGivingSummary.size());
    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

  
}