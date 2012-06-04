@isTest
Private class TestAddressNewOverride
{ 
    static testMethod void TestAddressNewOverride() 
    {
        string currPageURL;
        address__c adr = new  address__c();
        adr.name = 'test';
        insert adr;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(adr);
        AddressNewOverride ano = new AddressNewOverride(stdCon);
        
        ano.getCurrentURL();
        //ano.RedirectToNewAddress();
    }
}