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
private class TestHouseHoldOpportunity {

  /*  static testMethod void myUnitTest() {
        // TO DO: implement unit test
    }*/
    
    static testMethod void TA_houseHoldOpportunityTest(){
        //Create primary contact for the household
        Contact c1 = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I'
        );
        insert c1;
        
       //Create non-primary contact for the household
       Contact c2 = new Contact(
           FirstName = 'Fred', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_02_I'
        );
        insert c2;

        //Create Opportunity for the household
        Opportunity o1 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Contact Opporutnity',
           CloseDate = Date.today(),
           StageName = 'Cultivation',
           gift_date__c = Date.today()
        );
        insert o1;

        //After Insert trigger on Opportunity on Household will create OpportunityContactRole records for each Contact on Household.
        List<OpportunityContactRole> ocr1 = [Select o.Role, o.OpportunityId, o.IsPrimary, o.Id, o.ContactId From OpportunityContactRole o where o.OpportunityId= :o1.id ];

        Test.startTest();
        //Two Contacts on Household, two records in OpportunityContactRole
  		//system.assertEquals(2,ocr1.size()); 
  		//system.assertEquals('Donor',ocr1[0].Role); 
  		//system.assert(ocr1[0].IsPrimary); 
  		//system.assertEquals('Household Credit',ocr1[1].Role); 
        
        Test.stopTest();
        
//    	Database.rollback(sp);
    }
    static testMethod void New_houseHoldOpportunityTest(){
//    	Savepoint sp = Database.setSavepoint();

        //Create primary contact for the household
        Contact c1 = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt' 
        );
        insert c1;
        
       //Create non-primary contact for the household
       Contact c2 = new Contact(
           FirstName = 'Fred', 
           LastName = 'Dirt'
        );
        insert c2;

        //Create Opportunity for the household
        Opportunity o1 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Contact Opporutnity',
           CloseDate = Date.today(),
           StageName = 'Cultivation',
           gift_date__c = Date.today()
        );
        insert o1;

        //After Insert trigger on Opportunity on Household will create OpportunityContactRole records for each Contact on Household.
        List<OpportunityContactRole> ocr1 = [Select o.Role, o.OpportunityId, o.IsPrimary, o.Id, o.ContactId From OpportunityContactRole o where o.OpportunityId= :o1.id ];

        Test.startTest();
        //Two Contacts on Household, two records in OpportunityContactRole
 		//system.assertEquals(2,ocr1.size()); 
  		//system.assertEquals('Donor',ocr1[0].Role); 
  		//system.assert(ocr1[0].IsPrimary); 
  		//system.assertEquals('Household Credit',ocr1[1].Role); 

        Test.stopTest();
        
//    	Database.rollback(sp);
    }
    
}