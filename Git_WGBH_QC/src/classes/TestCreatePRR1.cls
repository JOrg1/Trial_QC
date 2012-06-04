@isTest
Private class TestCreatePRR1
{ 
    static testMethod void TestCreatePRR1() 
    {
        string currPageURL;
        address__c adr = new  address__c();
        adr.name = 'test';
        insert adr;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(adr);
        CreatePRR1 ano = new CreatePRR1 (stdCon);
        
        ano.getCurrentURL();
        //ano.RedirectToNewAddress();
    }
}