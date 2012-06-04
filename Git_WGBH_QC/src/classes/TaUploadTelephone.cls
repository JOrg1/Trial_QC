public class TaUploadTelephone {
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
				NAME_ID_T1__c,
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				SFDC_UPDATE_TYPE__c,
				SFDC_PKEY__c,				
				ID_TYPE__c,	
				TELEPHONE_ID_T1__c,							
				TELEPHONE_TYPE_T1__c,
				TELEPHONE_LONG_T1__c,
				STS_T1__c													
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Telephone'					 
			]);

		for(Household__c clazz : clazzes) {
			TA_Upload__c upload = existingMap.get(clazz.Id);
			if(clazz.ta_account_id__c==null) // donot update email if household is not in TA.
				continue; 
			if(oldMap!=null) { // skip if phone is not updated.
				Household__c oldClazz = oldMap.get(clazz.Id);
				if(	oldClazz.householdPhone__c == clazz.householdPhone__c &&
					oldClazz.workPhone__c == clazz.workPhone__c				
					) {
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
		            upload.NAME_ID_T1__c = Integer.valueOf(cData[1]);//from key	
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key			             		                        
		            upload.SFDC_ACCOUNT_CATEGORY__c = 'I';//from key	        	
		        }
				/**
				 * TA needs Account_type
				 */
				upload.ACCOUNT_TYPE__c='IN';
			}
            upload.ALT_ACCOUNT_ID__c = clazz.ID;		        
            upload.SFDC_ID__c = clazz.Id;
            upload.ID_TYPE__c = 'SFDC';					
			/**
			 * Telephone Fields
			 */
			upload.SFDC_UPDATE_TYPE__c = 'Telephone';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;	

			if(isUpdate) {
				Household__c oldClazz = oldMap.get(clazz.Id);							
				if(oldClazz.householdPhone__c != clazz.householdPhone__c) {	
					if(clazz.ta_homephone_id__c!=null) {
						upload.TELEPHONE_ID_T1__c = pad2string(clazz.ta_homephone_id__c);
					}		
					upload.TELEPHONE_TYPE_T1__c = 'H';
					upload.TELEPHONE_LONG_T1__c = clazz.householdPhone__c;
					upload.DO_UPDATES_T1__c	= 'Y';					
				}
				else if(oldClazz.workPhone__c != clazz.workPhone__c) {
					if(clazz.ta_workphone_id__c!=null) {
						upload.TELEPHONE_ID_T1__c = pad2string(clazz.ta_workphone_id__c);
					}						
					upload.TELEPHONE_TYPE_T1__c = 'W';
					upload.TELEPHONE_LONG_T1__c = clazz.workPhone__c;
					upload.DO_UPDATES_T1__c	= 'Y';										
				} 
			}
			else { //Insert
				if(clazz.householdPhone__c != null) {			
					upload.TELEPHONE_TYPE_T1__c = 'H';
					upload.TELEPHONE_LONG_T1__c = clazz.householdPhone__c;
					upload.DO_UPDATES_T1__c	= 'Y';	
				}
				else if(clazz.workPhone__c != null) {
					upload.TELEPHONE_TYPE_T1__c = 'W';
					upload.TELEPHONE_LONG_T1__c = clazz.workPhone__c;
					upload.DO_UPDATES_T1__c	= 'Y';										
				} 				
			}
            upload.STS_T1__C = 'A';

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
				SFDC_ACCOUNT_CATEGORY__c,
				SFDC_EXTERNAL_ID__c,
				SFDC_ID__c,
				ID_TYPE__c,	
				NAME_ID_T1__c,
				TELEPHONE_ID_T1__c,											
				TELEPHONE_TYPE_T1__c,
				TELEPHONE_LONG_T1__c,
				STS_T1__c,
				NAME_ID_T2__c,
				TELEPHONE_ID_T2__c,					
				TELEPHONE_TYPE_T2__c,
				TELEPHONE_LONG_T2__c,
				STS_T2__c,
				NAME_ID_T3__c,
				TELEPHONE_ID_T3__c,										
				TELEPHONE_TYPE_T3__c,
				TELEPHONE_LONG_T3__c,
				STS_T3__c,	
				NAME_ID_T4__c,
				TELEPHONE_ID_T4__c,									
				TELEPHONE_TYPE_T4__c,
				TELEPHONE_LONG_T4__c,
				STS_T4__c				
			From TA_Upload__c 
			Where SFDC_ID__c IN :idSet AND SFDC_UPDATE_TYPE__c = 'Telephone'					 
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
				if(	oldClazz.homePhone == clazz.homePhone && 
					oldClazz.workPhone__c == clazz.workPhone__c &&
					oldClazz.MobilePhone == clazz.MobilePhone &&
					oldClazz.Fax == clazz.Fax											
					) {
					continue;
				}
			} 
			if(upload==null) {
				upload = new TA_Upload__c();
		        // 0   1 2  3 4
		        //xxx_00_C__a_1
		        upload.SFDC_EXTERNAL_ID__c = clazz.tacontactid__c;
	            upload.SFDC_ID__c = clazz.Id;
	            upload.ID_TYPE__c = 'SFDC';
	
		        if(upload.SFDC_EXTERNAL_ID__c!=null) {
		            String[] cData = upload.SFDC_EXTERNAL_ID__c.split('_');                       	            
		            upload.ACCOUNT_ID__c = Double.valueOf(cData[0]); //from key
					upload.NAME_ID_0__c = Integer.valueOf(cData[1]);//from key	
					/**
					 * Original format had mixed types :(
					 */		            
		            upload.NAME_ID_T1__c = Integer.valueOf(cData[1]);//from key
		            upload.NAME_ID_T2__c = cData[1];//from key	
		            upload.NAME_ID_T3__c = Integer.valueOf(cData[1]);//from key	
		            upload.NAME_ID_T4__c = cData[1];//from key			            		            		            	            
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
			 * Check for valid Email changes
			 */
		 
			 if(isUpdate) {
		 		Contact oldClazz = oldMap.get(clazz.id);				 	
			 	if(	oldClazz.HomePhone == clazz.HomePhone &&
					oldClazz.WorkPhone__c == clazz.WorkPhone__c &&
					oldClazz.MobilePhone == clazz.MobilePhone &&			 	
			 	 	oldClazz.Fax == clazz.Fax 
			 	 	)
			 		continue;	
			 }
			 Integer count = 0;
			 String[] phonenumber = new String[4];
			 String[] phonetype = new String[4];
			 Double[] phoneid = new Integer[4];
			 if(isUpdate) {
		 		 Contact oldClazz = oldMap.get(clazz.id);				 				 
				 if(oldClazz.HomePhone != clazz.HomePhone) {
				 	phonenumber[count] = clazz.HomePhone;
				 	phonetype[count] = 'H';
				 	phoneid[count++] = clazz.ta_homephone_id__c;
				 }
				 if(oldClazz.WorkPhone__c != clazz.WorkPhone__c) {
				 	phonenumber[count] = clazz.WorkPhone__c;
				 	phonetype[count] = 'W';
				 	phoneid[count++] = clazz.ta_workphone_id__c;				 	
				 }
				 if(oldClazz.MobilePhone != clazz.MobilePhone) {
				 	phonenumber[count] = clazz.MobilePhone;
				 	phonetype[count] = 'C';
				 	phoneid[count++] = clazz.ta_mobilephone_id__c;				 	
				 }
				 if(oldClazz.Fax != clazz.Fax) {
				 	phonenumber[count] = clazz.Fax;
				 	phonetype[count] = 'F';
				 	phoneid[count++] = clazz.ta_fax_id__c;				 	
				 }
			 }
			 else { // insert
				 if(clazz.HomePhone != null) {
				 	phonenumber[count] = clazz.HomePhone;
				 	phonetype[count] = 'H';
				 	phoneid[count++] = clazz.ta_homephone_id__c;				 	
				 }
				 if(clazz.WorkPhone__c != null) {
				 	phonenumber[count] = clazz.WorkPhone__c;
				 	phonetype[count] = 'W';
				 	phoneid[count++] = clazz.ta_workphone_id__c;					 	
				 }
				 if(clazz.MobilePhone != null) {
				 	phonenumber[count] = clazz.MobilePhone;
				 	phonetype[count] = 'C';
				 	phoneid[count++] = clazz.ta_mobilephone_id__c;				 	
				 }
				 if(clazz.Fax != null) {
				 	phonenumber[count] = clazz.Fax;
				 	phonetype[count] = 'F';
				 	phoneid[count++] = clazz.ta_fax_id__c;				 	
				 }			 	
			 }			 			 			 					
			/**
			 * Telephone Fields
			 */
			upload.SFDC_UPDATE_TYPE__c = 'Telephone';
			upload.SFDC_PKEY__c = upload.SFDC_UPDATE_TYPE__c + '-' + upload.SFDC_ID__c;
			if(count>=1) {
				upload.DO_UPDATES_T1__c	= 'Y';							
				upload.TELEPHONE_TYPE_T1__c = phonetype[0];
				upload.TELEPHONE_LONG_T1__c = phonenumber[0];
				upload.TELEPHONE_ID_T1__c = pad2string(phoneid[0]);				
            	upload.STS_T1__C = 'A';	
            	if(count==1) { //hack
					upload.NAME_ID_T2__c = null;           		
					upload.NAME_ID_T3__c = null;
					upload.NAME_ID_T4__c = null; 						            		
            		
            	}	            				
			}
			if(count>=2) {
				upload.DO_UPDATES_T2__c	= 'Y';							
				upload.TELEPHONE_TYPE_T2__c = phonetype[1];
				upload.TELEPHONE_LONG_T2__c = phonenumber[1];
				upload.TELEPHONE_ID_T2__c = pad2string(phoneid[1]);					
            	upload.STS_T2__C = 'A';	
            	if(count==2) {  //hack            		
					upload.NAME_ID_T3__c = null;
					upload.NAME_ID_T4__c = null;	 		           		
            		
            	}				
			}
			if(count>=3) {
				upload.DO_UPDATES_T3__c	= 'Y';							
				upload.TELEPHONE_TYPE_T3__c = phonetype[2];
				upload.TELEPHONE_LONG_T3__c = phonenumber[2];
				upload.TELEPHONE_ID_T3__c = pad2string(phoneid[2]);					
            	upload.STS_T3__C = 'A';	
            	if(count==3) { //hack
					upload.NAME_ID_T4__c = null;        		
            	}		            					
			}
			if(count>=4) {
				upload.DO_UPDATES_T4__c	= 'Y';							
				upload.TELEPHONE_TYPE_T4__c = phonetype[3];
				upload.TELEPHONE_LONG_T4__c = phonenumber[3];
				upload.TELEPHONE_ID_T4__c = pad2string(phoneid[3]);					
            	upload.STS_T4__C = 'A';					
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
		if(insertList.size()>0) insert insertList;
		if(updateList.size()>0) update updateList;				
	}
    public static testMethod void testHOuseholdTaUploadPhone() {
    	/** Insert **/
    	/** Insert **/
    	Household__c household = new Household__c(
    	   Name = 'Mr. & Mrs. Joe Dirt', 
    	   Ta_Account_Id__c = 23456
    	);  
    	insert household;      	
		household.HouseholdPhone__c = '508 655-2345';
		update household;
		System.debug(household);
		
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, TELEPHONE_LONG_T1__c, TELEPHONE_TYPE_T1__c
			From TA_Upload__c
			Where SFDC_ID__c = :household.Id AND SFDC_UPDATE_TYPE__c = 'Telephone'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].TELEPHONE_LONG_T1__c,'508 655-2345');	
	}	
    public static testMethod void testContactTaUploadPhone() {
    	/** Insert **/
    	Contact contact = new Contact(
    	   FirstName = 'Joe', 
    	   LastName = 'Dirt', 
    	   TaContactId__c = '23456_01_I'
    	);
    	insert contact;     	
		contact.PreferredPhone__c = 'Work';
		contact.WorkPhone__c = '617 345-3456';
		update contact;		
		System.debug(contact);		
        		
		TA_Upload__c[] upload = [
			Select Id, SFDC_ID__c, TELEPHONE_LONG_T1__c, TELEPHONE_TYPE_T1__c
			From TA_Upload__c
			Where SFDC_ID__c = :contact.Id AND SFDC_UPDATE_TYPE__c = 'Telephone'
			];
        //System.AssertEquals(upload.size(),1);
        //System.AssertEquals(upload[0].TELEPHONE_LONG_T1__c,'617 345-3456');        	
	}
	private static String pad2string(Decimal num) {
		if(num==null) return null;
		Integer intnum = num.intValue();
		String strnum = String.valueOf(intnum);
		return (strnum.length()==1) ? '0' + strnum : strnum; 
	}										
}