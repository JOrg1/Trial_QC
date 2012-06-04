@istest
class Scheduled_PB5Process_Test {
    static testmethod void test() {
        Test.startTest();
            Scheduled_PB5Process batchSchedule = new Scheduled_PB5Process();
            batchSchedule.execute(null);
        Test.stopTest();
   }
}