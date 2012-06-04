global class BatchExecUpdateContactStatusCall {
    Public static void BatchExecUpdateContactStatusCall () {
        ID batchprocessid;
        BatchExecUpdateContactStatus status;
        
        String query = 'Select ID,STS__c,Contact_Status__c from Contact where TaContactId__c != null && TaContactId__c != \'\'';
        if(Test.isRunningTest()) query += ' Limit 100';
        
        status = new BatchExecUpdateContactStatus(query);
        batchprocessid = Database.executeBatch(status,200);
    }
    
    static testMethod void TestBatchExecUpdateContactStatusCall() {
        Test.startTest();
        Account acc = new Account(Name = 'Test Account');
        Contact ct =  new Contact (LastName = 'Test Contact',AccountId =acc.Id,Contact_Status__c = 'Active',STS__c = 'A');
        Contact ct1 =  new Contact (LastName = 'Test Contact1',AccountId =acc.Id,Contact_Status__c = 'Active',STS__c = 'A');
                  
        //BatchExecUpdateContactStatus  beUpdateS = new BatchExecUpdateContactStatus ();
        BatchExecUpdateContactStatusCall.BatchExecUpdateContactStatusCall(); 
        Test.StopTest();    
        
    } 
    
    
}