global class BatchPopulateSeasonalAddress {
    Public static void BatchPopulateSeasonalAddress() {
        String query = 'Select ID,Name, Street_1__c, City__c, State__c, Country__c, PreferredAddress__c, Postal_Code__c, Address_Type__c, Account_Household__c, Account_Household__r.Id,Seasonal_Start_Date__c from Address__c';
        if(Test.isRunningTest()) query += ' Limit 100';
         
        BatchExecPopulateSeasonalAddress reassign = new BatchExecPopulateSeasonalAddress(query);
        ID batchprocessid = Database.executeBatch(reassign,100);
    }
}