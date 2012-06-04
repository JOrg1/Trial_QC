global class BatchSearchRequest{
    Public static void BatchSearchRequest(ID RequestID, boolean isContact, String CampaignId) {
        ID batchprocessid;
        //BatchExecSearchRequest reassign;  
        BatchExecSearchRequestNew reassign;  
        if(RequestID == null){
            return;
        }
        //////////////
        String RequestedBy = '';
        List<Search_Request__c> lstRequest = [Select CreatedById From Search_Request__c Where Id=:RequestId];
        if(lstRequest != null && lstRequest.size()>0){
            RequestedBy = lstRequest[0].CreatedById;
        }
        //////////////
        
        String Query = 'Select Id, FieldName__c, Index__c, Query__c, Request__c, Status__c, Campaign__c, CreatedById, Operation__c From Requested_Search__c ';
        Query += 'Where Request__c = \'' + RequestID + '\' and Status__c = \'Pending\' Order by Index__c';
        /*
        reassign = new BatchExecSearchRequest(Query, RequestID, isContact, CampaignId, RequestedBy);
        batchprocessid = Database.executeBatch(reassign, 1);
        */        
        reassign = new BatchExecSearchRequestNew(Query, RequestID, isContact, CampaignId, RequestedBy);
        batchprocessid = Database.executeBatch(reassign, 1);
    }
}