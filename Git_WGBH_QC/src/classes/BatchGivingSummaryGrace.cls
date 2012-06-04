global class BatchGivingSummaryGrace {
    Public static void BatchGivingSummaryGrace() {
        String query = 'Select ID,Member_Yr_Status__c from Giving_Summary__c where (Member_Yr_Status__c=\'Active\' OR Member_Yr_Status__c=\'Grace\') and History__c=False and Summary_Count__c=0 AND  Grace_Date__c!=null AND Grace_Date__c<=TODAY ';
        if(Test.IsRunningTest()) query += ' Limit 1';        
        BatchExecGivingSummaryGrace reassign = new BatchExecGivingSummaryGrace (query);
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
    
    Public static void BatchGivingSummaryGrace(String GivingSummaryID) {
        String query = 'Select ID,Member_Yr_Status__c from Giving_Summary__c where (Member_Yr_Status__c=\'Active\' OR Member_Yr_Status__c=\'Grace\') and History__c=False AND  Grace_Date__c!=null AND Grace_Date__c<=TODAY AND ID=\'' + GivingSummaryID + '\'';
        if(Test.IsRunningTest()) query += ' Limit 1';        
        BatchExecGivingSummaryGrace reassign = new BatchExecGivingSummaryGrace (query);
        ID batchprocessid = Database.executeBatch(reassign,200);
    }    
    
    public static void CallTestClass() {
    }
    
  
}