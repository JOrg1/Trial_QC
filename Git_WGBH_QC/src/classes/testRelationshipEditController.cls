@istest
private class testRelationshipEditController{
    static testmethod void testRelationshipEditController(){
       Relationships__c r = new Relationships__c();

        insert r;
        
        ApexPages.StandardController stdaco = new ApexPages.StandardController(r);
        RelationshipEditController r1 = new RelationshipEditController(stdaco) ;
    }
}