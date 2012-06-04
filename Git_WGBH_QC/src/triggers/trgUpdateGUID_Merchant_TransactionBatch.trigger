trigger trgUpdateGUID_Merchant_TransactionBatch on CC_Alias__c(after update) 
{
    Set<id> setid =new Set<id>();

    for(CC_Alias__c a : trigger.new)
    {
        if(a.GUID__c!=trigger.oldmap.get(a.id).GUID__c || a.Merchant_Account__c!= trigger.oldmap.get(a.id).Merchant_Account__c)
        {
            setid.add(a.id);
        }
    }
    
    Map<id,Opportunity> givingmap=new Map<id,Opportunity>([select id,name,CC_EFT_Alias__r.GUID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c from Opportunity where CC_EFT_Alias__r.id in :setid ]);

    List<TRANSACTION_BATCH__c> lsttransaction=[select id,Submit_Count__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_id__c from TRANSACTION_BATCH__c where Giving_id__c in:givingmap.keyset() AND Transaction_Type__c='PAYMENT' AND (Status__c='FAIL' OR Status__c='PROCESS' OR Status__c='REVIEW')];
    for(TRANSACTION_BATCH__c trans:lsttransaction)
    {
        if(givingmap.ContainsKey(trans.Giving_id__c) == true) {
            trans.GUID__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.GUID__c;
            trans.Merchant_ID__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c;
            trans.Merchant_Key__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c ;
            trans.Submit_Count__c=0;
        }
    }
    if(lsttransaction.Size() > 0 )  
        update lsttransaction;
    
}