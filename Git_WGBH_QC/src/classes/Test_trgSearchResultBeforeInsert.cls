@isTest 
private class Test_trgSearchResultBeforeInsert  {
    static testMethod void myTest() {
        Search_Result__c s = new Search_Result__c();
        insert s;
    }
}