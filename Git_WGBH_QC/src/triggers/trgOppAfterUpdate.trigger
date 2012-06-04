trigger trgOppAfterUpdate on Opportunity (After Update) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
    Set<ID> OppIDs = new Set<ID>();
    
    for(Opportunity opp: Trigger.New) {
        if(opp.Remove_Opportunity__c == true) {
            OppIDs.add(opp.id);
        }
    }
    if(OppIDs.size()>0) {
        List<Opportunity> lstOppDelete = [Select ID from Opportunity where ID IN:OppIDs];
    
        if(lstOppDelete.size()>0) delete lstOppDelete;
    }
}