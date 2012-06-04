@istest
private  class testBatchExecCampainMemberReport
{
    static testMethod void testBatchExecCampainMemberReport()
    {
     Test.startTest();
     BatchExecCampainMemberReport reassign = new BatchExecCampainMemberReport('select id,Campaign_Member_Id__c,Contact__r.Account.id,Account_Id__c,Campaign__c,Contact__c from Campaign_Member_Report__c where IsProccessed__c = false  limit 1');
     ID batchprocessid = Database.executeBatch(reassign,1);
     
     Test.StopTest();     
    }
}