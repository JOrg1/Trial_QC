public class TaUploadInteraction {
	public static void upload(Map<Id,Case> oldMap, Case[] clazzes, Boolean isInsert, Boolean isUpdate) {
		List<TA_Upload__c> updateList = new List<TA_Upload__c>();
		List<TA_Upload__c> insertList = new List<TA_Upload__c>();
		Set<Id> idSet = null;
		if(oldMap!=null) {
			idSet = oldMap.keySet();
		}
		else {
			idSet = new Set<Id>();
			for(Case tmp : clazzes) idSet.add(tmp.Id);
		}		
		List<TA_Upload__c> existingList = new List<TA_Upload__c>([
			Select 
				ACCOUNT_ID__c,
				NAME_ID_I1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ALT_ACCOUNT_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,
				ID_TYPE__c,	
							
	            SUMMARY_I1__c,
	            LONG_COMMENTS_I1__c,
	            RESPONSE_CATEGORY_I1__c,
	            RESPONSE_TYPE_I1__c,
	            RESPONSE_DATE_I1__c,
	            PROGRAM_I1__c,
	            TECHNIQUE_I1__c,
	            WARNING_I1__c,
	            WARN_EXPIRE_DATE_I1__c,
	            STS_I1__c       				
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Interaction'					 
			]);
		Map<Id,TA_Upload__c> existingMap = new Map<Id,TA_Upload__c>();
		for(TA_Upload__c tmp : existingList) {
			existingMap.put(tmp.sfdc_id__c, tmp);
		}
			
		for(Case clazz : clazzes) {
			if(clazz.ta_interactions_id__c != null) {
				continue; // Only send new interactions
			}
			if(	clazz.type == null || // Only send Cases with complete Type/Topic/SubTopic values.
				clazz.case_topic__c == null ||
				clazz.case_sub_topic__c == null ) {
				continue;	
			}
  			
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(upload==null) {
				upload = new TA_Upload__c();
				/**
				 * Filter
				 */
				if(clazz.Type == 'Program') {
					upload.CONTACT_CATEGORY_I1__c = 'HP';	
				}
				else if(clazz.Type == 'Membership') {
					upload.CONTACT_CATEGORY_I1__c = 'HM';					
				}
				else if(clazz.Type == 'Station') {
					upload.CONTACT_CATEGORY_I1__c = 'HS';					
				}
				else if(clazz.Type == 'Major Gifts') {
					upload.CONTACT_CATEGORY_I1__c = 'HD';					
				}
				else if(clazz.Type == 'Member Discount Partners') {
					upload.CONTACT_CATEGORY_I1__c = 'MP';					
				}
				else if(clazz.Type == 'Gift Processing') {
					upload.CONTACT_CATEGORY_I1__c = 'GP';					
				}		
				else if(clazz.Type == 'PBSd') {
					upload.CONTACT_CATEGORY_I1__c = 'SA';					
				}								
				else {
					continue; // only send these types.
				}
				/**
				* Handle Station
				*/
				if(clazz.Station__c=='WCAI') {
					upload.CONTACT_CATEGORY_I1__c = upload.CONTACT_CATEGORY_I1__c.replaceAll('H','I');	
				}											
				if(clazz.Station__c=='WGBY') {
					upload.CONTACT_CATEGORY_I1__c = upload.CONTACT_CATEGORY_I1__c.replaceAll('H','Y');	
				}											
				if(clazz.Station__c=='Academy of Music') {
					upload.CONTACT_CATEGORY_I1__c = upload.CONTACT_CATEGORY_I1__c.replaceAll('H','M');	
				}											
				if(clazz.Station__c=='WCRB') {
					upload.CONTACT_CATEGORY_I1__c = upload.CONTACT_CATEGORY_I1__c.replaceAll('H','R');	
				}											
				if(clazz.Station__c=='National Programming') {
					upload.CONTACT_CATEGORY_I1__c = upload.CONTACT_CATEGORY_I1__c.replaceAll('H','N');	
				}											
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = clazz.ta_interactions_id__c;
	            upload.SFDC_ID__c = clazz.Id;
	            upload.ID_TYPE__c = 'SFDC';
	
				/**
				 * This logic handle insert
				 */
				if(upload.SFDC_EXTERNAL_ID__c==null) {
					if(clazz.AccountId!=null) {					
						Double ta_account_id = [select taaccountid__c from Account where id = : clazz.AccountId][0].taaccountid__c;
						if(ta_account_id != null)						
							upload.SFDC_EXTERNAL_ID__c = String.valueOf(ta_account_id.intValue()) + '_00_C';
					}
					else if(clazz.ContactId!=null) {												
						upload.SFDC_EXTERNAL_ID__c = [select tacontactid__c from Contact where id = :clazz.ContactId][0].tacontactid__c;
						
					}								
				}            
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
		            upload.NAME_ID_I1__c = cData[1];//from key	
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key			                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = cData[2]; 
		            /*
		             * Process Interaction Updates
		             */
		            if(cData.size()>3) { // Non-Insert
			            if(cData[3] == 'BE' || cData[3] == 'SO' || cData[3] == 'CU') { // skip most-recent.
			            	continue;
			            } 
			            upload.CONTACT_TYPE_I1__c = cData[4];
			            String[] dataTokens = cData[5].split('-'); //MM-DD-YYYY
			            upload.CONTACT_DATE_I1__c = dataTokens[2] + dataTokens[0] +	dataTokens[1];
		            }
		            else { // Insert
		            	// todo: backward mapping for Category/Type	
			            upload.CONTACT_DATE_I1__c = (clazz.contact_date__c == null) ? null : Datetime.newInstance(clazz.contact_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd');      		            
		            	upload.CONTACT_TYPE_I1__c = 'SFDC';
		            	upload.SFDC_CASE_TYPE__c = clazz.type;
		            	upload.SFDC_CASE_TOPIC__c = clazz.case_topic__c;
		            	upload.SFDC_CASE_SUBTOPIC__c = clazz.case_sub_topic__c;		            			            			                        	
		            }
		        }
		        /**
		         * Set ALT_ACCOUNT_ID
		         */
				if(clazz.AccountId!=null) {
      				upload.ALT_ACCOUNT_ID__c = clazz.AccountId;
				}
				else if(clazz.ContactId!=null) {
      				upload.ALT_ACCOUNT_ID__c = clazz.ContactId;	 
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
			 * Classification Fields
			 */	
			upload.SFDC_UPDATE_TYPE__c = 'Interaction';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;	
			//todo? upload.DO_UPDATES_I1__c	= 'Y';			

            upload.CONTACT_DATE_I1__c = (clazz.contact_date__c == null) ? null : Datetime.newInstance(clazz.contact_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd'); 
            upload.SUMMARY_I1__c = (clazz.summary__c == null ) ? clazz.subject : clazz.summary__c;
            upload.LONG_COMMENTS_I1__c = clazz.description;
            upload.RESPONSE_CATEGORY_I1__c = clazz.response_category__c;
            upload.RESPONSE_TYPE_I1__c = clazz.response_type__c;
            upload.RESPONSE_DATE_I1__c = (clazz.response_date__c == null) ? null : Datetime.newInstance(clazz.response_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd'); 
            upload.PROGRAM_I1__c = clazz.program_code__c;
            upload.TECHNIQUE_I1__c = clazz.technique_value__c;
            upload.WARNING_I1__c = clazz.warning__c;
            upload.WARN_EXPIRE_DATE_I1__c = (clazz.warn_expire_date__c == null) ? null : Datetime.newInstance(clazz.warn_expire_date__c,Time.newInstance(0,0,0,0)).format('yyyyMMdd');  
            upload.STS_I1__c = 'C';
            upload.staff_i1__c = [select employeenumber from user where id = :clazz.CreatedById limit 1].employeenumber;
            
            if(upload.Id==null) {
				/* Donot add Interaction to from new household, contact, account */            	
            	if(upload.SFDC_EXTERNAL_ID__c!=null) {
            		System.debug(upload);
            		insertList.add(upload);
            	}
            }
            else {
				/* Donot add Interaction to from new household, contact, account */                  	
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
    public static testMethod void testTaUploadInteractionInsert() {
	   	Contact c = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
    	   bulk_load__c = true    	   
    	);
    	insert c;   

	   	Case case1 = new Case(
	   	   Summary__c = 'Joe has a problem.',
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Station',
    	   case_topic__c='Transfer',
    	   case_sub_topic__c='External',    	   
    	   Status='Open',
    	   ContactId = c.id,
    	   contact_date__c=System.today()
    	);   	
    	insert case1; 
    	
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, 
	            SUMMARY_I1__c,
	            LONG_COMMENTS_I1__c,
	            RESPONSE_CATEGORY_I1__c,
	            RESPONSE_TYPE_I1__c,
	            RESPONSE_DATE_I1__c,
	            PROGRAM_I1__c,
	            TECHNIQUE_I1__c,
	            WARNING_I1__c,
	            WARN_EXPIRE_DATE_I1__c,
	            STS_I1__c       			
			From TA_Upload__c
			Where SFDC_ID__c = :case1.Id AND SFDC_UPDATE_TYPE__c = 'Interaction'
			];
	}
    public static testMethod void testTaUploadInteractionInsertWithBulkLoad() {
	   	Contact c = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I',
    	   bulk_load__c = true    	   
    	);
    	insert c;   

	   	Case case1 = new Case(
	   	   Summary__c = 'Joe has a problem.',
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Jazz',
    	   Status='Open',
    	   ContactId = c.id,
    	   contact_date__c=System.today(),
    	   bulk_load__c = true  
    	);   	
    	insert case1; 
    	
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, 
	            SUMMARY_I1__c,
	            LONG_COMMENTS_I1__c,
	            RESPONSE_CATEGORY_I1__c,
	            RESPONSE_TYPE_I1__c,
	            RESPONSE_DATE_I1__c,
	            PROGRAM_I1__c,
	            TECHNIQUE_I1__c,
	            WARNING_I1__c,
	            WARN_EXPIRE_DATE_I1__c,
	            STS_I1__c       			
			From TA_Upload__c
			Where SFDC_ID__c = :case1.Id AND SFDC_UPDATE_TYPE__c = 'Interaction'
			];
	}		
}