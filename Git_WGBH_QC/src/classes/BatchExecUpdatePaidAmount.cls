global class BatchExecUpdatePaidAmount implements Database.Batchable<sObject> {
    global final String Query;
    global boolean IsTest;    
    global BatchExecUpdatePaidAmount (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchcUpdatePaidAmount (scope);
    }
    
    void DoBatchcUpdatePaidAmount (List<sObject> scope) {
        List<Opportunity> lstParent = new List<Opportunity>();
        Set<ID> setParentId = new Set<ID>();
        List<Opportunity> lstChild = new List<Opportunity>();
        String strParentId = '';
        for(sObject s : scope) {
            setParentId.add(String.valueOf(s.get('Id')));
            if(strParentId == ''){
                strParentId = '\'' + String.valueOf(s.get('Id')) + '\'';
            }
            else{
                strParentId += ',\'' + String.valueOf(s.get('Id')) + '\'';
            }
        }
        
        List<AggregateResult> lstResult = new List<AggregateResult>();
        Map<ID, Decimal> mapAmount = new Map<ID, Decimal>();
        if(strParentId != ''){
            String aggQuery = 'Select Recurring_Donation_Opportunity__c, Sum(payment_amount__c) tot From Opportunity ';
            aggQuery += 'Where Recurring_Donation_Opportunity__c <> null and Recurring_Donation_Opportunity__c in(' + strParentId + ')';
            aggQuery += 'Group By Recurring_Donation_Opportunity__c';
            lstResult = Database.Query(aggQuery);
            if(lstResult != null && lstResult.size()>0){
                for(AggregateResult ag:lstResult){
                    mapAmount.put((Id)ag.get('Recurring_Donation_Opportunity__c'), (Decimal)ag.get('tot'));
                }
            }
        }
        if(mapAmount != null && mapAmount.size()>0){
            for(sObject s : scope) {
                Opportunity parent = new Opportunity();
                parent = (Opportunity)s;
                if(mapAmount.containsKey(parent.Id)){
                    parent.Payment_Amount__c = mapAmount.get(parent.Id);
                    //parent.paid_amount__c = mapAmount.get(parent.Id);
                    lstParent.add(parent);
                }
            }
        }
        if(lstParent != null && lstParent.size()>0){
            Update lstParent;
        }
    }
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

    static testMethod void TestBatchExecPB5HouseHoldProcess () {
        /*Test.startTest();
        
        ID batchprocessid;
        BatchExecUpdatePaidAmount reassign;
        reassign = new BatchExecUpdatePaidAmount ('Select ID from Lead limit 200');
        batchprocessid = Database.executeBatch(reassign);   
        Test.StopTest();
        */
    }    
}