@isTest
Private class TestBatchExecAddCampaignMember
{ 
    static testMethod void TestBatchExecAddCampaignMember() 
    {   
        Test.startTest();
          
        String Query;
        boolean isContact=true;
        String Status;
        ID CampaignId;
        ID RequestId ;

        List<Search_Result__c> lstResult = new List<Search_Result__c>();
        List<Search_Result__c> lstsrcreq = new List<Search_Result__c>();
        
        
        //Query = 'Select id from Account limit 10';
        Query = 'Select ContactLookup__c from  Search_Result__c where Contact__c = true limit 100';
       
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact c = new Contact();
        c.lastname = 'test';
        c.accountid = a.id;
        insert c;
        
        Search_Request__c sr = new Search_Request__c();
        insert sr;
        RequestID = sr.id;
        
        Search_Result__c s = new Search_Result__c();
        s.contact__c = true;
        s.Lead__c = false;
        s.ContactLookup__c = c.id;
        s.Request__c = sr.id;
        
        insert s;
        
        try {
        ID Contactid = [Select ContactLookup__c From Search_Result__c Where Request__c =: RequestID and Contact__c = true and Lead__c = false limit 1].ContactLookup__c;
        for(Integer i = 0; i < 5; i++){
            lstsrcreq.add(new Search_Result__c(Status__c = 'In Progress' + i, ContactLookup__c = Contactid));
        }
        
        insert lstsrcreq;
        }
        Catch(Exception ex) {
        }
        
        Boolean blnSuccess = true;
        BatchExecAddCampaignMember beacm = new BatchExecAddCampaignMember(Query,Status,isContact,CampaignId,RequestId);
        beacm.NVL('');
        ID batchprocessid = Database.executeBatch(beacm);
        beacm.execute(null,database.query(query));
        Test.stopTest();

    }
}