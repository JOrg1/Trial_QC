trigger trgCampaignStatusAfterInsert on Campaign (After Insert) {
    List<CampaignMemberStatus> lstStatus = new List<CampaignMemberStatus>();
    Boolean blnInsertedFound = false;
    Integer sortOrder = 1;
    String CampaignId = Trigger.New[0].Id;

    Set<String> ExistingStatus = new Set<String>();
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
    
    lstStatus = [Select Id, Label, IsDefault, SortOrder From CampaignMemberStatus Where CampaignId =: CampaignId];
    if(lstStatus != null && lstStatus.size()>0){
        for(CampaignMemberStatus status:lstStatus){
            sortOrder++;
            ExistingStatus.add(status.Label);
        }
    }
    
    List<CampaignMemberStatus> lstCampaignMemStatus = new List<CampaignMemberStatus>();

    for(String s: sStatus) {
        if(ExistingStatus.Contains(s)==false) {
            CampaignMemberStatus objCampaignMemStatus = new CampaignMemberStatus();
            objCampaignMemStatus.Label = s;
            if(s==DefaultStatus) objCampaignMemStatus.IsDefault = true;
            objCampaignMemStatus.CampaignId = CampaignId;
            objCampaignMemStatus.SortOrder = SortOrder;
            lstCampaignMemStatus.add(objCampaignMemStatus);
            SortOrder++;
        }
    }

    if(lstCampaignMemStatus.size()>0) {
        try{
            Insert lstCampaignMemStatus;
        }Catch(Exception ex){
        }
    }
}