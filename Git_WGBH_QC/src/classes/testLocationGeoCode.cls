@istest
private class testLocationGeoCode{
static testmethod void testLocationGeoCode(){
LocationGeoCode l=new LocationGeoCode();
Location__c l2=new Location__c(account__c=null,state__c='test');
Location__c l1=new Location__c(street__c='test',city__c='test',state__c='test',postalCode__c='test');

LocationGeoCode.updateGeoCode(l1,l2);
}

}