@isTest
private class TesttrgCaseAfterInsert{
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
        
        Program__c prg = new Program__c();
            prg.name = 'test show';
            prg.Series__c = true;
        insert prg;       
       
        Case case1 = new Case();  
            case1.program__c = prg.Id;    
            case1.ta_interactions_Id__c = '23456_01_I_SO_BAR';
            case1.Origin='Email';
            case1.Station__c='WGBH';
            case1.Type='Jazz';
            case1.Status='Open';
            case1.ContactId = c.id;
            case1.AccountID = h.Id;
            case1.contact_date__c=System.today();
        insert case1;
    }
}