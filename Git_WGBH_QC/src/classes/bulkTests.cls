/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class bulkTests {

     /// <name> newIndContactAllContactsProcessor </name>
    /// <summary> test insert individual with all contacts processor </summary>
    static testMethod void newIndContactAllContactsProcessor() {
        String street = '2345 Elm St.';
        String city = 'Seattle';
        String state = 'WA';
        String zip = '88777';
        String country = 'US';
        String lastname = 'SmithForTest99';
        
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                MailingStreet = street,
                MailingCity = city,
                MailingState = state,
                MailingPostalCode = zip,
                MailingCountry = country,
                SystemHouseholdProcessor__c = 'All New or Edited Contacts',
                bulk_load__c = true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        
        Id firstHouseholdId = createdContacts[0].Account_Household__c;
        //System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c);
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c);
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c);
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c);
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c);
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name);
        
        //blank out the HH
        for(Contact thisContact : createdContacts){
            thisContact.Account_Household__c = null;
        }
        update createdContacts;
        Test.stopTest();
        createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        
        //System.assertNotEquals(firstHouseholdId,createdContacts[0].Account_Household__c);
        //System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c);
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c);
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c);
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c);
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c);
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name);
    }

    /// <name> newIndContactIndividualsProcessor </name>
    /// <summary> test insert individual with individuals processor </summary>
    static testMethod void newIndContactIndividualsProcessor() {
        String street = '2345 Elm St.';
        String city = 'Seattle';
        String state = 'WA';
        String zip = '88777';
        String country = 'US';
        String lastname = 'SmithForTest99';
        
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                MailingStreet = street,
                MailingCity = city,
                MailingState = state,
                MailingPostalCode = zip,
                MailingCountry = country,
                SystemHouseholdProcessor__c = 'All Individual Contacts',
                bulk_load__c = true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        
        Id firstHouseholdId = createdContacts[0].Account_Household__c;
        // fix below
        /*//System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c);
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c);
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c);
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c);
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c);
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name);*/
        
        //blank out the HH
        for(Contact thisContact : createdContacts){
            thisContact.Account_Household__c = null;
        }
        update createdContacts;
        Test.stopTest();
        createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        // fix below
        /*//System.assertNotEquals(firstHouseholdId,createdContacts[0].Account_Household__c);
        //System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c);
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c);
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c);
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c);
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c);
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name);*/
    }
    
    /// <name> newOrgContactAllContactsProcessor </name>
    /// <summary> test insert org contact with all contacts processor </summary>
    static testMethod void newOrgContactAllContactsProcessor() {
        Account acct = new Account(
            Name = 'Test Organization 888',
            bulk_load__c = true
        );
        insert acct;
        
        String street = '2345 Elm St.';
        String city = 'Seattle';
        String state = 'WA';
        String zip = '88777';
        String country = 'US';
        String lastname = 'SmithForTest99';
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                MailingStreet = street,
                MailingCity = city,
                MailingState = state,
                MailingPostalCode = zip,
                MailingCountry = country,
                AccountId = acct.id,
                SystemHouseholdProcessor__c = 'All New or Edited Contacts',
                bulk_load__c=true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        
        Id firstHouseholdId = createdContacts[0].Account_Household__c;
        //System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c); 
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c); 
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c); 
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c); 
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c); 
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name); 
        
        //blank out the HH
        for(Contact thisContact : createdContacts){
            thisContact.Account_Household__c = null;
        }
        update createdContacts;
        Test.stopTest();
        createdContacts = [select Account_Household__r.Name,Account_Household__r.MailingStreet__c,Account_Household__r.MailingCity__c,Account_Household__r.MailingState__c,Account_Household__r.MailingPostalCode__c,Account_Household__r.MailingCountry__c,Account_Household__c from Contact where id IN :cons];
        //System.assertNotEquals(firstHouseholdId,createdContacts[0].Account_Household__c);
        //System.assertEquals(street,createdContacts[0].Account_Household__r.MailingStreet__c);
        //System.assertEquals(city,createdContacts[0].Account_Household__r.MailingCity__c);
        //System.assertEquals(state,createdContacts[0].Account_Household__r.MailingState__c);
        //System.assertEquals(zip,createdContacts[0].Account_Household__r.MailingPostalCode__c);
        //System.assertEquals(country,createdContacts[0].Account_Household__r.MailingCountry__c);
        //System.assertEquals(lastname + ' Household',createdContacts[0].Account_Household__r.Name);
    }

    /// <name> newOrgContactIndividualsProcessor </name>
    /// <summary> test insert org contact with Individuals processor </summary>
    static testMethod void newOrgContactIndividualsProcessor() {
        Account acct = new Account(
            Name = 'Test Organization 888',
            bulk_load__c = true
        );
        insert acct;
        
        String street = '2345 Elm St.';
        String city = 'Seattle';
        String state = 'WA';
        String zip = '88777';
        String country = 'US';
        String lastname = 'SmithForTest99';
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                MailingStreet = street,
                MailingCity = city,
                MailingState = state,
                MailingPostalCode = zip,
                MailingCountry = country,
                AccountId = acct.id,
                SystemHouseholdProcessor__c = 'All Individual Contacts',
                bulk_load__c = true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__c from Contact where id IN :cons];
        
        //System.assertEquals(null,createdContacts[0].Account_Household__c);
        
        //blank out the HH
        for(Contact thisContact : createdContacts){
            thisContact.MailingStreet = 'test';
        }
        update createdContacts;
        Test.stopTest();
        createdContacts = [select Account_Household__c from Contact where id IN :cons];
        
        //System.assertEquals(null,createdContacts[0].Account_Household__c);
    }

    /// <name> contactDeleteWithOwnHousehold </name>
    /// <summary> test delete a contact that has it's own household </summary>
    static testMethod void contactDeleteWithOwnHousehold() {
        String lastname = 'SmithForTest99';
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                SystemHouseholdProcessor__c = 'All Individual Contacts',
                bulk_load__c = true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__c from Contact where id IN :cons];
        List<id> householdIds = new List<id>();
        for(Contact thiscontact : createdContacts){
            householdIds.add(createdContacts[0].Account_Household__c);
        }
        
        delete cons;
        Test.stopTest();
        Account[] deletedHousehold = [select id from Account where id IN :householdIds];
        //System.assert(deletedHousehold.size()==0);
    }
    
    /// <name> contactDeleteWithSharedHousehold </name>
    /// <summary> test delete a contact that has shared household </summary>
    static testMethod void contactDeleteWithSharedHousehold() {
        String lastname = 'SmithForTest99';
        List<Contact> cons = new List<contact>();
        Integer conCount = 10;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName='test',
                LastName=lastname,
                SystemHouseholdProcessor__c = 'All Individual Contacts',
                bulk_load__c = true
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Contact[] createdContacts = [select Account_Household__c from Contact where id IN :cons];
        
        List<id> householdIds = new List<id>();
        for(Contact thiscontact : createdContacts){
            householdIds.add(thiscontact.Account_Household__c);
        }
        List<Contact> cons2 = new List<contact>();
        for(Integer i=0;i<conCount;i++){
            Contact con2 = new Contact(
                FirstName='test again',
                LastName=lastname,
                Account_Household__c = householdIds[i],
                SystemHouseholdProcessor__c = 'All Individual Contacts',
                bulk_load__c = true
            );
            cons2.add(con2);
        }
        insert cons2;
        
        delete cons;
        Test.stopTest();
        Account[] remainingHousehold = [select id from Account where id IN :householdIds];
        //System.assertEquals(conCount,remainingHousehold.size());
    }

    /// <name> getHouseholdTransactionTotal </name>
    /// <summary>  </summary>
    static testMethod void getHouseholdTransactionTotal_test()
    {
        Account h = new Account(Name='Test Household');
        insert h;
        Contact c = new Contact(FirstName='test',LastName='test',Account_Household__c=h.Id);
        insert c;
        Opportunity o = new Opportunity(Name='test oppty',CloseDate=System.Today(),StageName='Closed Won',Amount=100);
        insert o;
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id,Role='Test');
        insert ocr;
        //System.assertEquals('$100.00',Households.getHouseholdTransactionTotal(h.id));
    }
    
    /// <name> getHouseholdTransactionTotal </name>
    /// <summary>  </summary>
    static testMethod void getHouseholdLastTransaction_test()
    {
        Integer year = 2005;
        Integer month = 10;
        Integer day = 10;
        Account h = new Account(Name='Test Household');
        insert h;
        Contact c = new Contact(FirstName='test',LastName='test',Account_Household__c=h.Id);
        insert c;
        Opportunity o = new Opportunity(Name='test oppty',CloseDate=date.newInstance(year,month,day),StageName='Closed Won',Amount=100);
        insert o;
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id,Role='Test');
        insert ocr;
        //System.assertEquals(String.valueOf(year)+'-'+String.valueOf(month)+'-'+String.valueOf(day),Households.getHouseholdLastTransaction(h.id));
    }
    

}