trigger trgCampaignMemberStatus on Campaign (After Insert, After Update) {
    List<CampaignMemberStatus> lstStatus = new List<CampaignMemberStatus>();
    Boolean blnInsertedFound = false;
    
    
    Set<ID> sCampaignIDs = new Set<ID>();

    
    Set<String> sStatus = new Set<String>();
    sStatus.add('Sent');    
    sStatus.add('Responded');
    sStatus.add('Inserted');
    sStatus.add('Held');
    sStatus.add('Removed');
    sStatus.add('Custom');
    sStatus.add('Attended');
    sStatus.add('RSVP');


    String DefaultStatus = 'Inserted';
    
    
    for(Campaign cmpgn: Trigger.New) {
        sCampaignIDs.add(cmpgn.Id);
    }
    
    lstStatus = [Select Id, Label,CampaignId, IsDefault, SortOrder From CampaignMemberStatus Where CampaignId IN: sCampaignIDs];

    List<CampaignMemberStatus> lstCampaignMemStatus = new List<CampaignMemberStatus>();

    for(Campaign c: Trigger.New) {
        Set<String> ExistingStatus = new Set<String>();
        
        Integer sortOrder = 1;
        
        for(CampaignMemberStatus cmStatus:lstStatus){
            if(c.Id == cmStatus.CampaignID) {
                sortOrder++;
                ExistingStatus.add(cmStatus.Label);
            }
        }
        
        for(String s: sStatus) {
            if(ExistingStatus.Contains(s)==false) {
                CampaignMemberStatus objCampaignMemStatus = new CampaignMemberStatus();
                objCampaignMemStatus.Label = s;
                if(s==DefaultStatus) objCampaignMemStatus.IsDefault = true;
                objCampaignMemStatus.CampaignId = c.Id;
                objCampaignMemStatus.SortOrder = SortOrder;
                lstCampaignMemStatus.add(objCampaignMemStatus);
                SortOrder++;
            }
        }
    }

    if(lstCampaignMemStatus.size()>0) {
        try{
            Insert lstCampaignMemStatus;
        }Catch(Exception ex){
        }
    }
}