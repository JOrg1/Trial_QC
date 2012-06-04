trigger trgApplyCPRTBeforeInsertUpdate on Opportunity (Before Update, Before Insert){
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////Charge card from CC
    Set<ID> setOppIds = new Set<ID>();
    Set<ID> setCCid = new Set<ID>();
    for(Opportunity opp:Trigger.New){
        if(opp.CC_EFT_Alias__c != null){
            setOppIds.add(opp.Id);
            setCCid.add(opp.CC_EFT_Alias__c);
        }
    }
    if(setCCid != null && setCCid.size()>0){
        List<CC_Alias__c> lstCC = [Select id, Card_Type__c from CC_Alias__c where id in:setCCid];
        Map<ID, string> mapCC = new Map<ID, string>();
        if(lstCC != null && lstCC.size()>0){
            for(CC_Alias__c cc:lstCC){
                mapCC.put(cc.id, cc.Card_Type__c);
            }
        }
        if(mapCC != null && mapCC.size()>0){
            for(Opportunity opp:Trigger.New){
                if(opp.CC_EFT_Alias__c != null){
                    if(mapCC.containsKey(opp.CC_EFT_Alias__c)==true){
                        opp.Charge_Card_Type__c = mapCC.get(opp.CC_EFT_Alias__c);
                    }
                }
            }
        }
    }
    /*
    if(setOppIds != null && setOppIds.size()>0){
        List<Opportunity> lstOpp = [Select Id, CC_EFT_Alias__r.Card_Type__c From Opportunity where id in:setOppIds];
        Map<ID,String> mapCardType = new Map<ID,String>();
        if(lstOpp != null && lstOpp.size()>0){
            for(Opportunity opp:lstOpp){
                mapCardType.put(opp.id, opp.CC_EFT_Alias__r.Card_Type__c);
            }
        }
        if(mapCardType != null && mapCardType.size()>0){
            for(Opportunity opp:Trigger.New){
                if(mapCardType.containsKey(opp.Id)){
                    opp.Charge_Card_Type__c = mapCardType.get(opp.Id);
                }
            }
        }
    }
    */
    ///////////////////////////////////
    String applyCprt = System.Label.ApplyCPRTGiving;
    if(applyCprt != null && applyCprt == 'yes'){
        Set<ID> setCampaignId = new Set<ID>();
        Map<ID, Campaign> mapCPRT = new Map<ID, Campaign>();
        for(Opportunity opp:Trigger.New){
            setCampaignId.add(opp.CampaignId);
        }
        List<Campaign> lstCPRT = new List<Campaign>();
        if(setCampaignId != null && setCampaignId.size()>0){
            lstCPRT = [Select Id, Giving_Segment__c, Support_Designation__c, station__c,
            Response_Mechanism__c, Product_Program__c, TA_Campaign_Source_Code__c, Source_Code__c,
            Campaign_Name__c, TV_Radio_Show_Program__r.Name, Solicitation_Type__c
            From Campaign Where Id in: setCampaignId];
            
            if(lstCPRT != null && lstCPRT.size()>0){
                for(Campaign c:lstCPRT){
                    mapCPRT.put(c.Id, c);
                }
            }
            for(Opportunity opp:Trigger.New){
                Campaign objCPRT;
                if(mapCPRT != null && mapCPRT.size()>0 && mapCPRT.containsKey(opp.CampaignId)==true){
                    objCPRT = mapCPRT.get(opp.CampaignId);
                    if(objCPRT != null){
                        opp.CampaignId = objCPRT.Id;
                        opp.Giving_Segment__c = objCPRT.Giving_Segment__c;
                        opp.Support_Designation__c = objCPRT.Support_Designation__c;
                        opp.station__c = objCPRT.station__c;
                        /**** WGBHQC-40 (JIRA) https://roundcorner.atlassian.net/browse/WGBHQC-40***/
                        //opp.Response_Mechanism__c = objCPRT.Response_Mechanism__c;
                        /**********************************************************/
                        opp.product__c = objCPRT.Product_Program__c;
                        opp.ta_campaign__c = objCPRT.TA_Campaign_Source_Code__c;
                        opp.Source_Code__c = objCPRT.Source_Code__c;
                        opp.Campaign_Name__c = objCPRT.Campaign_Name__c;
                        opp.program__c = objCPRT.TV_Radio_Show_Program__r.Name;
                        opp.Solicitation_Type__c = objCPRT.Solicitation_Type__c;                        
                    }
                }
            }
        }
    }
}