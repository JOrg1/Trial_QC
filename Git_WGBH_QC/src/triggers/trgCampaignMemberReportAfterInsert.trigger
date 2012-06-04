trigger trgCampaignMemberReportAfterInsert on CampaignMember (After Insert) {
    Set<ID> cMemberIDs = new Set<ID>();
    
    Map<ID,ID> campaignMem = new Map<ID,ID>();
    List<Campaign_Member_Report__c> lstcmr = new List<Campaign_Member_Report__c>();
    for(CampaignMember cm: Trigger.new) {
       
        if(cm.contactid != null){
            cMemberIDs.add(cm.ID);
            Campaign_Member_Report__c cmr = new Campaign_Member_Report__c();
            cmr.Campaign__c = cm.CampaignId;
            cmr.Campaign_Member_Id__c = cm.Id;
            cmr.Contact__c = cm.ContactId;
            lstcmr.add(cmr);
            //insert cmr;    
        }
        /*else{
            Campaign_Member_Report__c cmr = new Campaign_Member_Report__c();
        }*/      
        
    }
    if (lstcmr.size()>0) {
        insert lstcmr;
        
        List<CampaignMember> lstcampMem = [select id from CampaignMember where Id IN: cMemberIDs];
        
        for(CampaignMember cm : lstcampMem){
            for(Campaign_Member_Report__c cmr : lstcmr){
                if(cmr.Campaign_Member_Id__c == cm.Id){
                    cm.Campaign_Member_Report__c = cmr.Id;
                    break;
                }
            }
        }
        if(lstcampMem.size()>0)update lstcampMem;
    }
    
        
    
}