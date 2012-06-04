public class UploadRecordMatchingHouseHold{
    public static Account objHouse = new Account();
    
    static void stopProcessingFromCaughtException(WGBH_PB5_UPLOAD__c PB, String Reason, Exception pException, String additionalInfo) {
        stopProcessing(PB, Reason, pException.getTypeName() + ': ' + pException.getMessage() + ': ' + additionalInfo);
    }
    
    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason) {
        stopProcessing(PB, Reason, null);
    }
    
    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason, String additionalInfo) {
        pb.Flag_for_Review__c = true;
        pb.Flag_Review_Reason__c = Reason;
        pb.Flag_Review_Exception__c = 'UploadRecordMatchingHouseHold.cls: ' + additionalInfo;
        pb.PB5_IS_PROCESSED__c = false;
        pb.PB5_IS_NEW__c = true;
        pb.PB5_Stage__c = 'A';
        Update pb;
        return;
    }
    Static string InsufficientInfo = 'Insufficient Information';
    Static string MultipleMatching = 'MORE THAN 1 MATCH';
    Static string PledgeIdNumberExists = 'SFDC PLEDGE ID or PLEDGE NUMBER EXIST';
    Static string GiftTypeNull = 'GIFT TYPE IS NULL';
    Static string CCDeclined = 'CC Declined';
    
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
    public static String ProcessHousehold(WGBH_PB5_UPLOAD__c PB5){
        //String MatchingCriteria = 'ACCOUNT_ID_ARIA__c=PB5_ALT_ACCOUNT_ID_ARIA__c;ACCOUNT_ID_AUCTION__c=PB5_ALT_ACCOUNT_ID_AUCTION__c;ACCOUNT_ID_CARS__c=PB5_ALT_ACCOUNT_ID_CARS__c;ACCOUNT_ID_FDNDEV__c=PB5_ALT_ACCOUNT_ID_FDNDEV__c;ACCOUNT_ID_LOCKBOX__c=PB5_ALT_ACCOUNT_ID_LOCKBOX__c;ACCOUNT_ID_PBSD__c=PB5_ALT_ACCOUNT_ID_PBSD__c';
        if(NVL(PB5.Transaction_Purpose__c).toUpperCase() == 'DECLINED'){
            stopProcessing(PB5, CCDeclined, CCDeclined);
            return '';
        }
        String MatchingCriteria = ''; //'UniqueID__c=PB5_SFDC_ID__c';
        if(NVL(System.Label.PB5_Household_Matching_Criteria) != ''){
            MatchingCriteria = System.Label.PB5_Household_Matching_Criteria;
        }
        else{
            MatchingCriteria = 'UniqueID__c=PB5_SFDC_ID__c';
        }
        system.debug('########### Matching Criteria : ' + MatchingCriteria);
        List<sObject> lstTarget;
        try{
            lstTarget = UploadRecordMatching.getMatchingRows(PB5,'Account',MatchingCriteria);
            system.debug('############ Household found : ' + lstTarget);
            if(lstTarget.size()==0){
                //insertHousehold(PB5);
                UploadRecordMatchingContact.ProcessContact(PB5,String.valueOf(''));
                return '';
            }
            else if(lstTarget.size()==1){
                objHouse = (Account)lstTarget[0];
                //updateHousehold(PB5);
            }
            else if(lstTarget.size()>1){
                stopProcessing(PB5,MultipleMatching, 'lstTarget = ' + lstTarget);
                return '';     
            }
            Update PB5;
            if(String.valueOf(objHouse.Id).trim().length()>0){
                UploadRecordMatchingContact.ProcessContact(PB5,String.valueOf(objHouse.Id));
            }        
        }
        Catch(Exception ex){
            stopProcessingFromCaughtException(PB5,InsufficientInfo, ex, 'method = ProcessHousehold'
                 + ', lstTarget = ' + lstTarget
                 + ', MatchingCriteria = ' + MatchingCriteria);
            return '';
        }
        return String.valueOf(objHouse.Id);
    }
    public static boolean UpdateHousehold(WGBH_PB5_UPLOAD__c pb){
        boolean blnSuccess=false;        
        mapHouseholdField(pb);
        try{
            update objHouse;
            if(objHouse.Id != null && String.valueOf(objHouse.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
    }
    
    public static void mapHouseholdField(WGBH_PB5_UPLOAD__c pb){        
        //objHouse.name = getValues(pb.PB5_FIRST_NAME__c, pb.PB5_FIRST_NAME_2__c) + ' ' + getValues(pb.PB5_LAST_NAME__c, pb.PB5_LAST_NAME_2__c);
        objHouse.name = getFirstName(pb) + ' ' + getLastName(pb);
        objHouse.recordTypeId = getRecordTypeId('Household');
        objHouse.MailingCity__c = pb.PB5_SHIP_TO_CITY__c;
        //objHouse.MailingCountry__c
        objHouse.MailingState__c = pb.PB5_SHIP_TO_STATE__c;
        objHouse.MailingStreet__c = pb.PB5_SHIP_TO_STREET_1__c;
        objHouse.MailingPostalCode__c = pb.PB5_SHIP_TO_ZIP_CODE__c;        
        return;
    }
    public static boolean InsertHousehold(WGBH_PB5_UPLOAD__c pb){
        boolean blnSuccess=false;
        mapHouseholdField(pb);
        try{
            insert objHouse;
            if(objHouse.Id != null && String.valueOf(objHouse.Id).length()>0)
                blnSuccess = true;
            else
                blnSuccess = false;
        }Catch(Exception ex){
            blnSuccess = false;
        }
        return blnSuccess;
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
    static ID getRecordTypeId(String developerName){
        ID recordTypeId = null;
        
        List<RecordType> lstRc = [Select Id, DeveloperName from RecordType Where DeveloperName =: DeveloperName];
        if(lstRc != null && lstRc.size()>0){
            recordTypeId = lstRc[0].Id;
        }
        return recordTypeId;
    }
    
    static testMethod void myTest() {


        Campaign c = new Campaign(Name = 'Test');
        c.Station__c = 'WGBH';
        c.Campaign_Name__c = 'Annual';
        Insert c;

        WGBH_PB5_UPLOAD__c PB = new WGBH_PB5_UPLOAD__c();

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
        //pb.PB5_SOURCE__c = 'GBHAO2110504003';  
        pb.PB5_Source__c = c.source_code__c;
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
        
        UploadRecordMatchingHouseHold.ProcessHousehold(pb);
        UploadRecordMatchingHouseHold.UpdateHousehold(pb);
        UploadRecordMatchingHouseHold.InsertHousehold(pb);
        UploadRecordMatchingHouseHold.mapHouseholdField(pb);
        UploadRecordMatchingHouseHold.stopProcessing(pb,'Insufficient Information');
    
    
    }
    
}