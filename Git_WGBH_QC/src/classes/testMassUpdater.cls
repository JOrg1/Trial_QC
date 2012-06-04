@istest
private class testMassUpdater{
static testmethod void testMassUpdater(){
list<sObject> abc=new list<sObject>();
abc.add(new contact());
Schema.DescribeFieldResult T = account.Industry.getDescribe();
Schema.sObjectField f = T.getSObjectField();
massupdater m=new massupdater(abc, f,'test');

m.massUpdate();


}
}