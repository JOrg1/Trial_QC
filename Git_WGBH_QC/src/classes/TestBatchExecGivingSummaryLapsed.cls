@isTest
Private class TestBatchExecGivingSummaryLapsed
{ 
    static testMethod void TestBatchExecGivingSummaryLapsed() 
    {   
        Test.startTest();
        
        String Query;
        boolean IsTest;    
        
        List<sObject> scope = new List<sObject>(); 
        List<Giving_Summary__c> lstGivingSummary = new List<Giving_Summary__c>();
        
        //scope.add(Giving_Summary__c);
        Giving_Summary__c gs = new Giving_Summary__c(Member_Yr_Status__c = 'Lapsed');
        //Query = 'Select id from Giving_Summary__c limit 100';
        Query = 'Select ID,Member_Yr_Status__c from Giving_Summary__c where Member_Yr_Status__c=\'Grace\' AND  Lapsed_Date__c!=null AND Lapsed_Date__c<=TODAY limit 1';
        BatchExecGivingSummaryLapsed begsl = new BatchExecGivingSummaryLapsed(Query);
        ID batchprocessid = Database.executeBatch(begsl);
       scope=database.query(Query);
         begsl.execute(null,scope); 
        Test.stopTest();

    }
}