global class Scheduled_GivingSummaryGrace implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        BatchGivingSummaryGrace.BatchGivingSummaryGrace();
    }
    
    static testmethod void test() {
        Test.startTest();
        String jobId = System.schedule('testBasicScheduledApex',
                '0 0 0 3 9 ? 2022',
                new Scheduled_GivingSummaryGrace());
        Test.stopTest();
    }
}