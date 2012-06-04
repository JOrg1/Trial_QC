trigger trgRefundUpdateGivingStage on Refund__c (After Insert) {
    Set<ID> sOppIDs = new Set<ID>();
    Set<ID> sGivingId = new Set<ID>();
    
    for(Refund__c r: Trigger.New) {
        if(sOppIDs.contains(r.Giving__c)==false) {
            sOppIDs.add(r.Giving__c);
            sGivingId.add(r.Giving__c);
        }
    }
    
    Map<ID,Decimal> MapRefund = new Map<ID,Decimal>();
    
    AggregateResult[] groupedResults = [SELECT Giving__c, SUM(Refund_Amount__c) RefundSum FROM Refund__c where Giving__c IN: sOppIds
                    GROUP BY Giving__c];
    for (AggregateResult ar : groupedResults) {
        MapRefund.put((ID)ar.get('Giving__c'),(Decimal)ar.get('RefundSum'));
    }    
    
    Map<ID,Opportunity> MapOpp = new Map<ID,Opportunity> ([Select ID,Recurring_Donation_Opportunity__c, Refund_Type__c, StageName, Payment_amount__c
                                from Opportunity where ID IN: sOppIDs]);
    
    Set<ID> sParentOppIDs = new Set<ID>();
    
    List<Opportunity> lstOpp = MapOpp.Values();
    
    for(Opportunity mOpp: lstOpp) {
        if(mOpp.Recurring_Donation_Opportunity__c!=null) {
            if(sParentOppIDs.Contains(mOpp.Recurring_Donation_Opportunity__c)==false) {
                sParentOppIDs.add(mOpp.Recurring_Donation_Opportunity__c);
            }
        }
    }
    
    List<Opportunity> lstUpdateOpp = new List<Opportunity>();
    
    for(Refund__c rf: Trigger.New) {
        if(mapOpp.containsKey(rf.Giving__c)) {
            Opportunity opp = mapOpp.get(rf.Giving__c);
            
            if(MapRefund.containsKey(rf.Giving__c)) {
                Decimal dRefund = MapRefund.get(rf.Giving__c);
                
                if(dRefund < opp.Payment_amount__c && dRefund > 0) {
                    opp.Refund_Type__c = 'Partial Refund';
                }
                else if(dRefund >= opp.Payment_amount__c && dRefund > 0) {
                    opp.Refund_Type__c = 'Full Refund';
                }
               
                //if(opp.Refund_Type__c == 'Full Refund') {
                //    opp.StageName = 'Uncollectible'; 
                               
                if(opp.Refund_Type__c == 'Full Refund') {
                    opp.StageName = 'REFUND';
                }
                if(opp.Payment_Amount__c>0) {
                    opp.Payment_Amount__c = opp.Payment_Amount__c - rf.Refund_Amount__c;
                }
            }
            
            lstUpdateOpp.add(opp);
        }
    }
    
    //if(lstUpdateOpp.size()>0) update lstUpdateOpp;
    if(lstUpdateOpp.size()>0){ 
        update lstUpdateOpp;
        for(Opportunity o:lstUpdateOpp){
            if(sGivingId.contains(o.Id)==false){
                sGivingId.add(o.Id);
            }
        }
    }
    
    List<Opportunity> lstParentOpp = [Select ID,Refund_Type__c, StageName, Payment_amount__c,
                                (Select ID, Refund_Type__c, StageName, Payment_amount__c from Giving_Installments__r)
                                from Opportunity where ID IN: sParentOppIDs];
                                
    for(Opportunity opp: lstParentOpp) {
        boolean IsPartial = true;
        Integer FullRefundCount = 0;
        
        for(Opportunity childOpp : opp.Giving_Installments__r) {
            if(childOpp.Refund_Type__c == 'Partial Refund') {
                IsPartial = true;
                break;
            }
            
            if(childOpp.Refund_Type__c == 'Full Refund') {
                FullRefundCount+=1;
            }
        }
        if(IsPartial==true) opp.Refund_Type__c = 'Partial Refund';
        
        if(opp.Giving_Installments__r.size()==FullRefundCount && opp.Giving_Installments__r.size()>0) {
            opp.Refund_Type__c='Full Refund';
            //opp.StageName = 'Uncollectible';
            opp.StageName = 'REFUND';
            
        }
    }
    
    //if(lstParentOpp.size()>0) update lstParentOpp;
    if(lstParentOpp.size()>0){
        update lstParentOpp;        
        for(Opportunity o:lstParentOpp){
            if(sGivingId.contains(o.Id)==false){
                sGivingId.add(o.Id);
            }
        }
    }
    if(sGivingId != null && sGivingId.size()>0){
        ProcessGivingSummary.UpdateSummary(sGivingId,true);
    }
    
}
/*trigger trgRefundUpdateGivingStage on Refund__c (After Insert) {
    Set<ID> sOppIDs = new Set<ID>();
    
    for(Refund__c r: Trigger.New) {
        if(sOppIDs.contains(r.Giving__c)==false) {
            sOppIDs.add(r.Giving__c);
        }
    }
    
    
    
    Map<ID,Opportunity> MapOpp = new Map<ID,Opportunity> ([Select ID, Refund_Type__c, StageName, Payment_amount__c,
                                (Select ID, Refund_Type__c, StageName, Payment_amount__c from Giving_Installments__r) 
                                from Opportunity where ID IN: sOppIDs]);
    
    List<Opportunity> lstUpdateOpp = new List<Opportunity>();
    
    for(Refund__c rf: Trigger.New) {
        if(mapOpp.containsKey(rf.Giving__c)==true) {
            Opportunity opp = mapOpp.get(rf.Giving__c);
            
            if(rf.Refund_Amount__c < opp.Payment_amount__c && rf.Refund_Amount__c > 0) {
                opp.Refund_Type__c = 'Partial Refund';
            }
            else if(rf.Refund_Amount__c >= opp.Payment_amount__c && rf.Refund_Amount__c > 0) {
                opp.Refund_Type__c = 'Full Refund';
            }
            
            if(opp.Refund_Type__c == 'Full Refund') {
                opp.StageName = 'Uncollectible';
            }
            
            opp.Payment_Amount__c = opp.Payment_Amount__c - rf.Refund_Amount__c;

            lstUpdateOpp.add(opp);
            
            for(Opportunity childOpp : opp.Giving_Installments__r) {
                if(opp.Refund_Type__c == 'Full Refund') {
                    childOpp.Refund_Type__c = 'Full Refund';
                    childOpp.StageName = 'Uncollectible';
                    lstUpdateOpp.add(childOpp);
                }
            }
        }
    }
    
    if(lstUpdateOpp.size()>0) update lstUpdateOpp;
    
}*/