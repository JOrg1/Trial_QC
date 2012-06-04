global class BatchFinalizeSearchRequest{
    Public static void BatchFinalizeSearchRequest(ID RequestID) {
        ID batchprocessid;
        //BatchExecSearchRequest reassign;
        BatchExecFinalizeSearchRequest reassign;
        if(RequestID == null){
            return;
        }
        List<Search_Request__c> lstRequest = [Select id, Criteria__c, Campaign__c, IsContact__c, Template__c From Search_Request__c Where Id =: RequestId];
        
        String AdvanceFilter = '';
        Id CampaignId;
        Boolean IsContact;
        if(lstRequest != null && lstRequest.size()>0){
            List<AggregateResult> lstMax = [Select Max(Index__c) maxIndex From Requested_Search__c Where Request__c =: RequestID];
            Integer noOfquery = 1;
            if(lstMax != null && lstMax.size()>0){
                noOfquery = Integer.valueOf(String.valueOf(lstMax[0].get('maxIndex')));
            }
            AdvanceFilter = lstRequest[0].Criteria__c;
            CampaignId = lstRequest[0].Campaign__c;
            IsContact = lstRequest[0].IsContact__c;
            String Query = GenerateQuery(RequestId, IsContact, AdvanceFilter, noOfquery);
            system.debug('######## Query ' + Query);
            reassign = new BatchExecFinalizeSearchRequest(Query, RequestID, IsContact, lstRequest[0].Campaign__c);
            batchprocessid = Database.executeBatch(reassign);
        }
    }
    
    Static String Queryfields(Boolean IsContact){
        String fields = '';
        if(IsContact == false){
            fields = ' id, FirstName, LastName, Title, Company, Email ';
        }
        else if(IsContact == true){
            fields = ' id, FirstName, LastName, Title, Account.Name, Email, AccountId ';
        }
        return fields;
    }
    Static string GenerateQuery(ID queryRequestId, Boolean IsContact, String AdvanceFilter, Integer noOfConditions){
        List<sObject> lstFinal;
        String query = '';
        if(IsContact == true){
            query = 'Select ' + Queryfields(IsContact) + ' from Contact ';
        }
        else{
            query = 'Select ' + Queryfields(IsContact) + ' from Lead ';
        }
        String rQuery;
        if(IsContact == true){
            rQuery = 'Select ContactLookup__c From Search_Result__c';
        }else{
            rQuery = 'Select LeadLookup__c From Search_Result__c';
        }
        String strAdv = '';
        if(NVL(AdvanceFilter)!=''){
            strAdv = AdvanceFilter;
            if(noOfConditions > 0){
                for(integer i=1;i<=noOfConditions;i++){
                    strAdv = strAdv.replace(' ' + string.valueOf(i) + ' ', ' col' + string.valueOf(i) + '__c = true ');
                    strAdv = strAdv.replace('(' + string.valueOf(i) + ' ', '(col' + string.valueOf(i) + '__c = true ');
                    strAdv = strAdv.replace(' ' + string.valueOf(i) + ')', ' col' + string.valueOf(i) + '__c = true) ');
                    system.debug('################# strAdv : ' + strAdv);
                }
                
            }
        }else{
            if(noOfConditions > 0){
                for(integer i=1;i<=noOfConditions;i++){
                    //strAdv = strAdv.replace(string.valueOf(i) + ' ', 'col' + string.valueOf(i) + '__c ');
                    
                    strAdv = strAdv.replace(' ' + string.valueOf(i) + ' ', ' col' + string.valueOf(i) + '__c = true ');
                    strAdv = strAdv.replace('(' + string.valueOf(i) + ' ', '(col' + string.valueOf(i) + '__c = true ');
                    strAdv = strAdv.replace(' ' + string.valueOf(i) + ')', ' col' + string.valueOf(i) + '__c = true) ');
                    if(strAdv == ''){
                        strAdv = ' col' + string.valueOf(i) + '__c = true ';
                    }
                    else{
                        strAdv += ' or col' + string.valueOf(i) + '__c = true ';
                    }
                    system.debug('################# strAdv : ' + strAdv);
                }
            }
        }
        rQuery += ' Where (' + strAdv + ') And Request__c = \'' + queryRequestId + '\'';
        Query += ' Where id in(' + rQuery + ')';
        
        return Query;
    }
    Static String NVL(String val){
        if(val == null){
            return '';
        }
        else{
            return val.trim();
        }
    }
}