public class TestBequestContactRole {
    public static testMethod void testContactRole() {	
    	Contact c2 = new Contact(
    	   FirstName = 'Jane', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_C',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);
    	insert c2;      	 	
    	Account a = new Account(
    	   Name = 'Joe Dirt and Co', 
    	   TaAccountId__c = 23456,
    	   bulk_load__c = true
    	); 
    	insert a; 
    	BequestContactRole__c bcr = new BequestContactRole__c(Role__c = 'Trustee', Contact__c = c2.id);
    	insert bcr; 
    }	 
}