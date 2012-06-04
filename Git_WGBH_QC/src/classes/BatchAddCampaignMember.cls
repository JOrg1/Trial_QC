global class BatchAddCampaignMember{
    Public static void BatchSearchContact(ID RequestID, ID CampaignId, String Status, Boolean isContact) {
        ID batchprocessid;
        BatchExecAddCampaignMember reassign;  
        if(RequestID == null){
            return;
        }
        String Query;
        List<Search_Request__c> lstRequest = [Select Criteria__c From Search_Request__c Where Id=:RequestID];
        if(isContact == true){
            Query = 'Select ContactLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and Contact__c = true and Lead__c = false';
        }
        else{
            Query = 'Select LeadLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and Contact__c = false and Lead__c = true';
        }
        if(Test.isRunningTest()) Query += ' Limit 100';
        reassign = new BatchExecAddCampaignMember(Query, Status, isContact, CampaignId, RequestID);
        batchprocessid = Database.executeBatch(reassign, 400);
    }    
}