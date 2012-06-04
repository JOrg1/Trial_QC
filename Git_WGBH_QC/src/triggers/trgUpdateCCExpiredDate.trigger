trigger trgUpdateCCExpiredDate on TRANSACTION_BATCH__c (After Update) {
    /*TRANSACTION_BATCH__c objTrn = Trigger.New[0];
    TRANSACTION_BATCH__c objTrnold = Trigger.old[0];
    if(objTrn.isCCDateExpired__c == true && objTrn.isCCDateExpired__c != objTrnold.isCCDateExpired__c) {
        SageTransactionProcess.UpdateExpireDateAndRePayment(objTrn.Id);
    }*/
}