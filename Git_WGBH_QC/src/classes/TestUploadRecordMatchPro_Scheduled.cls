@istest

class TestUploadRecordMatchPro_Scheduled {

   static testmethod void test() {
        Test.startTest();
        
        String jobId = System.schedule('UploadRecordMatchingProcess_Scheduled',
        '0 0 0 3 9 ? 2022', 
        new UploadRecordMatchingProcess_Scheduled());
        Test.stopTest();
   }
}