public class UploadRecordMatchingContact{
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5, String HouseholdId){
        List<sObject> lstTarget;
        UploadRecordMatchingProcess__c csMatchingFields = UploadRecordMatchingProcess__c.getOrgDefaults();
        system.debug('########################' + csMatchingFields);
        String MatchingCriteria;
        if(NVL(System.Label.PB5_Contact_Matching_Criteria) != ''){
            MatchingCriteria = System.Label.PB5_Contact_Matching_Criteria;
        }
        else{
            MatchingCriteria = 'LastName=PB5_LAST_NAME__c,Email=PB5_EMAIL_ADDRESS_1__c;LastName=PB5_LAST_NAME_2__c,Email=PB5_EMAIL_ADDRESS_2__c;FirstName=PB5_FIRST_NAME__c,LastName=PB5_LAST_NAME__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c;FirstName=PB5_FIRST_NAME_2__c,LastName=PB5_LAST_NAME_2__c,MailingStreet=PB5_STREET_1__c,MailingCity=PB5_CITY__c,MailingState=PB5_STATE__c,MailingPostalCode=PB5_ZIP_CODE__c';
        }
        system.debug('################ MatchingCriteria ' + MatchingCriteria);
        if(NVL(householdId) != ''){
            String Q = 'Select Id, MasterRecordId, AccountId, LastName, FirstName, Salutation, Name, RecordTypeId, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department, AssistantName, LeadSource, Birthdate, Description, OwnerId, HasOptedOutOfEmail, HasOptedOutOfFax, DoNotCall, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastCURequestDate, LastCUUpdateDate, EmailBouncedReason, HomeEmail__c, Household_Account_Manager__c,  Organization_Type__c, Political__c, PreferredPhone__c, Preferred_Email__c, Primary_Address_Type__c, Private__c, Secondary_Address_Type__c, Account_Manager__c,  Preferred_Address__c, STS__c, TaContactId__c, gender__c, gender_value__c, maiden_name__c, middle_name__c, suffix__c, WorkEmail__c, WorkPhone__c, Work_Address__c, age_range__c, ta_fax_id__c, ta_homeemail_id__c, ta_homephone_id__c, ta_mobilephone_id__c, ta_workemail_id__c, ta_workphone_id__c, Birth_Month__c, Birth_Day__c, Birth_Year__c, Contact_Type__c, Assistant_Email__c, Contact_Web_Site__c, batch_process_count__c, Do_Not_Mail__c,   SFDC_CONTACT_ID__c  FROM Contact  ';
            Q += ' Where AccountId = \'' + HouseholdId + '\' Limit 1';
            lstTarget = Database.Query(Q);
        }
        if(lstTarget != null && lstTarget.size()>0){
            ProcessContact(PB5, lstTarget,HouseholdId, '2');
        }
        else{
            //lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Contact',MatchingCriteria);
            lstTarget = UploadRecordMatching.getProperMatching(PB5,'Contact',MatchingCriteria);
            ProcessContact(PB5, lstTarget,HouseholdId, '2');
        }
    }

    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason) {
        stopProcessing(PB, Reason, null);
    }
    
    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason, String additionalInfo) {
        pb.Flag_for_Review__c = true;
        pb.Flag_Review_Reason__c = Reason;
        pb.Flag_Review_Exception__c = additionalInfo;
        pb.PB5_IS_PROCESSED__c = false;
        pb.PB5_IS_NEW__c = true;
        pb.PB5_Stage__c = 'A';
        system.debug('############### STOP PROCESSING CONTACT');
        Update pb;
        return;
    }

    Static string InsufficientInfo = 'Insufficient Information';
    Static string MultipleMatching = 'MORE THAN 1 MATCH';
    Static string PledgeIdNumberExists = 'SFDC PLEDGE ID or PLEDGE NUMBER EXIST';
    Static string GiftTypeNull = 'GIFT TYPE IS NULL';
    
    public static void ProcessContact(WGBH_PB5_UPLOAD__c PB5,List<sObject> lstTarget, String HouseholdId, String flag){
        //List<sObject> lstTarget = getMatchingRows(PB5,'Contact');
        if(lstTarget.size()==0){//Contact Info not exist -> Create new contact
            //insert Contact
            if(InsertContact(PB5, flag, HouseholdId)==true){
                PB5.Flag_for_Review__c = false;
                PB5.PB5_Stage__c = 'B';
                PB5.PB5_IS_PROCESSED__c = true;
                PB5.PB5_IS_NEW__c = false;
            }
            else{
                /*
                stopProcessing(PB5, InsufficientInfo, 'InsertContact(PB5, flag, HouseholdId) != true'
                    + ': PB5 = ' + PB5
                    + ', flag = ' + flag
                    + ', HouseholdId = ' + HouseholdId);
                */
                return;
            }
        }
        else if(lstTarget.size()==1){//Contact Info Exists -> Apend data to existing contact
            //update Contact
            if(UpdateContact((Contact) lstTarget[0], PB5, flag,HouseholdId)==true){
                
            }
            else{
                /*
                stopProcessing(PB5, InsufficientInfo, 'UpdateContact((Contact) lstTarget[0], PB5, flag, HouseholdId) != true'
                    + ': lstTarget[0] = ' + lstTarget[0]
                    + ', PB5 = ' + PB5
                    + ', flag = ' + flag
                    + ', HouseholdId = ' + HouseholdId);
                */
                return;
            }
        }
        else if(lstTarget.size()>1){//Multiple Contact found
            //multiple matches found
            String duplicateId='';
            for(sObject t:lstTarget){
                if(duplicateId.length()==0)
                    duplicateId = String.valueOf(t.get('Id'));// + '#' + String.valueOf(t.get('name'));
                else
                    duplicateId += +', ' + String.valueOf(t.get('Id'));// + '#' + String.valueOf(t.get('name'));                        
            }
            //PB5.SF_Duplicate_ID__c = duplicateId;
            stopProcessing(PB5, MultipleMatching, 'lstTarget = ' + lstTarget);
        }
        //Update PB5;    
    }
    /////////////////////
    static ID getRecordTypeId(String developerName){
        ID recordTypeId = null;
        
        List<RecordType> lstRc = [Select Id, DeveloperName from RecordType Where DeveloperName =: DeveloperName];
        if(lstRc != null && lstRc.size()>0){
            recordTypeId = lstRc[0].Id;
        }
        return recordTypeId;
    }
    public static Account mapHouseholdField(WGBH_PB5_UPLOAD__c pb){        
        Account objHouse = new Account();
        objHouse.name = getFirstName(pb) + ' ' + getLastName(pb);
        objHouse.recordTypeId = getRecordTypeId('Household');
        objHouse.MailingCity__c = pb.PB5_SHIP_TO_CITY__c;
        objHouse.MailingState__c = pb.PB5_SHIP_TO_STATE__c;
        objHouse.MailingStreet__c = pb.PB5_SHIP_TO_STREET_1__c;
        objHouse.MailingPostalCode__c = pb.PB5_SHIP_TO_ZIP_CODE__c;        
        return objHouse;
    }
    public static String InsertHousehold(WGBH_PB5_UPLOAD__c pb){
        Account objHouse = mapHouseholdField(pb);
        mapHouseholdField(pb);
        try{
            insert objHouse;
            if(objHouse.Id != null && String.valueOf(objHouse.Id).length()>0)
                return objHouse.Id;
            else
                return '';
        }Catch(Exception ex){
            return '';
        }
    }
    /////////////////////
    public static boolean InsertContact(WGBH_PB5_UPLOAD__c pb, String flag, String HouseholdId){
        boolean blnSuccess=false;
        Contact objContact = new Contact();
        try{
            if(NVL(HouseholdId) == ''){
                HouseholdId = InsertHousehold(pb);
            }
            objContact.FirstName = getFirstName(pb);
            objContact.LastName = getLastName(pb);
            system.debug('########## household id : ' + householdId);
            if(NVL(objContact.LastName) == '' && NVL(objContact.FirstName) != ''){
                objContact.LastName = objContact.FirstName;
                objContact.FirstName = '';
            }
            else if(NVL(objContact.LastName) == '' && NVL(objContact.FirstName) == ''){
                if(NVL(householdid) != ''){
                    List<Account> lstAccount = [Select name From Account Where Id=:householdid];
                    system.debug('############### lstAccount : ' + lstAccount);
                    if(lstAccount != null && lstAccount.size()>0){
                        objContact.LastName = lstAccount[0].name;
                        system.debug('############ objContact.LastName : ' + objContact.LastName);
                    }
                }
            }
            objContact.AccountId = ID.valueOf(HouseholdId);
            objContact.Salutation = getValues(pb.PB5_SUFFIX__c, pb.PB5_SUFFIX_2__c);
            objContact.PreferredPhone__c = getValues(pb.PB5_TELEPHONE_TYPE_1__c, pb.PB5_TELEPHONE_TYPE_2__c);
            if(NVL(objContact.PreferredPhone__c) == ''){
                objContact.PreferredPhone__c = 'Work';
            }
            if(NVL(objContact.PreferredPhone__c) == 'H' || NVL(objContact.PreferredPhone__c) == 'Home'){
                objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
            }
            if(NVL(objContact.PreferredPhone__c) == 'W' || NVL(objContact.PreferredPhone__c) == 'Work'){
                objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
            }
            objContact.Preferred_Email__c = getValues(pb.PB5_EMAIL_TYPE_1__c, pb.PB5_EMAIL_TYPE_2__c);
            if(NVL(objContact.Preferred_Email__c)==''){
                objContact.Preferred_Email__c = 'Work';
            }
            if(NVL(objContact.Preferred_Email__c) == 'Work'){
                objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            }
            else if(NVL(objContact.Preferred_Email__c) == 'Home'){
                objContact.HomeEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            }
            else if(NVL(objContact.Preferred_Email__c) == 'Assistant'){
                objContact.Assistant_Email__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            }
            else if(NVL(objContact.Preferred_Email__c) == 'Default Email'){
                objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            }
            else{
                objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            }
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
            objContact.Phone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
            objContact.MailingStreet = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
            objContact.MailingCity = getValues(pb.PB5_SHIP_TO_CITY__c, pb.PB5_CITY__c);
            objContact.MailingState = getValues(pb.PB5_SHIP_TO_STATE__c, pb.PB5_STATE__c);
            objContact.MailingPostalCode = getValues(pb.PB5_SHIP_TO_ZIP_CODE__c, pb.PB5_ZIP_CODE__c);
            ////////////////////
            system.debug('########## Contact to Insert : ' + objContact);
            insert objContact;
            String CurrentAdd = '';
            CurrentAdd = NVL(pb.PB5_SHIP_TO_STREET_1__c) + NVL(pb.PB5_STREET_1__c) + NVL(pb.PB5_EXTRA_LINE_1__c) + NVL(pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
            CurrentAdd += getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
            CurrentAdd += getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
            CurrentAdd += getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
            
            if(CurrentAdd.length()>0){
                ProcessAddress(pb, householdid);
                /*
                blnSuccess = true;
                Address__c objAdd = new Address__c();
                objAdd.Address_Type__c = NVL(pb.PB5_ADDRESS_TYPE__c);
                objAdd.Street_1__c = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
                objAdd.Street_2__c = getValues(pb.PB5_EXTRA_LINE_1__c, pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
                objAdd.City__c = getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
                objAdd.State__c = getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
                objAdd.Postal_Code__c = getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
                objAdd.Country__c = NVL(pb.PB5_COUNTRY__c);    
                //objAdd.Contact__c = objContact.Id;
                objAdd.Account_Household__c = HouseholdId;   
                Insert objAdd;  
                */
            }
            else{
                blnSuccess = false;
            }
            //UploadRecordMatchingGiving.processGiving(pb, objContact.Id, householdId);
            commonApex.UpdatePB5Lookups(pb,objContact.Id, householdId, '','');
            UploadRecordMatchingGivingNew.processGiving(pb, objContact.Id, householdId);
        }Catch(Exception ex){
            system.debug('################## ERROR : ' + ex.getMessage());
            stopProcessing(PB, InsufficientInfo, ex.GetMessage());
            blnSuccess = false;
        }
        return blnSuccess;
    }
    public static Contact mapContactField(WGBH_PB5_UPLOAD__c pb, String flag, String householdId){
        Contact objContact = new Contact();
        
        objContact.FirstName = getFirstName(pb); //getValues(pb.PB5_FIRST_NAME__c, pb.PB5_FIRST_NAME_2__c);
        objContact.LastName = getLastName(pb); //getValues(pb.PB5_LAST_NAME__c, pb.PB5_LAST_NAME_2__c);
        system.debug('########## household id : ' + householdId);
        if(NVL(objContact.LastName) == '' && NVL(objContact.FirstName) != ''){
            objContact.LastName = objContact.FirstName;
            objContact.FirstName = '';
        }
        else if(NVL(objContact.LastName) == '' && NVL(objContact.FirstName) == ''){
            if(NVL(householdid) != ''){
                List<Account> lstAccount = [Select name From Account Where Id=:householdid];
                system.debug('############### lstAccount : ' + lstAccount);
                if(lstAccount != null && lstAccount.size()>0){
                    objContact.LastName = lstAccount[0].name;
                    system.debug('############ objContact.LastName : ' + objContact.LastName);
                }
            }
        }
        objContact.AccountId = ID.valueOf(HouseholdId);
        objContact.Salutation = getValues(pb.PB5_SUFFIX__c, pb.PB5_SUFFIX_2__c);
        objContact.PreferredPhone__c = getValues(pb.PB5_TELEPHONE_TYPE_1__c, pb.PB5_TELEPHONE_TYPE_2__c);        
        if(NVL(objContact.PreferredPhone__c) == ''){
            objContact.PreferredPhone__c = 'Work';
        }
        if(NVL(objContact.PreferredPhone__c) == 'H' || NVL(objContact.PreferredPhone__c) == 'Home'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        if(NVL(objContact.PreferredPhone__c) == 'W' || NVL(objContact.PreferredPhone__c) == 'Work'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        objContact.Preferred_Email__c = getValues(pb.PB5_EMAIL_TYPE_1__c, pb.PB5_EMAIL_TYPE_2__c);
        if(NVL(objContact.Preferred_Email__c)==''){
            objContact.Preferred_Email__c = 'Work';
        }
        if(NVL(objContact.Preferred_Email__c) == 'Work'){
            objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Home'){
            objContact.HomeEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Assistant'){
            objContact.Assistant_Email__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Default Email'){
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else{
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Phone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        objContact.MailingStreet = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
        objContact.MailingCity = getValues(pb.PB5_SHIP_TO_CITY__c, pb.PB5_CITY__c);
        objContact.MailingState = getValues(pb.PB5_SHIP_TO_STATE__c, pb.PB5_STATE__c);
        objContact.MailingPostalCode = getValues(pb.PB5_SHIP_TO_ZIP_CODE__c, pb.PB5_ZIP_CODE__c);
        return objContact;
    }
    static string getLastName(WGBH_PB5_UPLOAD__c pb){
        String LastName = '';
        if(NVL(pb.PB5_LAST_NAME__c) != ''){
            LastName = pb.PB5_LAST_NAME__c;
        }
        else if(NVL(pb.PB5_LAST_NAME_2__c) != ''){
            LastName = pb.PB5_LAST_NAME_2__c;
        }
        else if(NVL(pb.PB5_SHIP_TO_LAST_NAME__c) != ''){
            LastName = pb.PB5_SHIP_TO_LAST_NAME__c;
        }
        else if(NVL(pb.PB5_CHARGE_CARD_HOLDER_LNAME__c) != ''){
            LastName = pb.PB5_CHARGE_CARD_HOLDER_LNAME__c;
        }
        return LastName;
    }
    static string getFirstName(WGBH_PB5_UPLOAD__c pb){
        String FirstName = '';
        if(NVL(pb.PB5_FIRST_NAME__c) != ''){
            FirstName = pb.PB5_FIRST_NAME__c;
        }
        else if(NVL(pb.PB5_FIRST_NAME_2__c) != ''){
            FirstName = pb.PB5_FIRST_NAME_2__c;
        }
        else if(NVL(pb.PB5_SHIP_TO_FIRST_NAME__c) != ''){
            FirstName = pb.PB5_SHIP_TO_FIRST_NAME__c;
        }
        else if(NVL(pb.PB5_CHARGE_CARD_HOLDER_FNAME__c) != ''){
            FirstName = pb.PB5_CHARGE_CARD_HOLDER_FNAME__c;
        }
        return FirstName;
    }
    public static boolean UpdateContact(Contact objContact, WGBH_PB5_UPLOAD__c pb, String flag, string householdid){
        boolean blnSuccess=false;

        if(NVL(objContact.AccountId) == ''){
            if(NVL(HouseholdId) == ''){
                HouseholdId = InsertHousehold(pb);
            }  
            objContact.AccountId = HouseholdId;
        }
        else{
            HouseholdId = objContact.AccountId;
        }
        objContact.PreferredPhone__c = getValues(pb.PB5_TELEPHONE_TYPE_1__c, pb.PB5_TELEPHONE_TYPE_2__c);
        if(NVL(objContact.PreferredPhone__c) == ''){
            objContact.PreferredPhone__c = 'Work';
        }
        if(NVL(objContact.PreferredPhone__c) == 'H' || NVL(objContact.PreferredPhone__c) == 'Home'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        if(NVL(objContact.PreferredPhone__c) == 'W' || NVL(objContact.PreferredPhone__c) == 'Work'){
            objContact.HomePhone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        }
        objContact.Preferred_Email__c = getValues(pb.PB5_EMAIL_TYPE_1__c, pb.PB5_EMAIL_TYPE_2__c);
        if(NVL(objContact.Preferred_Email__c)==''){
            objContact.Preferred_Email__c = 'Work';
        }
        if(NVL(objContact.Preferred_Email__c) == 'Work'){
            objContact.WorkEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Home'){
            objContact.HomeEmail__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Assistant'){
            objContact.Assistant_Email__c = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else if(NVL(objContact.Preferred_Email__c) == 'Default Email'){
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        else{
            objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        }
        objContact.Email = getValues(pb.PB5_EMAIL_ADDRESS_1__c, pb.PB5_EMAIL_ADDRESS_2__c);
        objContact.Phone = getValues(pb.PB5_TELEPHONE_NUMBER_1__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        //objContact.OtherPhone = getValues(pb.PB5_TELEPHONE_NUMBER_2__c, pb.PB5_TELEPHONE_NUMBER_2__c);
        objContact.MailingStreet = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
        objContact.MailingCity = getValues(pb.PB5_SHIP_TO_CITY__c, pb.PB5_CITY__c);
        objContact.MailingState = getValues(pb.PB5_SHIP_TO_STATE__c, pb.PB5_STATE__c);
        objContact.MailingPostalCode = getValues(pb.PB5_SHIP_TO_ZIP_CODE__c, pb.PB5_ZIP_CODE__c);        
        try{
            update objContact;
            if(objContact.Id != null && String.valueOf(objContact.Id).length()>0){
                blnSuccess = true;
                ProcessAddress(pb, householdid);
                commonApex.UpdatePB5Lookups(pb, objContact.Id, householdId, null, null);
                UploadRecordMatchingGivingNew.processGiving(pb, objContact.Id, objContact.AccountId);
            }
            else
                blnSuccess = false;
        }Catch(Exception ex){
            stopProcessing(PB, InsufficientInfo, ex.GetMessage());
            blnSuccess = false;
        }
        return blnSuccess;
    }
    Static void ProcessAddress(WGBH_PB5_UPLOAD__c pb, String householdid){
        Address__c objAdd;
        List<Address__c> lstAdd = [Select Id, Address_Type__c, Street_1__c, Street_2__c, City__c, State__c,
        Postal_Code__c, Country__c, Contact__c, Account_Household__c From Address__c
        Where Account_Household__c =: HouseholdId];
                            
        String CurrentAdd = '';
        CurrentAdd = NVL(pb.PB5_SHIP_TO_STREET_1__c) + NVL(pb.PB5_STREET_1__c) + NVL(pb.PB5_EXTRA_LINE_1__c) + NVL(pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
        CurrentAdd += getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
        CurrentAdd += getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
        CurrentAdd += getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
        Boolean blnAddressFound = false;
        if(lstAdd != null && lstAdd.size()>0){
            for(Address__c add:lstAdd){
                String strAdd = NVL(add.Street_1__c) + NVL(add.Street_2__c);
                strAdd += NVL(add.City__c) + NVL(add.State__c) + NVL(add.Postal_Code__c);
                if(NVL(strAdd) != '' && CurrentAdd == strAdd){
                    objAdd = add;
                    blnAddressFound = true;
                    break;
                }
            }
        }
        if(blnAddressFound == false){
            objAdd = new Address__c();
        }
        if(CurrentAdd != ''){
            objAdd.Address_Type__c = NVL(pb.PB5_ADDRESS_TYPE__c);
            objAdd.Street_1__c = getValues(pb.PB5_SHIP_TO_STREET_1__c, pb.PB5_STREET_1__c);
            objAdd.Street_2__c = getValues(pb.PB5_EXTRA_LINE_1__c, pb.PB5_SHIP_TO_EXTRA_LINE_1__c);
            objAdd.City__c = getValues(pb.PB5_CITY__c, pb.PB5_SHIP_TO_CITY__c);
            objAdd.State__c = getValues(pb.PB5_STATE__c, pb.PB5_SHIP_TO_STATE__c);
            objAdd.Postal_Code__c = getValues(pb.PB5_ZIP_CODE__c, pb.PB5_SHIP_TO_ZIP_CODE__c);
            objAdd.Country__c = NVL(pb.PB5_COUNTRY__c);    
            if(objAdd.Id == null){
                objAdd.Account_Household__c = HouseholdId;
                Insert objAdd;
            }
            else{
                Update objAdd;
            }
            if(objAdd != null && NVL(HouseholdId).length()>0){
                Account objAcc = [Select Id, Preferred_Address__c From Account Where Id=:HouseholdId];
                objAcc.Preferred_Address__c = objAdd.Id;
                Update objAcc;
            }
        }
    }
    static string getValues(string val1, string val2){
        if(NVL(val1)=='')
            return NVL(val2);
        else
            return NVL(val1);
    }
    static string NVL(string val){
        if(val == null)
            return '';
        else
            return val.trim();
    }

    static testMethod void myTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cnt = new Contact();
        cnt.firstName = 'Test';
        cnt.lastName = 'test';
        cnt.AccountID = a.Id;
        insert cnt;        
    
        WGBH_PB5_UPLOAD__c pb = new WGBH_PB5_UPLOAD__c();
        pb.PB5_PAYMENT_AMOUNT__c = 25.00;  
        pb.PB5_END_CDATE_4__c = System.today();  
        pb.PB5_STATION_SOURCE__c = 'WGBH';  
        pb.PB5_CLASSIFICATION_CODE_6__c = 'COMMUNICATN';  
        pb.Giving_Record_Type__c = 'Annual'; 
        pb.PB5_START_CDATE_3__c = System.today();  
        pb.PB5_END_CDATE_6__c = System.today();  
        pb.PB5_STATE__c = 'CA';  
        pb.PB5_CLASSIFICATION_VALUE_2__c = 'NO PHONE';  
        pb.PB5_Stage__c = 'A';  
        pb.PB5_GIFT_CDATE__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_2__c = 'APPEAL';  
        pb.PB5_CLASSIFICATION_CODE_3__c = 'AUTO_RENEW';  
        pb.PB5_LAST_NAME__c = 'Test';  
        pb.PB5_CLASSIFICATION_VALUE_4__c = 'YCK';  
        pb.PB5_CLASSIFICATION_VALUE_6__c = 'YCH';  
        pb.PB5_UPLOAD_SOURCE__c = 'ARIA';  
        pb.PB5_IS_NEW__c = true;  
        pb.PB5_SUFFIX__c = 'Sr.';  
        pb.PB5_CITY__c = 'pb5 4';  
        pb.PB5_CLASSIFICATION_VALUE_7__c = '50 TO 64';  
        pb.PB5_CLASSIFICATION_CODE_7__c = 'APPEAL';  
        pb.PB5_END_CDATE_2__c = System.today();  
        pb.PB5_STATION_SUPPORT__c = 'Radio General';  
        pb.PB5_CLASSIFICATION_VALUE_1__c = 'SENIOR';  
        pb.PB5_TITLE__c = 'Mr.';  
        pb.PB5_BENEFIT_1__c = 'PTDH0001';  
        pb.PB5_STREET_1__c = '555';  
        pb.PB5_CLASSIFICATION_VALUE_3__c = 'CK';  
        pb.PB5_CLASSIFICATION_VALUE_5__c = 'Y ARONLY';  
        pb.PB5_ZIP_CODE__c = '432567';  
        pb.PB5_CLASSIFICATION_CODE_4__c = 'H MEMBERTYPE';  
        pb.PB5_END_CDATE_1__c = System.today();  
        pb.PB5_TITLE_2__c = 'Major';  
        pb.PB5_PLEDGE_AMOUNT__c = 100.00;  
        pb.PB5_PAYMENT_FREQUENCY__c = 'Quarterly';  
        pb.PB5_COUNTRY__c = 'USA';  
        pb.PB5_ADDRESS_TYPE__c = 'Work';  
        pb.PB5_SFDC_ID__c = '47352';  
        pb.PB5_RECORD_TYPE__c = 'PB5TEST';  
        pb.PB5_CLASSIFICATION_CODE_1__c = 'DISCOUNT';  
        pb.PB5_START_CDATE_5__c = System.today();  
        pb.PB5_SUFFIX_2__c = 'O.D.';  
        pb.PB5_PAYMENTS_IN_SCHEDULE__c = 4;  
        pb.PB5_START_CDATE_6__c = System.today();  
        pb.PB5_REQUIRES_REVIEW__c = false;  
        pb.PB5_START_CDATE_4__c = System.today();  
        pb.PB5_EMAIL_ADDRESS_2__c = 'test4@pb5.com';  
        pb.PB5_END_CDATE_3__c = System.today();  
        pb.PB5_FIRST_NAME__c = 'Test';  
        pb.PB5_START_CDATE_1__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_5__c = 'Y MEMBERTYPE'; 
        pb.PB5_END_CDATE_5__c = System.today();   
        pb.PB5_IS_PROCESSED__c = false;  
        pb.PB5_SOURCE__c = 'GBHAO2110504003';  
        pb.PB5_START_CDATE_2__c = System.today();  
        pb.PB5_TELEPHONE_TYPE_2__c = 'FH';  
        pb.IS_DUPLICATE__c = false;  
        pb.PB5_INSTALLMENT_AMOUNT__c = 25.00;  
        pb.PB5_PAYMENT_METHOD__c = 'Sage Discover';  
        pb.PB5_GIFT_KIND__c = 'SG';  
        pb.PB5_EMAIL_TYPE_2__c = 'Work';  
        pb.Flag_for_Review__c = false;  
        pb.PB5_TRANSACTION_TYPE__c = 'PLEDGE WITH PAYMENT';         
        insert pb;
        
        ProcessContact(PB,a.id);
        UpdateContact(cnt, PB, 'test', a.id);

        pb = new WGBH_PB5_UPLOAD__c();
        pb.PB5_PAYMENT_AMOUNT__c = 25.00;  
        pb.PB5_END_CDATE_4__c = System.today();  
        pb.PB5_STATION_SOURCE__c = 'WGBH';  
        pb.PB5_CLASSIFICATION_CODE_6__c = 'COMMUNICATN';  
        pb.Giving_Record_Type__c = 'Annual'; 
        pb.PB5_START_CDATE_3__c = System.today();  
        pb.PB5_END_CDATE_6__c = System.today();  
        pb.PB5_STATE__c = 'CA';  
        pb.PB5_CLASSIFICATION_VALUE_2__c = 'NO PHONE';  
        pb.PB5_Stage__c = 'A';  
        pb.PB5_GIFT_CDATE__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_2__c = 'APPEAL';  
        pb.PB5_CLASSIFICATION_CODE_3__c = 'AUTO_RENEW';  
        pb.PB5_LAST_NAME__c = 'Test123';  
        pb.PB5_CLASSIFICATION_VALUE_4__c = 'YCK';  
        pb.PB5_CLASSIFICATION_VALUE_6__c = 'YCH';  
        pb.PB5_UPLOAD_SOURCE__c = 'ARIA';  
        pb.PB5_IS_NEW__c = true;  
        pb.PB5_SUFFIX__c = 'Sr.';  
        pb.PB5_CITY__c = 'pb5 4';  
        pb.PB5_CLASSIFICATION_VALUE_7__c = '50 TO 64';  
        pb.PB5_CLASSIFICATION_CODE_7__c = 'APPEAL';  
        pb.PB5_END_CDATE_2__c = System.today();  
        pb.PB5_STATION_SUPPORT__c = 'Radio General';  
        pb.PB5_CLASSIFICATION_VALUE_1__c = 'SENIOR';  
        pb.PB5_TITLE__c = 'Mr.';  
        pb.PB5_BENEFIT_1__c = 'PTDH0001';  
        pb.PB5_STREET_1__c = '555';  
        pb.PB5_CLASSIFICATION_VALUE_3__c = 'CK';  
        pb.PB5_CLASSIFICATION_VALUE_5__c = 'Y ARONLY';  
        pb.PB5_ZIP_CODE__c = '432567';  
        pb.PB5_CLASSIFICATION_CODE_4__c = 'H MEMBERTYPE';  
        pb.PB5_END_CDATE_1__c = System.today();  
        pb.PB5_TITLE_2__c = 'Major';  
        pb.PB5_PLEDGE_AMOUNT__c = 100.00;  
        pb.PB5_PAYMENT_FREQUENCY__c = 'Quarterly';  
        pb.PB5_COUNTRY__c = 'USA';  
        pb.PB5_ADDRESS_TYPE__c = 'Work';  
        pb.PB5_SFDC_ID__c = '47352';  
        pb.PB5_RECORD_TYPE__c = 'PB5TEST';  
        pb.PB5_CLASSIFICATION_CODE_1__c = 'DISCOUNT';  
        pb.PB5_START_CDATE_5__c = System.today();  
        pb.PB5_SUFFIX_2__c = 'O.D.';  
        pb.PB5_PAYMENTS_IN_SCHEDULE__c = 4;  
        pb.PB5_START_CDATE_6__c = System.today();  
        pb.PB5_REQUIRES_REVIEW__c = false;  
        pb.PB5_START_CDATE_4__c = System.today();  
        pb.PB5_EMAIL_ADDRESS_2__c = 'test4@pb5.com';  
        pb.PB5_END_CDATE_3__c = System.today();  
        pb.PB5_FIRST_NAME__c = 'Test123';  
        pb.PB5_START_CDATE_1__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_5__c = 'Y MEMBERTYPE'; 
        pb.PB5_END_CDATE_5__c = System.today();   
        pb.PB5_IS_PROCESSED__c = false;  
        pb.PB5_SOURCE__c = 'GBHAO2110504003';  
        pb.PB5_START_CDATE_2__c = System.today();  
        pb.PB5_TELEPHONE_TYPE_2__c = 'FH';  
        pb.IS_DUPLICATE__c = false;  
        pb.PB5_INSTALLMENT_AMOUNT__c = 25.00;  
        pb.PB5_PAYMENT_METHOD__c = 'Sage Discover';  
        pb.PB5_GIFT_KIND__c = 'SG';  
        pb.PB5_EMAIL_TYPE_2__c = 'Work';  
        pb.Flag_for_Review__c = false;  
        pb.PB5_TRANSACTION_TYPE__c = 'PLEDGE WITH PAYMENT';         
        insert pb;     
        
        Account a1 = new Account(Name = 'Test123');
        insert a1;
        ProcessContact(PB,a1.id);

        //UploadRecordMatchingContact.ProcessContact(pb);
        //UploadRecordMatchingContact.ProcessContact(pb,new List<sObject>(),'true');
        UploadRecordMatchingContact.InsertContact(pb,'','');
        //UploadRecordMatchingContact.UpdateContact(new Contact(),pb,'true');
        UploadRecordMatchingContact.mapContactField(pb,'true',a1.id);
              
    }       
}