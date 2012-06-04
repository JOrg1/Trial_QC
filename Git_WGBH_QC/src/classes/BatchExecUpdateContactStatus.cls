global class BatchExecUpdateContactStatus implements Database.Batchable<sObject> {
    global final String Query;
    global BatchExecUpdateContactStatus (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchUpdateContactStatus(scope);
    }    
    void DoBatchUpdateContactStatus(List<sObject> scope) {
        List<Contact> lstContact = (List<Contact>) scope;
        
        for(Contact c: lstContact) {
            if(c.STS__c == 'A'){
                c.Contact_Status__c = 'Active';
            }
        }
        Update lstContact;
    }    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }
    static testMethod void TestBatchExecUpdateContactStatus() {
       Test.startTest();
        Account acc = new Account(Name = 'Test Account');
        
        Contact ct =  new Contact (LastName = 'Test Contact',AccountId =acc.Id,Contact_Status__c = 'Active',STS__c = 'A');
        
        Contact ct1 =  new Contact (LastName = 'Test Contact1',AccountId =acc.Id,Contact_Status__c = 'Active',STS__c = 'A');
        
       /* Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Pledge';
        o.CloseDate = system.today().addDays(10);
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 15;
        insert o;
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'test';
        o1.StageName = 'Pledge';
        o1.CloseDate = system.today().addDays(10);
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 16;                
        insert o1;*/
        
       
        BatchExecUpdateContactStatus  reassign = new BatchExecUpdateContactStatus ('Select ID,Contact_Status__c,STS__c from Contact Limit 10');
        ID batchprocessid = Database.executeBatch(reassign,2);
      
        Test.StopTest();     
        
    }        
}