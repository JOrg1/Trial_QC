@istest
class Scheduled_SageProcessPayment_Test {
    static testmethod void test() {
        Test.startTest();
            Scheduled_SageProcessPayment batchSchedule = new Scheduled_SageProcessPayment();
            batchSchedule.execute(null);
        Test.stopTest();
   }
}