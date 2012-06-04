global class Scheduled_SageTransactionRefund implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        if(!Test.IsRunningTest()) Batch_Transactions.Batch_Transactions();
    }
}