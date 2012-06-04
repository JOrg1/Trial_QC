@istest
private class testAccountGivingSummary{
static testmethod void testAccountGivingSummary()
{
account acc=new account(name='test');
insert acc;
 ApexPages.StandardController stdCon = new ApexPages.StandardController(acc);
AccountGivingSummary a= new AccountGivingSummary(stdCon );
}
}