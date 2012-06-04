@isTest
private class Test_PB5UploadProcess{

    static testMethod void Test_PB5UploadProcess() {
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
        pb.PB5_LAST_NAME__c = 'pb5 4';  
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
        pb.PB5_FIRST_NAME__c = 'test 4';  
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
    }
    
}