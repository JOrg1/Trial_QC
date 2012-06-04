trigger trgCampaignMemberUpdateMoveMgmtStage on CampaignMember (After Update) {
    //Giving__c
    Set<ID> setOppIds = new Set<ID>();
    Map<ID,String> mapGivingStage = new Map<ID, String>();
    // Trigger.oldMap.keySet()
    for(CampaignMember member:Trigger.New){
        if(member.Giving__c != null && member.Moves_Management_Stage__c != null){
            setOppIds.add(member.Giving__c);
            mapGivingStage.put(member.Giving__c, member.Moves_Management_Stage__c);
        }
    }
    if(setOppIds != null && setOppIds.size()>0){
        List<Opportunity> lstGiving = [Select Id, StageName From Opportunity Where Id In:setOppIds];
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity opp:lstGiving){
                if(mapGivingStage != null && mapGivingStage.size()>0 && mapGivingStage.containsKey(opp.Id)){
                    opp.StageName = mapGivingStage.get(opp.Id);
                }
            }
            
            Update lstGiving;
        }
    }
}