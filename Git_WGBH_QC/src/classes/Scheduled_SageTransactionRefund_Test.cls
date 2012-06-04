@istest
class Scheduled_SageTransactionRefund_Test {
    static testmethod void test() {
        Test.startTest();
            Scheduled_SageTransactionRefund batchSchedule = new Scheduled_SageTransactionRefund();
            batchSchedule.execute(null);
        Test.stopTest();
   }
}