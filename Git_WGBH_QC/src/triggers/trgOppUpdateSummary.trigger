trigger trgOppUpdateSummary on Opportunity (after insert, after update) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
    //UpdateSummary.UpdateGivingSummary(Trigger.New,true);
    Boolean action;
    if(Trigger.IsUpdate == true)
        action = true;
    else
        action = false;
        
    Set<ID> sOppIDs = new Set<ID>();
    
    for(Opportunity opp: Trigger.new) {
        sOppIDs.add(opp.Id);
    }
    
    //UpdateSummaryNew.UpdateGivingSummary(Trigger.New,action);
    //UpdateSummaryNew.UpdateGivingSummary(sOppIDs,action);
    //ProcessGivingSummary.UpdateSummary(sOppIDs, action);
}