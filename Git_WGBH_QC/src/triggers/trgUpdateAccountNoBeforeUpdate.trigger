trigger trgUpdateAccountNoBeforeUpdate on CC_Alias__c (Before Update) {
    if(Trigger.IsUpdate){
        //Bank_account_number__c
        //Routing_number__c
        for(CC_Alias__c cc:Trigger.New){
            cc.Bank_account_number__c = commonApex.getMaskedString(cc.Bank_account_number__c, 'X', 4);
            cc.Routing_number__c = commonApex.getMaskedString(cc.Routing_number__c, 'X', 4);
        }
    }
}