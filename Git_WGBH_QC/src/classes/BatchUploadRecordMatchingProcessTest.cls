global class BatchUploadRecordMatchingProcessTest{
    Public static void BatchUploadRecordMatchingProcess(String pb5Id){
        ID batchprocessid;
        BatchUploadRecordMatchingProcessExec1 reassign;
        String query = 'Select RecordType.DeveloperName, Id, Account__c, Contact__c, Giving__c, CPRT__c, PB5_READY_FOR_PROCESSING__c, Transaction_Purpose__c, transaction_date__c, Payment_Date__c, PB5_ANONYMOUS_CODE__c, Flag_Review_Exception__c, Giving_Record_Type__c, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IS_DUPLICATE__c, PB5_ADDRESS_TYPE__c, PB5_BENEFIT_10__c, PB5_BENEFIT_1__c, PB5_BENEFIT_2__c, PB5_BENEFIT_3__c, PB5_BENEFIT_4__c, PB5_BENEFIT_5__c, PB5_BENEFIT_6__c, PB5_BENEFIT_7__c, PB5_BENEFIT_8__c, PB5_BENEFIT_9__c, PB5_CALLER__c, PB5_CHARGE_CARD_ALIAS__c, PB5_CITY__c, PB5_CLASSIFICATION_CODE_1__c, PB5_CLASSIFICATION_CODE_2__c, PB5_CLASSIFICATION_CODE_3__c, PB5_CLASSIFICATION_CODE_4__c, PB5_CLASSIFICATION_CODE_5__c, PB5_CLASSIFICATION_CODE_6__c, PB5_CLASSIFICATION_CODE_7__c, PB5_CLASSIFICATION_VALUE_1__c, PB5_CLASSIFICATION_VALUE_2__c, PB5_CLASSIFICATION_VALUE_3__c, PB5_CLASSIFICATION_VALUE_4__c, PB5_CLASSIFICATION_VALUE_5__c, PB5_CLASSIFICATION_VALUE_6__c, PB5_CLASSIFICATION_VALUE_7__c, PB5_COMMENTS__c, PB5_COUNTRY__c, PB5_EMAIL_ADDRESS_2__c, PB5_EMAIL_TYPE_2__c, PB5_PLEDGE_CTIME__c, PB5_EXTRA_LINE_1__c, PB5_FIRST_NAME_2__c, PB5_FIRST_NAME__c, PB5_GIFT_KIND__c, PB5_GIFT_TYPE__c, PB5_INSTALLMENT_AMOUNT__c, PB5_IS_NEW__c, PB5_IS_PROCESSED__c, PB5_LAST_NAME_2__c, PB5_LAST_NAME__c, PB5_MIDDLE_NAME_2__c, PB5_MIDDLE_NAME__c, PB5_NO_PHONE_OTHER__c, PB5_NO_PHONE_PREFERRED__c, PB5_ORGANIZATION_NAME__c, PB5_PAYMENTS_IN_SCHEDULE__c, PB5_PAYMENT_AMOUNT__c, PB5_PAYMENT_FREQUENCY__c, PB5_PAYMENT_METHOD__c, PB5_PLEDGE_AMOUNT__c, PB5_PLEDGE_NUMBER__c, PB5_RECIP_ACCOUNT_IDENTIFIER_10__c, PB5_RECIP_ACCOUNT_IDENTIFIER_1__c, PB5_RECIP_ACCOUNT_IDENTIFIER_2__c, PB5_RECIP_ACCOUNT_IDENTIFIER_3__c, PB5_RECIP_ACCOUNT_IDENTIFIER_4__c, PB5_RECIP_ACCOUNT_IDENTIFIER_5__c, PB5_RECIP_ACCOUNT_IDENTIFIER_6__c, PB5_RECIP_ACCOUNT_IDENTIFIER_7__c, PB5_RECIP_ACCOUNT_IDENTIFIER_8__c, PB5_RECIP_ACCOUNT_IDENTIFIER_9__c, PB5_REQUIRES_REVIEW__c, PB5_RESPONSE_CATEGORY__c, PB5_RESPONSE_TYPE__c, PB5_SFDC_ID__c, PB5_SHIP_TO_EXTRA_LINE_1__c, PB5_SHIP_TO_FIRST_NAME__c, PB5_SHIP_TO_LAST_NAME__c, PB5_SHIP_TO_MIDDLE_NAME__c, PB5_SHIP_TO_STATE__c, PB5_SHIP_TO_SUFFIX__c, PB5_SHIP_TO_TITLE__c, PB5_SHIP_TO_ZIP_CODE__c, PB5_SHIP_TO_ZIP_EXTENSION__c, PB5_SOURCE__c, PB5_STATE__c, PB5_STATION_SUPPORT__c, PB5_SUFFIX_2__c, PB5_SUFFIX__c, PB5_TELEPHONE_EXTENSION_2__c, PB5_TELEPHONE_NUMBER_2__c, PB5_TELEPHONE_TYPE_2__c, PB5_TITLE_2__c, PB5_TITLE__c, PB5_TRANSACTION_TYPE__c, PB5_UPLOAD_SOURCE__c, PB5_ZIP_CODE__c, PB5_ZIP_EXTENSION__c, PB5_CHARGE_EXPIRE_CDATE__c, Flag_Review_Reason__c, Flag_for_Review__c, PB5_ALT_ACCOUNT_ID_ARIA__c, PB5_ALT_ACCOUNT_ID_AUCTION__c, PB5_ALT_ACCOUNT_ID_CARS__c, PB5_ALT_ACCOUNT_ID_FDNDEV__c, PB5_ALT_ACCOUNT_ID_LOCKBOX__c, PB5_ALT_ACCOUNT_ID_PBSD__c, PB5_CHARGE_CARD_HOLDER_FNAME__c, PB5_CHARGE_CARD_HOLDER_LNAME__c, PB5_CHARGE_CARD_MASK__c, PB5_CHARGE_CARD_TYPE__c, PB5_CLASSIFICATION_CODE_10__c, PB5_CLASSIFICATION_CODE_8__c, PB5_CLASSIFICATION_CODE_9__c, PB5_CLASSIFICATION_VALUE_10__c, PB5_CLASSIFICATION_VALUE_8__c, PB5_CLASSIFICATION_VALUE_9__c, PB5_EMAIL_ADDRESS_1__c, PB5_EMAIL_TYPE_1__c, PB5_END_CDATE_10__c, PB5_END_CDATE_1__c, PB5_END_CDATE_2__c, PB5_END_CDATE_3__c, PB5_END_CDATE_4__c, PB5_END_CDATE_5__c, PB5_END_CDATE_6__c, PB5_END_CDATE_7__c, PB5_END_CDATE_8__c, PB5_END_CDATE_9__c, PB5_GIFT_CDATE__c, PB5_RECORD_TYPE__c, PB5_RESPONSE_CDATE__c, PB5_SHIP_TO_CITY__c, PB5_SHIP_TO_STREET_1__c, PB5_START_CDATE_10__c, PB5_START_CDATE_1__c, PB5_START_CDATE_2__c, PB5_START_CDATE_3__c, PB5_START_CDATE_4__c, PB5_START_CDATE_5__c, PB5_START_CDATE_6__c, PB5_START_CDATE_7__c, PB5_START_CDATE_8__c, PB5_START_CDATE_9__c, PB5_STATION_SOURCE__c, PB5_STREET_1__c, PB5_Stage__c, PB5_TELEPHONE_EXTENSION_1__c, PB5_TELEPHONE_NUMBER_1__c, PB5_TELEPHONE_TYPE_1__c, PB5_UPLOAD_FILENAME__c, SF_Duplicate_ID__c FROM WGBH_PB5_UPLOAD__c  where PB5_IS_PROCESSED__c = false and PB5_IS_NEW__c = true';
        query += ' and Id = \'' + pb5Id + '\'';
        if(Test.isRunningTest()) query += ' Limit 100';
        reassign = new BatchUploadRecordMatchingProcessExec1 (query);
        
        batchprocessid = Database.executeBatch(reassign,1);
    }
    /*
    static testMethod void TestBatchUploadRecordMatchingProcessTest() {
        Test.startTest();
        
        Campaign c2 = new Campaign();
        c2.name = 'test campaign';
        c2.Station__c = 'KCRW';
        c2.Product_Program__c = 'MEMBERSHIP';
        c2.Campaign_Name__c = 'ANNUAL';
        c2.Solicitation_Type__c = 'ACQUISITION';
        c2.Giving_Segment__c = 'ON-AIR PLEDGE';
        c2.Channel_Technique__c = 'TV';
        c2.Start_Time_Date__c = system.Now();
        c2.source_code__c = 'CRWASG120512011';
        c2.Effort_for_Project__c = '1';
        Insert c2;
        List<Campaign> lstCamp = [Select source_code__c from campaign where source_code__c != null and campaign_name__c = 'Annual' and station__c = 'KCRW' limit 1];  
        String sourcecode = '';
        if(lstCamp != null && lstCamp.size()>0){
            sourcecode = lstCamp[0].source_code__c;
        }   
        WGBH_PB5_UPLOAD__c PB = new WGBH_PB5_UPLOAD__c();

        pb.PB5_PAYMENT_AMOUNT__c = 25.00;  
        pb.PB5_END_CDATE_4__c = System.today();  
        pb.PB5_STATION_SOURCE__c = 'KCRW';  
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
        pb.PB5_LAST_NAME__c = 'Test1234';  
        pb.PB5_CLASSIFICATION_VALUE_4__c = 'YCK';  
        pb.PB5_CLASSIFICATION_VALUE_6__c = 'YCH';  
        pb.PB5_UPLOAD_SOURCE__c = 'ARIA';  
        pb.PB5_IS_NEW__c = true;  
        pb.PB5_SUFFIX__c = 'Sr.';  
        pb.PB5_CITY__c = 'pb5 5';  
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
        pb.PB5_EMAIL_ADDRESS_2__c = 'test5@pb5.com';  
        pb.PB5_END_CDATE_3__c = System.today();  
        pb.PB5_FIRST_NAME__c = 'Test1234';  
        pb.PB5_START_CDATE_1__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_5__c = 'Y MEMBERTYPE'; 
        pb.PB5_END_CDATE_5__c = System.today();   
        pb.PB5_IS_PROCESSED__c = false;  
        //pb.PB5_SOURCE__c = 'GBHAO2110504003';  
        if(sourcecode != ''){
            pb.PB5_Source__c = sourcecode;
        }else{
            pb.PB5_Source__c = c2.source_code__c; 
        }
        pb.PB5_START_CDATE_2__c = System.today();  
        pb.PB5_TELEPHONE_TYPE_2__c = 'FH';  
        pb.IS_DUPLICATE__c = false;  
        pb.PB5_INSTALLMENT_AMOUNT__c = 25.00;  
        pb.PB5_PAYMENT_METHOD__c = 'Sage Discover';  
        pb.PB5_GIFT_KIND__c = 'SG';  
        pb.PB5_EMAIL_TYPE_2__c = 'Work';  
        pb.Flag_for_Review__c = false;  
        pb.PB5_TRANSACTION_TYPE__c = 'PLEDGE WITH PAYMENT';   
        pb.PB5_GIFT_TYPE__c = 'NEW';      
        insert pb;     

            BatchUploadRecordMatchingProcessTest.BatchUploadRecordMatchingProcess(pb.Id);
        Test.StopTest(); 
    }
    */
}