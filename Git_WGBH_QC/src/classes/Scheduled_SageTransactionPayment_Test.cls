@istest
class Scheduled_SageTransactionPayment_Test {
    static testmethod void test() {
        Test.startTest();
            Scheduled_SageTransactionPayment batchSchedule = new Scheduled_SageTransactionPayment();
            batchSchedule.execute(null);
        Test.stopTest();
   }
}