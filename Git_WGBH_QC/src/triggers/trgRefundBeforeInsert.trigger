trigger trgRefundBeforeInsert on Refund__c (Before Insert) {

    Set<ID> sGivingIDs = new Set<ID>();
    
    Set<ID> sRefundIDs = new Set<ID>();
    
    for(Refund__c r: Trigger.New) {
        if(!sGivingIDs.contains(r.Giving__c)) {
            sGivingIDs.add(r.Giving__c);
        }
    }
    
    MAP<ID,Opportunity> mapOpp = new MAP<ID,Opportunity> ([Select ID,Recurring_Donation_Opportunity__c,gift_kind__c, Payment_amount__c from Opportunity where ID IN: sGivingIDs]);
    
    RecordType r = [Select ID from RecordType where DeveloperName='Refund_by_Check' limit 1];
    
    ID RecordTypeID = r.ID;
    
    for(Refund__c rf: Trigger.New) {
        Decimal PaidAmount = 0.0;
        
        if(mapOpp.containsKey(rf.Giving__c)==true) {
            Opportunity opp = mapOpp.get(rf.Giving__c);
            if(opp.Payment_amount__c!=null) PaidAmount = opp.Payment_amount__c;

            if(opp.gift_kind__c !='One Payment' && opp.Recurring_Donation_Opportunity__c==null) {
                rf.addError('Can not add refund from parent pledge.');
                return;
            }
            system.debug('########## rf.Refund_Amount__c - ' + rf.Refund_Amount__c);
            system.debug('########## opp.Payment_amount__c - ' + opp.Payment_amount__c);
            
            if((rf.Refund_Amount__c>0 &&  opp.Payment_amount__c==null) || (rf.Refund_Amount__c > opp.Payment_amount__c)) {
                rf.addError('Can not add refund more than paid amount. Total paid amount is $' + String.valueOf(opp.Payment_amount__c) + '.');
                return;
            }
        }
        if(rf.RecordTypeID==RecordTypeID && rf.RFP_Submitted__c==false && rf.Refund_Status__c=='Submitted') {
            rf.addError('RFP submitted should be checked.');
        }
        
        if((rf.Status__c=='' || rf.Status__c==null) && rf.Refund_Method__c == 'Charge Card' && (rf.Refund_Status__c == 'Pending' || rf.Refund_Status__c == 'Ready for Processing')) {
            rf.Status__c = 'PROCESS';            
        }
    } 
}