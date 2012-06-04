trigger trgUpdate_CCAlias_Transaction_Batch on opportunity(after update) 
{
    Set<id> setParentId =new Set<id>();
    Set<id> setChildId =new Set<id>();
    
    for(opportunity a : trigger.new)
    {
        if(a.CC_EFT_Alias__c!=trigger.oldmap.get(a.id).CC_EFT_Alias__c)
        {
            if(a.Recurring_Donation_Opportunity__c == null) {
                setParentId.Add(a.id);
            } else {
                setChildId.Add(a.Id);
            }
        }
    }
    //Delete Transaction batch record for the child opp of that parent opp which CC EFT was changed.
    if(setParentId.size()>0) {
        Map<Id,Opportunity> MapChildGiving = New Map<Id,Opportunity>([select id,Status__c,Response_Code__c,Response_message__c,Transaction_batch__c From Opportunity where Status__c = 'FAIL' And StageName = 'Pledged' And (id In:setParentId  OR Recurring_Donation_Opportunity__c in: setParentId)]);
        
        if(MapChildGiving.size()>0) {
            List<TRANSACTION_BATCH__c> lstDelTranbatch =[select id from TRANSACTION_BATCH__c where Giving_id__c in: MapChildGiving.KeySet()];
            
            if(lstDelTranbatch .size() >0) Delete lstDelTranbatch;
            
            for(Opportunity opp : MapChildGiving.Values()) {
                opp.Status__c = 'PROCESS';
                opp.Response_Code__c = null;
                opp.Response_message__c = null;
                opp.Transaction_batch__c = null;
            }
            Update MapChildGiving.Values();
        }
    }
    
    //Update Transaction batch record for the child opp which CC EFT was changed.
    if(setChildId.size()>0) {
        Map<Id,Opportunity> givingmap=New Map<Id,Opportunity>([select id,CC_EFT_Alias__r.GUID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c from Opportunity where id in :setChildId]);
 
        List<TRANSACTION_BATCH__c> lsttransaction=[select id,GUID__c,Merchant_Id__c,Submit_Count__c,Merchant_Key__c,Giving_id__c from TRANSACTION_BATCH__c where Giving_id__c in: givingmap.KeySet() AND Transaction_Type__c='PAYMENT' AND (Status__c='FAIL' OR Status__c='PROCESS' OR Status__c='REVIEW')];
    
        for(TRANSACTION_BATCH__c trans:lsttransaction)
        {
            if(givingmap.ContainsKey(trans.Giving_id__c) == true) {
                trans.GUID__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.GUID__c;
                trans.Merchant_ID__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c;
                trans.Merchant_Key__c=givingmap.get(trans.Giving_id__c).CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c ;
                trans.Submit_Count__c=0;
            }
        }
        
        if(lsttransaction.Size()>0) update lsttransaction;
    }
}