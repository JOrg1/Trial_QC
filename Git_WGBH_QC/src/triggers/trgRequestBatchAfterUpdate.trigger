trigger trgRequestBatchAfterUpdate on Search_Request__c (After Update) {
system.debug('########### Trigger (Status__c) ' + Trigger.New[0].Status__c);
system.debug('########### Trigger (New: IsExecuteNextBatch) ' + Trigger.New[0].IsExecuteNextBatch__c);
system.debug('########### Trigger (Old: IsExecuteNextBatch) ' + Trigger.Old[0].IsExecuteNextBatch__c);
    /*
    if(Trigger.New[0].Status__c == 'Pending'){
        //if(Trigger.Old[0].IsExecuteNextBatch__c == true){
        //if(Trigger.Old[0].IsSubRequest__c != Trigger.New[0].IsSubRequest__c){
        if(Trigger.New[0].IsExecuteNextBatch__c == false && (Trigger.Old[0].IsExecuteNextBatch__c != Trigger.New[0].IsExecuteNextBatch__c)){
            BatchSearchRequest.BatchSearchRequest(Trigger.New[0].Id, Trigger.New[0].IsContact__c, Trigger.New[0].Campaign__c);
        }
        //
    }
    */
    Integer i = 0;
    for(Search_Request__c req:Trigger.New){
        if(req.Status__c == 'Pending'){
            if(req.IsExecuteNextBatch__c == false && (Trigger.Old[i].IsExecuteNextBatch__c != req.IsExecuteNextBatch__c)){
                BatchSearchRequest.BatchSearchRequest(req.Id, req.IsContact__c, req.Campaign__c);
            }
        }
        else if(req.Status__c == 'Completed'){
            if(req.Finalize__c == false && (Trigger.Old[i].Finalize__c != req.Finalize__c)){
                BatchFinalizeSearchRequest.BatchFinalizeSearchRequest(req.Id);
            }
        }
        i++;
        if(i==9)break;
    }
}