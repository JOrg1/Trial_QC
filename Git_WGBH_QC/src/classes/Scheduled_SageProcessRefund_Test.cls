@istest
class Scheduled_SageProcessRefund_Test {
    static testmethod void test() {
        Test.startTest();
            Scheduled_SageProcessRefund batchSchedule = new Scheduled_SageProcessRefund();
            batchSchedule.execute(null);
        Test.stopTest();
   }
}