public class TaUploadSalutations {
	public static void upload(Map<Id,Salutation__c> oldMap, Salutation__c[] clazzes, Boolean isInsert, Boolean isUpdate) {
	}
    public static testMethod void testTaUploadSalutation() {
    	/** Insert **/
    	Contact contact = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
		   bulk_load__c=true				
    	);
    	insert contact;
    	 
		// Insert       	   	      	   	
		Salutation__c clazz = new Salutation__c(
			contact__c = contact.Id,
			salutation_code__c = '\\D',
			salutation_line_1__c = 'Mr & Mrs Joseph Dirt',
			inside_salutation_1__c = 'Mr. Dirt'		
			);
		insert clazz;
		System.debug(clazz);
		TA_Upload__c[] upload1 = [
			Select Id, SFDC_ID__c, 				
				SALUTATION_CODE_S1__c,
				INSIDE_SALUTATION_S1__c,
				SALUTATION_LINE_1_S1__c,
				SALUTATION_LINE_2_S1__c,
				SALUTATION_LINE_3_S1__c
			From TA_Upload__c
			Where SFDC_ID__c = :clazz.Id AND SFDC_UPDATE_TYPE__c = 'Salutation'
			];
		// Update        
		clazz.inside_salutation_1__c = 'Mrs. Dirt';
		update clazz;
		
		System.debug(clazz);
		TA_Upload__c[] upload2 = [
			Select Id, SFDC_ID__c, 				
				SALUTATION_CODE_S1__c,
				INSIDE_SALUTATION_S1__c,
				SALUTATION_LINE_1_S1__c,
				SALUTATION_LINE_2_S1__c,
				SALUTATION_LINE_3_S1__c
			From TA_Upload__c
			Where SFDC_ID__c = :clazz.Id AND SFDC_UPDATE_TYPE__c = 'Salutation'
			];
	}
}