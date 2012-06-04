global class BatchGivingSummaryLapsed {

    Public static void BatchGivingSummaryLapsed() {
        String query = 'Select ID,Member_Yr_Status__c from Giving_Summary__c where Lapsed_Date__c!=null AND Lapsed_Date__c<=TODAY and History__c=false and Member_Yr_Status__c = \'Lapsed\'';
        if(Test.IsRunningTest()) query += ' Limit 1';        
        BatchExecGivingSummaryLapsed reassign = new BatchExecGivingSummaryLapsed (query);
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
    
    Public static void BatchGivingSummaryLapsed(String GivingSummaryID) {
        String query = 'Select ID,Member_Yr_Status__c from Giving_Summary__c where Lapsed_Date__c!=null AND Lapsed_Date__c<=TODAY and History__c=false and Member_Yr_Status__c = \'Lapsed\' AND ID=\'' + GivingSummaryID + '\'';
        BatchExecGivingSummaryLapsed reassign = new BatchExecGivingSummaryLapsed (query);
        ID batchprocessid = Database.executeBatch(reassign,200);
    }    
    public static void CallTestClass() {
    }
}