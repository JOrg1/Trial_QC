@isTest
Private class TestAccountViewOverride
{ 
    static testMethod void TestAccountViewOverride() 
    {
        test.startTest();
             
        Account a = new Account();
        a.Name = 'acctest';
        insert a;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AccountViewOverride avo = new AccountViewOverride(stdCon);
        avo.getaccount();
        
        test.stopTest();
    }
}