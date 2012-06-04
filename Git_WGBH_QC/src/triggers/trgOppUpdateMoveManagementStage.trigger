trigger trgOppUpdateMoveManagementStage on Opportunity (After Update) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
 ID rtMG = null;    
    List<RecordType> lstRT = [Select ID from RecordType where DeveloperName = 'Major_Gifts' limit 1];
    for(RecordType r: lstRT) {
        rtMG = r.Id;
    }
    
    if(Trigger.new[0].RecordTypeID!=rtMG) return;
    
    Set<ID> OppIDs = new Set<ID>();
    Set<ID> CampIDs = new Set<ID>();
    
    for(Opportunity opp: Trigger.New) {
        if(opp.RecordTypeID==rtMG) {
            if(Trigger.IsUpdate && opp.StageName!=Trigger.OldMap.get(opp.Id).StageName) {
                OppIDs.add(opp.Id);
                CampIDs.add(opp.CampaignID);
            }
        }
    }
    
    if(OppIDs.size()>0) {
        List<CampaignMember> lstCM = 
            [Select ID,Moves_Management_Stage__c,Giving__r.StageName from CampaignMember where Giving__c IN: OppIds and CampaignID IN: CampIDs];
        
        for(CampaignMember c: lstCM) {
            c.Moves_Management_Stage__c = c.Giving__r.StageName;
        }
       
        if(lstCM.size()>0) update lstCM;

    }
}