@IsTest
private class TesttrgAddressToAccountNew {
 public static testmethod void TesttrgAddressToAccountNew (){
        Test.startTest();
        
        
        Account a = new Account(Name = 'TestAccount',BillingStreet = 'baccteststreet',BillingCity = 'bacctestcity',BillingState = 'baccteststate',BillingCountry = 'tb',ShippingStreet = 'saccteststreet',ShippingCity = 'sacctestcity',ShippingState = 'saccteststate',ShippingCountry = 'ts');
        insert a;
        
        Address__c adr = new Address__c();
        adr.PreferredAddress__c  = true;
        adr.Account_Household__c = a.id;
        insert adr;
        
        //Account a1 = new Account(Id= a.id,Name = 'TestAccount',ShippingStreet = 'saccteststreet1',ShippingCity = 'sacctestcity1',ShippingState = 'saccteststate1',ShippingCountry = 'us');
        //update a1;
        
        Test.stopTest();
     }
}