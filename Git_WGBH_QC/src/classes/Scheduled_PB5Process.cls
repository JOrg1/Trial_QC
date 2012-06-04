global class Scheduled_PB5Process implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        if(!Test.IsRunningTest()) BatchUploadRecordMatchingProcess.BatchUploadRecordMatchingProcess();
    }
}