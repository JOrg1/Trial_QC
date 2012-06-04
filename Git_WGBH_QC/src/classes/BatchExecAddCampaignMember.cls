global class BatchExecAddCampaignMember implements Database.Batchable<sObject> {
    global final String Query;
    global final boolean isContact;
    global final String Status;
    global final ID CampaignId;
    global final ID RequestId;
    Boolean blnSuccess = false;
    global BatchExecAddCampaignMember(String q, String MemberStatus, boolean isContactId, ID CampId, ID reqId){
        Query = q;
        isContact = isContactId;
        Status = MemberStatus;
        CampaignId = CampId;
        RequestId = reqId;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        DoBatchSearchContact(scope);
    }
   Public String NVL(String val){
        if(val == null){
            return '';
        }
        else{
            return val.trim();
        }
    }
    void DoBatchSearchContact(List<sObject> scope){
        Set<ID> setIds = new Set<ID>();
        system.debug('####### batch started 1');
        if(scope != null && scope.size()>0){
            try{
        system.debug('####### batch started 2');
                for(sObject s:scope){
                    /*
                    String sid = NVL(String.valueOf(s.get('ID__c')));
                    if(sid != '' && setIds.contains(sid)==false){
                        setIds.add(sid);
                    }
                    */
                    if(isContact == true){
                        String sid = NVL(String.valueOf(s.get('ContactLookup__c')));
                        if(sid != '' && setIds.contains(sid)==false){
                            setIds.add(sid);
                        }
                    }
                    else{
                        String sid = NVL(String.valueOf(s.get('LeadLookup__c')));
                        if(sid != '' && setIds.contains(sid)==false){
                            setIds.add(sid);
                        }
                    }
                }
                system.debug('######## set of Ids : ' + setIds);
                if(setIds != null && setIds.size()>0){
                    List<CampaignMember> lstMember;
                    if(isContact == true){
                        lstMember = [Select Id, ContactId, Status From CampaignMember Where ContactId <> null and ContactId in:setIds and CampaignId =: CampaignId];
                    }
                    else{
                        lstMember = [Select Id, LeadId, Status From CampaignMember Where LeadId <> null and LeadId in:setIds and CampaignId =: CampaignId];
                    }
                    List<CampaignMember> lstInsert = new List<CampaignMember>();
                    List<CampaignMember> lstUpdate = new List<CampaignMember>();
                    for(ID sid:setIds){
                        Boolean blnFound = false;
                        for(CampaignMember mem:lstMember){
                            ID memId;
                            if(isContact == true){
                                memId = mem.ContactId;
                            }else{
                                memId = mem.LeadId;
                            }
                            if(memId == sid){
                                mem.Status = Status;
                                lstUpdate.add(mem);
                                blnFound = true;
                            }
                        }
                        if(blnFound == false){
                            CampaignMember cm = new CampaignMember();
                            cm.Status = Status;
                            if(isContact == true){
                                cm.ContactId = sid;
                            }
                            else{
                                cm.LeadId = sid;
                            }
                            cm.CampaignId = CampaignId;
                            lstInsert.add(cm);
                        }
                    }
                    system.debug('########### Insert : ' + lstInsert);
                    system.debug('########### Insert : ' + lstUpdate);
                    if(lstInsert != null && lstInsert.size()>0) insert lstInsert;
                    if(lstUpdate != null && lstUpdate.size()>0) update lstUpdate;
                    blnSuccess = true;
                }            
            }
            catch(Exception ex){
                blnSuccess = false;
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
        if(blnSuccess == true){
            List<Search_Result__c> lstResult;
            lstResult = [Select Id From Search_Result__c Where Request__c =: RequestId];
            if(lstResult != null && lstResult.size()>0){
                delete lstResult;
            }
        }
        System.debug('####Update Completed...');
    }

    static testMethod void TestBatchExecAddCampaignMember() {
       
    }
}