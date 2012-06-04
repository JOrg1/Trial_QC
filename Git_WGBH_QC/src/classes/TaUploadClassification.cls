public class TaUploadClassification {
	public static void upload(Map<Id,Classification__c> oldMap, Classification__c[] clazzes, Boolean isInsert, Boolean isUpdate) {
		List<TA_Upload__c> updateList = new List<TA_Upload__c>();
		List<TA_Upload__c> insertList = new List<TA_Upload__c>();
		Set<Id> idSet = null;
		if(oldMap!=null) {
			idSet = oldMap.keySet();
		}
		else {
			idSet = new Set<Id>();
			for(Classification__c tmp : clazzes) idSet.add(tmp.Id);
		}		
		List<TA_Upload__c> existingList = new List<TA_Upload__c>([
			Select 
				ACCOUNT_ID__c,
				NAME_ID_C1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,
				ID_TYPE__c,
				CLASSIFICATION_CODE_C1__c,
				CLASSIFICATON_VALUE_C1__c,
				END_DATE_c1__c,
				START_DATE_c1__c,
				STS_C1__c
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Classification'					 
			]);
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>();
		for(TA_Upload__c tmp : existingList) {
			existingMap.put(tmp.sfdc_id__c, tmp);
		}
			

		for(Classification__c clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = clazz.ta_classification_id__c;
	            upload.SFDC_ID__c = clazz.Id;
	            upload.ID_TYPE__c = 'SFDC';
	
				/**
				 * This logic handle insert
				 */
				if(upload.SFDC_EXTERNAL_ID__c==null) {
					if(clazz.Household__c!=null) {						
						Double ta_account_id = [select ta_account_id__c from Household__c where id = :clazz.Household__c][0].ta_account_id__c;
						if(ta_account_id != null)
							upload.SFDC_EXTERNAL_ID__c = String.valueOf(ta_account_id.intValue()) + '_00_I';
					}
					else if(clazz.Organization__c!=null) {	 						
						Double ta_account_id = [select ta_account_id__c from Account where id = :clazz.Organization__c][0].taaccountid__c;
						if(ta_account_id != null)						
							upload.SFDC_EXTERNAL_ID__c = String.valueOf(ta_account_id.intValue()) + '_00_C';
					}
					else if(clazz.Contact__c!=null) { 												
						upload.SFDC_EXTERNAL_ID__c = [select tacontactid__c from Contact where id = :clazz.Contact__c][0].tacontactid__c;
						
					}								
				}            
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
		            upload.NAME_ID_C1__c = Integer.valueOf(cData[1]);//from key	
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key		                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = (cData.size()<3) ? 'I' : cData[2]; //bad data hack        	
		        }
		        /**
		         * Set ALT_ACCOUNT_ID
		         */
				if(clazz.Household__c!=null) {
      				upload.ALT_ACCOUNT_ID__c = clazz.Household__c;	
					}
				else if(clazz.Organization__c!=null) {
      				upload.ALT_ACCOUNT_ID__c = clazz.Organization__c;
				}
				else if(clazz.Contact__c!=null) {
      				upload.ALT_ACCOUNT_ID__c = clazz.Contact__c;	 
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
			 * Check for valid Classification changes
			 */
			 if(isUpdate) {
			 	Classification__C oldClazz = oldMap.get(clazz.id);
			 	if(oldClazz.end_date__c == clazz.end_date__c)
			 		continue;	
			 }															
			/**
			 * Classification Fields
			 */	
			upload.SFDC_UPDATE_TYPE__c = 'Classification';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;
			upload.RECORD_SEQ__c = clazz.record_seq__c;
			upload.DO_UPDATES_C1__c	= 'Y';		            
            upload.CLASSIFICATION_CODE_C1__c = clazz.classification_code__c;
            upload.CLASSIFICATON_VALUE_C1__c = clazz.classification_value__c;	            
            upload.END_DATE_c1__c = (clazz.end_date__c == null) ? null : Datetime.newInstance(clazz.end_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd');
            upload.START_DATE_c1__c = (clazz.start_date__c == null) ? null : Datetime.newInstance(clazz.start_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd');
            upload.STS_C1__c = (clazz.active__c) ? 'A' : 'I';
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
    public static testMethod void testTaUploadClassification() {
    	/** Insert **/
    	insert new Household__c(ta_account_id__c=1); // RLH - added to prevent test failure
    	
    	Household__c household = [Select id From Household__c where ta_account_id__c != null LIMIT 1];
		Classification__c clazz = new Classification__c(
			classification_code__c = 'EMAIL',
			classification_value__c = 'H ALL',
			start_date__c = System.today()						
			);
		clazz.Household__c = household.Id;
		insert clazz;
		System.debug(clazz);
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, CLASSIFICATION_CODE_C1__c, CLASSIFICATON_VALUE_C1__c, START_DATE_c1__c, STS_C1__c
			From TA_Upload__c
			Where SFDC_ID__c = :clazz.Id AND SFDC_UPDATE_TYPE__c = 'Classification'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].CLASSIFICATION_CODE_C1__c,'EMAIL');
        //System.AssertEquals(upload[0].START_DATE_c1__c,Datetime.newInstance(System.today(),Time.newInstance(0,0,0,0)).format('yyyyMMdd'));
        /** Update existing **/
        //System.AssertEquals(upload.size(),1);	         	
	}
}