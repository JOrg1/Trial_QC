@isTest
private class TesttrgGivingBiosAfterInsert{
    static testMethod void myTest() {
        Account h = new Account();
            h.Name = 'Mr. & Mrs. Joe Dirt';
            h.TaAccountId__c = 23456; 
        insert h;     

        Contact c = new Contact();
            c.FirstName = 'Joe';
            c.LastName = 'Dirt'; 
            c.TaContactId__c = '23456_01_I';
            c.Account_Household__c = h.id;
        insert c;
        
        List<RecordType> RecTypecam = new List<RecordType>([select id from RecordType where DeveloperName = 'Event' and sObjectType = 'Campaign']);
        Campaign cam = new Campaign();
             cam.RecordTypeId = RecTypecam[0].Id;
             cam.Subject_Title__c = 'Test';
             cam.Name = 'Test';
             
        insert cam;
        
        List<RecordType> RecType = new List<RecordType>([select id from RecordType where DeveloperName = 'Annual' and sObjectType = 'Opportunity']);
        
        Opportunity opp = new Opportunity();
            opp.CampaignId = cam.Id;
            opp.AccountId= h.id;
            opp.Oppty_Related_Contact__c = c.Id;
            opp.RecordTypeId  = RecType[0].Id;
            opp.Gift_Date_Time__c = system.today();
            opp.Campaign_Name__c = 'Events';
            opp.name = 'Test';
            opp.Giving_Amount__c = 123;
            opp.StageName = 'pledged';
            opp.payment_method__c = 'cash';
            opp.gift_kind__c = 'Installment';
            opp.CloseDate=system.today();
        insert opp;    
        
    }
}