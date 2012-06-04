public class TaUploadContact {
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
				NAME_ID_1N__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,
				ID_TYPE__c,
		
				DO_UPDATES_N1__c,
				TITLE_1N__c,
				FIRST_NAME_1N__c,
				MIDDLE_NAME_1N__c,
				LAST_NAME_1N__c,
				SUFFIX_1N__c,
				GENDER_1N__c,
				DECEASED_FLAG_1N__c
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Contact'					 
			]);
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>();
		for(TA_Upload__c tmp : existingList) {
			existingMap.put(tmp.sfdc_id__c, tmp);
		}
			

		for(Contact clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = String.valueOf(clazz.tacontactid__c);
	            upload.SFDC_ID__c = clazz.Id;
  				upload.ALT_ACCOUNT_ID__c = clazz.Id;	 	            
	            upload.ID_TYPE__c = 'SFDC';
	
				/**
				 * This logic handle insert
				 */  
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
		            upload.NAME_ID_1N__c = cData[1];//from key	
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key		                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = (cData.size()<3) ? 'I' : cData[2]; //bad data hack        	
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
			 * Check for valid Contact changes
			 */
			 if(isUpdate) {
			 	Contact oldClazz = oldMap.get(clazz.id);
			 	if( 
					// oldClazz.TITLE == clazz.TITLE &&
					oldClazz.FIRSTNAME == clazz.FIRSTNAME &&
					oldClazz.middle_name__c == clazz.middle_name__c &&					
					oldClazz.LASTNAME == clazz.LASTNAME &&
					oldClazz.SUFFIX__c == clazz.SUFFIX__c &&
					oldClazz.GENDER__c == clazz.GENDER__c &&
					oldClazz.DECEASED_FLAG__c == clazz.DECEASED_FLAG__c
					)	 		
			 		continue;	
			 }															
			/**
			 * Contact Fields
			 */	
			upload.SFDC_UPDATE_TYPE__c = 'Contact';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;
			upload.DO_UPDATES_N1__c	= 'Y';		
			
			//MR fix upload.TITLE_1N__c = clazz.Salutation;
			upload.FIRST_NAME_1N__c = clazz.FirstName;
			upload.MIDDLE_NAME_1N__c = clazz.middle_name__c;			
			upload.LAST_NAME_1N__c = clazz.LastName; 
			upload.SUFFIX_1N__c =  clazz.suffix__c;
			upload.GENDER_1N__c =  clazz.gender_value__c;
			upload.DECEASED_FLAG_1N__c = (clazz.deceased_flag__c == true) ? 'Y' : 'N'; 			
								                     
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
    public static testMethod void testTaUploadContact() {
		Contact clazz = new Contact(
			FirstName = 'Joseph',
			LastName = 'Dirt',
			tacontactid__c = '12345_01_I',
			bulk_load__c=true				
			);
		insert clazz;
		clazz.bulk_load__c = false;
		update clazz;
		clazz.FirstName = 'Joe';
		update clazz;
		System.debug(clazz);
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, 				
				DO_UPDATES_N1__c,
				TITLE_1N__c,
				FIRST_NAME_1N__c,
				MIDDLE_NAME_1N__c,				
				LAST_NAME_1N__c,
				SUFFIX_1N__c,
				GENDER_1N__c,
				DECEASED_FLAG_1N__c
			From TA_Upload__c
			Where SFDC_ID__c = :clazz.Id AND SFDC_UPDATE_TYPE__c = 'Contact'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].FIRST_NAME_1N__c,'Joe');
	}
}