@IsTest
Public class testtrgUpdate_CCAlias_Transaction_Batch{

    public static testmethod void testtrgUpdate_CCAlias_Transaction_Batch()
    {
        Merchant_Accounts__c merchant = new Merchant_Accounts__c();
        merchant.Name='test';
        merchant.Merchant_ID__c='123456';
        merchant.Merchant_Key__c='123456';
        insert merchant;
        CC_Alias__c ccalias = new CC_Alias__c();
        ccalias.Merchant_Account__c=merchant.id;
        insert ccalias;
        Account acc= new Account(name='test');
        insert acc;

        Opportunity opp =new Opportunity ();
        opp.name='test';
        opp.accountid=acc.id;
        opp.stagename='tset';
        opp.CloseDate=system.today();
        //opp.CC_EFT_Alias__c=ccalias.id;
        
        insert opp;
        TRANSACTION_BATCH__c trans = new TRANSACTION_BATCH__c();
        trans.Transaction_Type__c='PAYMENT';
        trans.Status__c='FAIL';
        trans.Giving_id__c=opp.id;
        insert trans;        
        opp.CC_EFT_Alias__c=ccalias.id;
        update opp;
    }
    public static testmethod void testtrgUpdateGUID_Merchant_TransactionBatch()
    {
        Merchant_Accounts__c merchant = new Merchant_Accounts__c();
        merchant.Name='test';
        merchant.Merchant_ID__c='123456';
        merchant.Merchant_Key__c='123456';
        insert merchant;
        CC_Alias__c ccalias = new CC_Alias__c();
        //ccalias.Merchant_Account__c=merchant.id;
        insert ccalias;
        Account acc= new Account(name='test');
        insert acc;

        Opportunity opp =new Opportunity ();
        opp.name='test';
        opp.accountid=acc.id;
        opp.stagename='tset';
        opp.CloseDate=system.today();
        opp.CC_EFT_Alias__c=ccalias.id;
        
        insert opp;
        TRANSACTION_BATCH__c trans = new TRANSACTION_BATCH__c();
        trans.Transaction_Type__c='PAYMENT';
        trans.Status__c='FAIL';
        trans.Giving_id__c=opp.id;
        insert trans;        
        ccalias.Merchant_Account__c=merchant.id;
        update ccalias;
    }
    
}