@isTest 
private class Test_trgRequestBatchAfterUpdate  {
    static testMethod void myTest() {
        Search_Request__c s = new Search_Request__c ();
        insert s;
        s.Status__c = 'Status__c';
        update s;        

    }
}