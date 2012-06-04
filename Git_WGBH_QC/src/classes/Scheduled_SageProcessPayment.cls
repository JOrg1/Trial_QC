global class Scheduled_SageProcessPayment implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        if(!Test.IsRunningTest()) Payment_Batch.Payment_Batch();
    }
}