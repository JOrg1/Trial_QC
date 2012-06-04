global class Scheduled_SageTransactionPayment implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        if(!Test.IsRunningTest()) Transaction_Batch.Transaction_Batch();
    }
}