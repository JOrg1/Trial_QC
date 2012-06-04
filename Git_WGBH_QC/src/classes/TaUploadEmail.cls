public class TaUploadEmail {
	public static void upload(Map<Id,Household__c> oldMap, Household__c[] clazzes, Boolean isInsert, Boolean isUpdate) {
		List<TA_Upload__c> updateList = new List<TA_Upload__c>();
		List<TA_Upload__c> insertList = new List<TA_Upload__c>();
		Set<Id> idSet = null;
		if(oldMap!=null) {
			idSet = oldMap.keySet();
		}
		else {
			idSet = new Set<Id>();
			for(Household__c tmp : clazzes) idSet.add(tmp.Id);
		}		
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>([
			Select 
				ACCOUNT_ID__c,
				NAME_ID_E1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,				
				ID_TYPE__c,	
				EMAIL_ID_E1__c,								
				EMAIL_TYPE_E1__c,
				EMAIL_ADDRESS_E1__c,
				STS_E1__c
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet				 
			]);

		for(Household__c clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(clazz.ta_account_id__c==null) // donot update email if household is not in TA.
				continue; 
			if(oldMap!=null) { // skip if email is not updated.
				Household__c oldClazz = oldMap.get(clazz.Id);
				if(oldClazz.householdEmail__c == clazz.householdEmail__c) {
					continue;
				}
				if(oldClazz.householdEmail__c != null) { // todo: only sending new email, because no ta_email_id defined.
					continue;					
				}					
			} 			
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = String.valueOf(clazz.ta_account_id__c) + '_00_I';
	
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
		            upload.NAME_ID_E1__c = Integer.valueOf(cData[1]);//from key
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key			             		                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = 'I';//from key	        	
		        }
				/**
				 * TA needs Account_type
				 */
				upload.ACCOUNT_TYPE__c='IN';
			}	
            upload.SFDC_ID__c = clazz.Id;
            upload.ALT_ACCOUNT_ID__c = clazz.ID;
            upload.ID_TYPE__c = 'SFDC';				
			/**
			 * Email Fields
			 */
			upload.DO_UPDATES_E1__c	= 'Y';			 
			upload.SFDC_UPDATE_TYPE__c = 'Email';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;				 	            
            upload.EMAIL_TYPE_E1__c = 'EH';
            upload.EMAIL_ADDRESS_E1__c = clazz.householdEmail__c;
            upload.STS_E1__C = 'A';

            if(upload.Id==null) {
				/* Since households/contact/accounts, will iniitally be created in TA this should never be null. */            	
            	if(upload.SFDC_EXTERNAL_ID__c!=null) {
            		System.debug(upload);
            		insertList.add(upload);
            	}
            }
            else {
				/* Since households/contact/accounts, will iniitally be created in TA this should never be null. */               	
            	if(upload.SFDC_EXTERNAL_ID__c!=null) {
            		System.debug(upload);            	
            		updateList.add(upload);    
            	}        	
            }
		}
		if(insertList.size()>0) insert insertList;
		if(updateList.size()>0) update updateList;				
	}
	public static void upload(Map<Id,Contact> oldMap, Contact[] clazzes, Boolean isInsert, Boolean isUpdate) {
		List<TA_Upload__c> updateList = new List<TA_Upload__c>();
		List<TA_Upload__c> insertList = new List<TA_Upload__c>();
		Set<Id> idSet = null;
		if(oldMap!=null) {
			idSet = oldMap.keySet();
		}
		else {
			idSet = new Set<Id>();
			for(Contact tmp : clazzes) idSet.add(tmp.Id);
		}		
		List<TA_Upload__c> existingList = new List<TA_Upload__c>([
			Select 
				ACCOUNT_ID__c,
				NAME_ID_E1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				ID_TYPE__c,
				EMAIL_ID_E1__c,								
				EMAIL_TYPE_E1__c,
				EMAIL_ADDRESS_E1__c,
				STS_E1__c
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Email'					 
			]);
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>();
		for(TA_Upload__c tmp : existingList) {
			existingMap.put(tmp.sfdc_id__c, tmp);
		}

		for(Contact clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(clazz.tacontactid__c==null) // donot update email if household is not in TA.
				continue; 
			if(oldMap!=null) { // skip if email is not updated.
				Contact oldClazz = oldMap.get(clazz.Id);
				if(oldClazz.homeEmail__c == clazz.homeEmail__c && oldClazz.workEmail__c == clazz.workEmail__C) {
					continue;
				}
			} 
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = clazz.tacontactid__c;
	            upload.SFDC_ID__c = clazz.Id;
	            upload.ALT_ACCOUNT_ID__c = clazz.ID;	            
	            upload.ID_TYPE__c = 'SFDC';
	
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
		            upload.NAME_ID_E1__c = Integer.valueOf(cData[1]);//from key
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key			            		            	            
		            upload.SFDC_ACCOUNT_CATEGORY__c = (cData.size()==3) ? cData[2] : 'I';//from key	        	
		        }
				/**
				 * TA needs Account_type
				 */
				if(upload.SFDC_ACCOUNT_CATEGORY__c=='I') upload.ACCOUNT_TYPE__c='IN';
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='C') upload.ACCOUNT_TYPE__c='CO';
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='G') upload.ACCOUNT_TYPE__c='FG';	
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='F') upload.ACCOUNT_TYPE__c='FN';	
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='O') upload.ACCOUNT_TYPE__c='OT';
			}			
			/**
			 * Email Fields
			 */
			upload.SFDC_UPDATE_TYPE__c = 'Email';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;
			upload.DO_UPDATES_E1__c	= 'Y';
			if(isUpdate) {
				Contact oldClazz = oldMap.get(clazz.id);
				if(oldClazz.homeEmail__c != clazz.homeEmail__c)	{
					if(clazz.ta_homeemail_id__c!=null)
						upload.EMAIL_ID_E1__c = pad2string(clazz.ta_homeemail_id__c);
	            	upload.EMAIL_TYPE_E1__c = 'EH';
	            	upload.EMAIL_ADDRESS_E1__c = clazz.homeEmail__c;              	
				}
				else if(oldClazz.workEmail__c != clazz.workEmail__c)	{
					if(clazz.ta_workemail_id__c!=null)
						upload.EMAIL_ID_E1__c = pad2string(clazz.ta_workemail_id__c);					
	            	upload.EMAIL_TYPE_E1__c = 'EW';
	            	upload.EMAIL_ADDRESS_E1__c = clazz.workEmail__c;   			
				}			     
	            upload.STS_E1__C = 'A';
			}
			else { //Insert
				if(clazz.homeEmail__c != null ) { 
	            	upload.EMAIL_TYPE_E1__c = 'EH';
	            	upload.EMAIL_ADDRESS_E1__c = clazz.homeEmail__c;              	
				}
				else if(clazz.workEmail__c != null)	{
	            	upload.EMAIL_TYPE_E1__c = 'EW';
	            	upload.EMAIL_ADDRESS_E1__c = clazz.workEmail__c;   			
				}			     
	            upload.STS_E1__C = 'A';				
			}

            if(upload.Id==null) {
				/* Since households/contact/accounts, will iniitally be created in TA this should never be null. */            	
            	if(upload.SFDC_EXTERNAL_ID__c!=null) {
            		System.debug(upload);
            		insertList.add(upload);
            	}
            }
            else {
				/* Since households/contact/accounts, will iniitally be created in TA this should never be null. */               	
            	if(upload.SFDC_EXTERNAL_ID__c!=null) {
            		System.debug(upload);            	
            		updateList.add(upload);    
            	}        	
            }
		}
		try {
			if(insertList.size()>0) insert insertList;
		}
		catch (Exception ex) { /* todo: do something */ }	
		try {		
			if(updateList.size()>0) update updateList;	
		}
		catch (Exception ex) { /* todo: do something */ }				
	}
    public static testMethod void testHOuseholdTaUploadEmail() {
    	/** Insert **/
    	Household__c household = new Household__c(
    	   Name = 'Mr. & Mrs. Joe Dirt', 
    	   Ta_Account_Id__c = 23456
    	);  
    	insert household;      	   	
		household.HouseholdEmail__c = 'fred@roundcorner.com';
		update household;
		System.debug(household);
		
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, EMAIL_ADDRESS_E1__c, EMAIL_ADDRESS_E2__c
			From TA_Upload__c
			Where SFDC_ID__c = :household.Id AND SFDC_UPDATE_TYPE__c = 'Email'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].EMAIL_ADDRESS_E1__c,'fred@roundcorner.com');	
	}	
    public static testMethod void testContactTaUploadEmail() {
    	/** Insert **/
    	Contact contact = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I'
    	);
    	insert contact;      	   	
		contact.Preferred_Email__c = 'Work';
		contact.WorkEmail__c = 'fred@work.com';
		update contact;		
		System.debug(contact);		
        		
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, EMAIL_ADDRESS_E1__c, EMAIL_ADDRESS_E2__c
			From TA_Upload__c
			Where SFDC_ID__c = :contact.Id  AND SFDC_UPDATE_TYPE__c = 'Email'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].EMAIL_ADDRESS_E1__c,'fred@work.com');        	
	}
	
	private static String pad2string(Decimal num) {
		if(num==null) return null;
		Integer intnum = num.intValue();
		String strnum = String.valueOf(intnum);
		return (strnum.length()==1) ? '0' + strnum : strnum; 
	}												
}