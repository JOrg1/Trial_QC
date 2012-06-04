trigger trgOppBeforeInsertUpdate on Opportunity (Before Insert, Before Update) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
    Map<ID,ID> mapCCID = new Map<ID,ID>();
    Map<ID,String> mapPaymentMethod = new Map<ID,String>();
    for(Opportunity opp: Trigger.new) {
        if(opp.Recurring_Donation_Opportunity__c == null && opp.CC_EFT_Alias__c != null){
            mapCCID.put(opp.Id, opp.CC_EFT_Alias__c);
            mapPaymentMethod.put(opp.Id, opp.Payment_Method__c);
        }
    }
    for(Opportunity opp: Trigger.new) {
        if(opp.Gift_Date_Time__c!=null) {
            opp.Gift_Date_3_Month__c = opp.Gift_Date_Time__c.Date().addMonths(3);
            opp.Gift_Date_6_Month__c = opp.Gift_Date_Time__c.Date().addMonths(6);
            opp.Gift_Date_18_Month__c = opp.Gift_Date_Time__c.Date().addMonths(18);
        }
        system.debug('###### Trigger before insert/update : ' + opp.Recurring_Donation_Opportunity__c);
        if(opp.Recurring_Donation_Opportunity__c != null){
            system.debug('###### Trigger before insert/update CCID : ' + opp.Recurring_Donation_Opportunity__r.CC_EFT_Alias__c);
            if(opp.StageName == 'Pledged'){
                if(mapCCID != null && mapCCID.size()>0 && mapCCID.containsKey(opp.Recurring_Donation_Opportunity__c)){
                    opp.CC_EFT_Alias__c = mapCCID.get(opp.Recurring_Donation_Opportunity__c);
                }
                if(mapPaymentMethod != null && mapPaymentMethod.size()>0 && mapPaymentMethod.containsKey(opp.Recurring_Donation_Opportunity__c)){
                    opp.Payment_Method__c = mapPaymentMethod.get(opp.Recurring_Donation_Opportunity__c);
                }
            }
        }
    }
}