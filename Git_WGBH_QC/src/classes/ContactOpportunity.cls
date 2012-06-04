public class ContactOpportunity {
    //public ContactOpportunity(){}
    
    public ContactOpportunity (Opportunity[] opportunities){
        //Primary Donor
        String primaryDonorContactRole = system.label.Primary_Donor_Contact_Role;//Donor
        Opportunity newOpportunity = opportunities[0];
        Contact oppContact = [Select c.id, c.FirstName, c.Account_Household__c from Contact c where c.Id = :newOpportunity.Oppty_Related_Contact__c];
        newOpportunity.AccountID = oppContact.Account_Household__c;

/*      OpportunityContactRole thisRole = new OpportunityContactRole();
        thisRole.OpportunityId = newOpportunity.Id;
        thisRole.ContactId = oppContact.Id;
        thisRole.Role = primaryDonorContactRole;
        thisRole.isPrimary = true;
        
        insert thisRole;
*/      
    }
    static testMethod void TestContactOpportunity () {
       Test.startTest();
        Account a = new Account(Name = 'Test Account');
        Contact ct = new Contact(LastName = 'Test Contact',Account_Household__c = a.Id);
        insert ct;
        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Pledge';
        o.CloseDate = system.today().addDays(10);
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 15;
        o.Oppty_Related_Contact__c = ct.Id;
        insert o;
        
        Opportunity[] opportunities = new Opportunity[0];
        opportunities.add(o);
        ContactOpportunity  co= new ContactOpportunity(opportunities);
        //ContactOpportunity.ContactOpportunity(opportunities);
       Test.StopTest();  
    }   

}