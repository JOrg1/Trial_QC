trigger tempUpdateGiftType on Opportunity (before update){
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger != 'yes'){
        return;
    }
    ///////////////////////////////////
    for(Opportunity opp: Trigger.New){
        String CurrentGiftType = commonApex.NVL(opp.Gift_Type__c).toUpperCase();
        if(CurrentGiftType == 'RN' || CurrentGiftType == 'RENEW'){
            opp.Gift_Type__c = 'Renewal';
        }
        if(CurrentGiftType == 'AD' || CurrentGiftType == 'ADDITIONAL GIFT'){
            opp.Gift_Type__c = 'Add Gift';
        }
        if(CurrentGiftType == 'RJ'){
            opp.Gift_Type__c = 'Rejoin';
        }
        if(CurrentGiftType == 'NW'){
            opp.Gift_Type__c = 'New';
        }
    }
}