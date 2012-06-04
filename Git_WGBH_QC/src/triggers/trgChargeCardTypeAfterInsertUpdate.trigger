trigger trgChargeCardTypeAfterInsertUpdate on CC_Alias__c (Before Insert, Before Update) {
    Set<ID> ccId = new Set<ID>();
    for(CC_Alias__c cc:Trigger.New){
        //if(cc.PaymentTypeID__c != null && cc.PaymentTypeID__c <> Trigger.oldMap.get(cc.id).PaymentTypeID__c){
        if(cc.PaymentTypeID__c != null){
            ccId.add(cc.Id);
            cc.Card_Type__c = PaymentType__c.getValues(cc.PaymentTypeID__c).Charge_Card_Type__c;
        }
    }
    /*
    if(ccId.size()>0){
        List<CC_Alias__c> lstCC = [Select id, Card_Type__c, PaymentTypeID__c, 
            (Select id, Charge_Card_Type__c from Opportunities__r) from CC_Alias__c Where id in:ccId];
            
        Map<String, PaymentType__c> mapPaymentType = PaymentType__c.getAll();
        
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        
        if(mapPaymentType != null && mapPaymentType.size()>0){
            for(CC_Alias__c cc: lstCC){
                cc.Card_Type__c = String.valueOf(mapPaymentType.get(cc.PaymentTypeID__c).Charge_Card_Type__c);
                for(Opportunity opp:cc.Opportunities__r){
                    opp.Charge_Card_Type__c = cc.Card_Type__c;
                    lstOpp.add(opp);
                }
            }
            
            if(lstCC != null && lstCC.size()>0){    
                update lstCC;
            }
            if(lstOpp != null && lstOpp.size()>0){
                update lstOpp;
            }
        }
    }
    */
}