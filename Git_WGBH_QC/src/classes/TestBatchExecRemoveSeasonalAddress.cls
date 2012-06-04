@istest
Private class TestBatchExecRemoveSeasonalAddress {

    static testMethod void TestBatchExecRemoveSeasonalAddress() {
        
        Test.startTest();
        
        String q='null';
        
        BatchExecRemoveSeasonalAddress b =new BatchExecRemoveSeasonalAddress(q);
        
        List<sObject> scope= [Select ID,Name, Street_1__c, City__c, State__c, Country__c, PreferredAddress__c, Postal_Code__c, Address_Type__c, Account_Household__c,Seasonal_Start_Date__c,Seasonal_End_Date__c from Address__c limit 200];
        b.execute(null,scope);
        
        Test.StopTest(); 
        }
}