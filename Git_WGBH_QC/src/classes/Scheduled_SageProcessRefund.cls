global class Scheduled_SageProcessRefund implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        if(!Test.IsRunningTest()) Refund_Batch.Refund_Batch();
    }
}