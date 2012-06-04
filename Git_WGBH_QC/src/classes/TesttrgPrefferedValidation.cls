@IsTest
private class TesttrgPrefferedValidation {
    public static testmethod void TesttrgPrefferedValidation (){
        Test.startTest();
        
        Account acc = new Account();
        acc.Name= 'Test';
        insert acc;
        
        Address__c adr = new Address__c();
            adr.Name = '123, Test, Test - 123765';
            adr.Address_Type__c = 'Billing';
            adr.PreferredAddress__c = true;
            adr.Account_Household__c = acc.id;
        insert adr; 
      
      /*  List<Address__c> lstA = new List<Address__c>();
        lstA = [Select ID,Name,Address_Type__c,PreferredAddress__c from Address__c 
            Where ID !=: adr.Id AND Account_Household__c =: adr.Account_Household__c AND PreferredAddress__c = true AND Address_Type__c = 'Billing'];*/
            
        Address__c adr1 = new Address__c();
        adr1.Name = '123 Test, XYZ, PQR - 124569';
        adr1.Address_Type__c = 'Shipping';
        adr1.PreferredAddress__c = true;
        adr1.Account_Household__c = acc.id;
        insert adr1;
         
        /*List<Address__c> lstA1 = new List<Address__c>();
        lstA = [Select ID,Name,Address_Type__c,PreferredAddress__c from Address__c 
            Where ID !=: adr1.Id AND Account_Household__c =: adr1.Account_Household__c AND PreferredAddress__c = true AND Address_Type__c = 'Shipping'];*/
       
        Address__c adr2 = new Address__c();
        adr2.Name = '123 Test, XYZ, PQR - 124569';
        adr2.Address_Type__c = 'Shipping';
        adr2.PreferredAddress__c = true;
        adr2.Account_Household__c = acc.id;
        insert adr2;
        
        Address__c adr3 = new Address__c();
        adr3.Name = '123 Test, XYZ, PQR - 124569';
        adr3.Address_Type__c = 'Billing';
        adr3.PreferredAddress__c = true;
        adr3.Account_Household__c = acc.id;
        insert adr3;
        
        Test.stopTest();
    }
}