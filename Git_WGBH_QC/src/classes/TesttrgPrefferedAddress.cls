@IsTest
private class TesttrgPrefferedAddress {
 public static testmethod void TesttrgPrefferedAddress (){
    Test.startTest();
        
       Account billing = new Account(Name = 'Testaccountbilling',BillingStreet = 'baccteststreet',BillingCity = 'bacctestcity',BillingState = 'baccteststate',BillingCountry = 'tb');
       insert billing;
       
       Account shipping = new Account(Name = 'Testaccountshipping',ShippingStreet = 'saccteststreet',ShippingCity = 'sacctestcity',ShippingState = 'saccteststate',ShippingCountry = 'ts');
       insert shipping;
       
       
    Test.stopTest();
    }
}