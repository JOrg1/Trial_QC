@isTest
private class TestBatchGivingSummaryLapsed {
    static testMethod void myTest() {
       Test.startTest();
       //Giving_Summary__c g = new Giving_Summary__c();
       //g.Member_yr_Status__c = 'Grace';
       //g.Lapsed_Date__c = system.today();
       //insert g;
       BatchGivingSummaryLapsed.CallTestClass();
       //BatchGivingSummaryLapsed.BatchGivingSummaryLapsed();
       Test.StopTest();     
        
    }
}