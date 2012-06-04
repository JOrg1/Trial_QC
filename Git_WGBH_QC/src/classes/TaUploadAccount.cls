public class TaUploadAccount {
	public static void upload(Map<Id,Account> oldMap, Account[] clazzes, Boolean isInsert, Boolean isUpdate) {
		List<TA_Upload__c> updateList = new List<TA_Upload__c>();
		List<TA_Upload__c> insertList = new List<TA_Upload__c>();
		Set<Id> idSet = null;
		if(oldMap!=null) {
			idSet = oldMap.keySet();
		}
		else {
			idSet = new Set<Id>();
			for(Account tmp : clazzes) idSet.add(tmp.Id);
		}		
		List<TA_Upload__c> existingList = new List<TA_Upload__c>([
			Select 
				ACCOUNT_ID__c,
				NAME_ID_S1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,
				ID_TYPE__c,
		
				LAST_NAME_0__c
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Account'					 
			]);
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>();
		for(TA_Upload__c tmp : existingList) {
			existingMap.put(tmp.sfdc_id__c, tmp);
		}
			

		for(Account clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = (clazz.taaccountid__c == null) ? null : String.valueOf(clazz.taaccountid__c.intValue());
	            upload.SFDC_ID__c = clazz.Id;
	            upload.ALT_ACCOUNT_ID__c = clazz.Id;	            
	            upload.ID_TYPE__c = 'SFDC';
	
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {                    	            
		            upload.ACCOUNT_ID__c = clazz.taaccountid__c; //from key
					upload.NAME_ID_0__c = 0;//from key		 		            	                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = (clazz.AccountCategoryValue__c==null) ? 'C' : clazz.AccountCategoryValue__c;  	
		        }
				/**
				 * TA needs Account_type
				 */
				if(upload.SFDC_ACCOUNT_CATEGORY__c=='C') upload.ACCOUNT_TYPE__c='CO';
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='G') upload.ACCOUNT_TYPE__c='FG';	
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='F') upload.ACCOUNT_TYPE__c='FN';	
				else if(upload.SFDC_ACCOUNT_CATEGORY__c=='O') upload.ACCOUNT_TYPE__c='OT';
			}	
			/**
			 * Check for valid Account changes
			 */
			 if(isUpdate) {
			 	Account oldClazz = oldMap.get(clazz.id);
			 	if( oldClazz.name == clazz.name)	
			 		continue;	
			 }															
			/**
			 * Account Fields
			 */	
			upload.SFDC_UPDATE_TYPE__c = 'Account';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;
			upload.DO_UPDATES_N0__c	= 'Y';					            
			upload.LAST_NAME_0__c = clazz.Name;            
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
    public static testMethod void testTaUploadAccount() {
		Account clazz = new Account(
			Name = 'Mr & Mrs Joseph Dirt',
			taaccountid__c = 12345,
			bulk_load__c=true				
			);
		insert clazz;
		clazz.bulk_load__c = false;
		update clazz;
		clazz.Name = 'Mr. Joe Dirt';
		update clazz;
		System.debug(clazz);
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, 				
				LAST_NAME_0__c
			From TA_Upload__c
			Where SFDC_ID__c = :clazz.Id AND SFDC_UPDATE_TYPE__c = 'Account'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].last_name_0__c,'Mr. Joe Dirt');
	}
}