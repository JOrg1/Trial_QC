trigger tempSetGivingSummary on Opportunity(after update) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger != 'yes'){
        return;
    }
    ///////////////////////////////////
    Set<ID> accountIds = new Set<ID>();
    
    for(Opportunity o:Trigger.New){
        if(o.AccountId != null){
            accountIds.add(o.AccountId);
        }
    }
    
    Map<ID, List<Giving_Summary__c>> mapSummary = new Map<ID, List<Giving_Summary__c>>();
    
    if(accountIds.size()>0){
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        lstSummary = [Select id, GivingIds__c from Giving_Summary__c Where Account__c in:accountIds];
        if(lstSummary != null && lstSummary.size()>0){
            for(ID aid:accountIds){
                List<Giving_Summary__c> temp = new List<Giving_Summary__c>();
                for(Giving_Summary__c g:lstSummary){
                    temp.add(g);
                }
                if(temp.size()>0){
                    mapSummary.put(aid, temp);
                }
            }
        }
    }
    
    for(Opportunity giving:Trigger.New){
        Set<ID> setGivingIDs = new Set<ID>();
        setGivingIds.add(giving.Id);
        ID AccountId = giving.AccountId;
        Boolean blnInsert = true;
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        if(mapSummary != null && mapSummary.size()>0 && mapSummary.containsKey(AccountId)){
            lstSummary = mapSummary.get(AccountId);
            if(lstSummary != null && lstSummary.size()>0){
                for(Giving_Summary__c gs:lstSummary){
                    if(gs.GivingIds__c != null && gs.GivingIds__c != '' && gs.GivingIds__c.contains(String.valueOf(giving.Id).substring(0,15))){
                        blnInsert = false;
                    }
                }
            }
            else{
                blnInsert = true;
            }
        }
        if(blnInsert == false){
            ProcessGivingSummaryTrigger.UpdateSummary(setGivingIds,true);//for update     
        }
        else{
            ProcessGivingSummaryTrigger.UpdateSummary(setGivingIds,false);//for insert
        }
    }
    /*
    if(opp.Recurring_Donation_Opportunity__c == null){
        Set<ID> setGivingIDs = new Set<ID>();
        setGivingIds.add(opp.Id);
        
        String AccountId = opp.AccountId;
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        lstSummary = [Select id, GivingIds__c from Giving_Summary__c Where Account__c=:AccountId];
        
        Boolean blnInsert = true;
        
        if(lstSummary != null && lstSummary.size()>0){
            for(Giving_Summary__c gs:lstSummary){
                if(gs.GivingIds__c != null && gs.GivingIds__c != '' && gs.GivingIds__c.contains(String.valueOf(opp.Id).substring(0,15))){
                    blnInsert = false;
                }
            }
        }
        else{
            blnInsert = true;
        }
        if(blnInsert == false){
            ProcessGivingSummaryTrigger.UpdateSummary(setGivingIds,true);//for update     
        }
        else{
            ProcessGivingSummaryTrigger.UpdateSummary(setGivingIds,false);//for insert
        }
        
    }
    */
}