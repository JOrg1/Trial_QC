@istest
Private class testBatchExecPopulateSeasonalAddress{

    static testMethod void testBatchExecPopulateSeasonalAddress() {
     
    String q='null';
    BatchExecPopulateSeasonalAddress b =new BatchExecPopulateSeasonalAddress (q);
    List<sObject> scope= [Select ID,Name, Street_1__c, City__c, State__c, Country__c, PreferredAddress__c, Postal_Code__c, Address_Type__c, Account_Household__c,Seasonal_Start_Date__c from Address__c limit 200];
    b.execute(null,scope);
   
    
    }
}