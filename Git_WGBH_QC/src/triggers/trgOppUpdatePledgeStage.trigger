trigger trgOppUpdatePledgeStage on Opportunity (Before Update, After Update, Before Insert, After Insert) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
    /**** WGBHQC-65 JIRA 08-May-2012 ****/
    String AllowFulfillPaymentMethods = commonApex.NVL(System.Label.AllowFulfillPaymentMethods);
    /**** WGBHQC-65 JIRA 08-May-2012 ****/
    if(Trigger.IsBefore) {
        integer i=0;
        for(Opportunity opp: Trigger.New) {
            Double GivingAmount = 0;
            if(opp.Recurring_Donation_Opportunity__c == null)
                GivingAmount = opp.Giving_Amount__c;
            else
                GivingAmount = opp.Installment_Amount__c;
            String oldStage='';
            if(Trigger.IsUpdate)
                oldStage = Trigger.Old[i].StageName;
            else
                oldStage = opp.StageName;

            //JIRA WGBH-66 03/28/2012
            //if(opp.Payment_Method__c != 'Charge Card' && (oldStage == 'Pledged' || oldStage == 'Partially Fulfilled' || oldStage == 'Fulfilled') && opp.StageName!='Partially Collected' && opp.StageName!='Uncollectable'){
            /**** WGBHQC-65 JIRA 08-May-2012 ****/
            if(AllowFulfillPaymentMethods.contains(opp.Payment_Method__c) == false){
            /**** WGBHQC-65 JIRA 08-May-2012 ****/
                if(opp.Payment_Method__c != 'Charge Card' && opp.Payment_Method__c != 'Electronic Funds Transfer' && (oldStage == 'Pledged' || oldStage == 'Partially Fulfilled' || oldStage == 'Fulfilled') && opp.StageName!='Partially Collected' && (opp.StageName!='Uncollectable' && opp.StageName!='uncollectible')){
                    if(opp.payment_amount__c > 0) {
                        if(opp.payment_amount__c < GivingAmount) {
                            opp.StageName = 'Partially Fulfilled';
                        }
                        else if(opp.payment_amount__c >= GivingAmount) {
                            opp.StageName = 'Fulfilled';
                        }
                    }
                }
            }
            //JIRA WGBH-66 03/28/2012
            //else if(opp.Status__c=='SUCCESS' && Trigger.Old[i].Status__c!='SUCCESS' && opp.Payment_Method__c == 'Charge Card') {
            if(opp.Status__c=='SUCCESS' && Trigger.Old[i].Status__c!='SUCCESS' && (opp.Payment_Method__c == 'Charge Card' || opp.Payment_Method__c == 'Electronic Funds Transfer')) {
                opp.StageName = 'Fulfilled';
            }
            if(opp.Gift_Date_Time__c != null)
            {
                opp.CloseDate = opp.Gift_Date_Time__c.date();
            }
            if(opp.StageName == 'Pledged' && (opp.Payment_Method__c == 'Charge Card' || opp.Payment_Method__c == 'Electronic Funds Transfer') && (opp.Status__c==null || opp.Status__c=='')){
                if(opp.Gift_Kind__c == 'One Payment' || ((opp.Gift_Kind__c == 'Installment' || opp.Gift_Kind__c == 'Sustaining Gift') && opp.Recurring_Donation_Opportunity__c != null)){
                    opp.Status__c = 'PROCESS';
                }
            }
            else if(trigger.IsInsert && (opp.StageName == 'Fulfilled' || opp.StageName == 'Pledged') && (opp.Payment_Method__c == 'Charge Card' || opp.Payment_Method__c == 'Electronic Funds Transfer') && (opp.Status__c==null || opp.Status__c=='')){
                if(opp.Gift_Kind__c == 'One Payment' || ((opp.Gift_Kind__c == 'Installment' || opp.Gift_Kind__c == 'Sustaining Gift') && opp.Recurring_Donation_Opportunity__c != null)){
                    opp.Status__c = 'PROCESS';
                }
            }
            ///JIRA WGBH-73 03/28/2012
            else if((opp.Payment_Method__c == 'Kimbia Charge' || opp.Payment_Method__c == 'Kimbia Charge Card' || opp.Payment_Method__c == 'Convio Charge') && (opp.Status__c==null || opp.Status__c=='')){
                if(opp.Gift_Kind__c == 'One Payment' || ((opp.Gift_Kind__c == 'Installment' || opp.Gift_Kind__c == 'Sustaining Gift') && opp.Recurring_Donation_Opportunity__c != null)){
                    opp.Status__c = 'SUCCESS';   
                }
            }
            ///JIRA WGBH-73 03/28/2012          
            i++;
        }
        /////////////
        if(Trigger.IsUpdate){
            Set<ID> setParentId = new Set<ID>();
            Map<ID,Date> mapPaymentDate = new Map<ID,Date>();
            for(Opportunity opp: Trigger.New) {
                if(opp.Recurring_Donation_Opportunity__c != null){
                    if(opp.payment_amount__c != null && opp.payment_amount__c > 0 && opp.Payment_Date__c != null && (opp.Payment_Amount__c!=Trigger.OldMap.get(opp.Id).Payment_Amount__c || opp.Payment_Date__c!=Trigger.OldMap.get(opp.Id).Payment_Date__c)){
                        setParentId.add(opp.Recurring_Donation_Opportunity__c);
                    }
                }
            }
            if(setParentId.size()>0) {
                List<Opportunity> lstParent = [Select Id, Gift_Kind__c, Payment_Date__c From Opportunity Where Id in:setParentId];
                
                for(Opportunity opp: Trigger.New) {
                    if(opp.Recurring_Donation_Opportunity__c != null){
                        if(opp.payment_amount__c != null && opp.payment_amount__c > 0 && opp.Payment_Date__c != null && (opp.Payment_Amount__c!=Trigger.OldMap.get(opp.Id).Payment_Amount__c || opp.Payment_Date__c!=Trigger.OldMap.get(opp.Id).Payment_Date__c)){
                            if(mapPaymentDate.containsKey(opp.Recurring_Donation_Opportunity__c)==false) {
                                mapPaymentDate.put(opp.Recurring_Donation_Opportunity__c,opp.Payment_Date__c);
                            }
                        }
                    }
                }
                
                if(mapPaymentDate.size()>0) {
                    Boolean IsPaymentDateUpdated = False;
                    for(Opportunity parent:lstParent){
                        if(parent.Gift_Kind__c.trim().toUpperCase()=='INSTALLMENT' || parent.Gift_Kind__c.trim().toUpperCase()=='SUSTAINING GIFT'){
                            if(mapPaymentDate != null && mapPaymentDate.size()>0 && mapPaymentDate.containsKey(parent.id)){    
                                Date childDate = mapPaymentDate.get(parent.id);
                                if(parent.Payment_Date__c == null){
                                    parent.Payment_Date__c = childDate;
                                    IsPaymentDateUpdated = True;
                                }
                                else if(parent.Payment_Date__c != null && parent.Payment_Date__c < childDate){
                                    parent.Payment_Date__c = childDate;
                                    IsPaymentDateUpdated = True;
                                }
                            }
                        }
                    }
                    
                    if(lstParent != null && lstParent.size()>0 && IsPaymentDateUpdated==true) update lstParent;
                }
            }
        }
        /////////////
    }
    if(Trigger.IsAfter) {
        system.debug('#######WGBHQC-57-1');
        Set<ID> OppIDs = new Set<ID>();
        Set<ID> ParentOppIDs = new Set<ID>();
        for(Opportunity opp: Trigger.New) {
            if(Opp.Recurring_Donation_Opportunity__c!=null) {
                if(!OppIds.contains(Opp.Recurring_Donation_Opportunity__c)) {
                    OppIDs.add(Opp.Id);
                    ParentOppIDs.add(Opp.Recurring_Donation_Opportunity__c);
                    system.debug('#######WGBHQC-57-1.1');
                }
            }
        }
        List<Opportunity> lstOpp = new List<Opportunity>();
        if(ParentOppIDs.size()>0) {
            system.debug('#######WGBHQC-57-2');
            AggregateResult[] groupedResults = 
            [SELECT Recurring_Donation_Opportunity__c,
            Sum(Payment_Amount__c) TotalAmount FROM Opportunity Where Recurring_Donation_Opportunity__c IN: ParentOppIDs 
            GROUP BY Recurring_Donation_Opportunity__c];
            
            Map<Id,Double> MapAmount = new Map<ID,Double>();
    
            for (AggregateResult ar : groupedResults) {
                MapAmount.put((ID)ar.get('Recurring_Donation_Opportunity__c'),(Double) ar.get('TotalAmount'));
            }
            
            lstOpp = [Select ID,Recurring_Donation_Opportunity__c,payment_amount__c,Gift_Kind__c,StageName,(Select StageName from Giving_Installments__r) from Opportunity where ID IN: ParentOppIDs];
            system.debug('#######WGBHQC-57-3');
            for(Opportunity o: lstOpp) {
                if(MapAmount.containsKey(o.Id)) {
                    o.Payment_Amount__c = MapAmount.get(o.Id);
                }
                
                Boolean IsUncollectable=false;
                for(Opportunity oppChild: o.Giving_Installments__r) {
                    if(oppChild.StageName == 'Uncollectable' || oppChild.StageName == 'uncollectible') {
                        IsUncollectable = true;
                        break;
                    }
                }
                if(IsUncollectable==true) {
                    if(o.Payment_amount__c >0) {
                        o.StageName = 'Partially Collected';
                    }
                    else {
                        o.StageName = 'Uncollectable';
                    }
                }
                /**** WGBH-68 04-Apr-2012 ****/
                /*
                A   Pledge  
                B   Uncollectible 
                C   Fulfilled 
                
                IF childPledge=  Set Parent Status to 
                A C Partially Fulfilled 
                A B Partially Fulfilled 
                B C Partially Collected 
                ABC Partially Fulfilled 
                All A Pledged 
                All B Uncollectable 
                All C Fulfilled
                */
                String A = 'Pledged';
                String B = 'Uncollectable';
                String C = 'Fulfilled';
                String strA = '';
                String strB = '';
                String strC = '';
                
                system.debug('#######WGBHQC-57-4 -- ' + o.Gift_Kind__c);
                
                if(o.Gift_Kind__c == 'Installment' || o.Gift_Kind__c == 'Sustaining Gift'){
                    for(Opportunity oppChild: o.Giving_Installments__r){
                        if(oppChild.StageName == 'Pledged'){
                            strA = A;
                        }
                        if(oppChild.StageName == 'Uncollectable' || oppChild.StageName == 'uncollectible'){
                            strB = B;
                        }
                        if(oppChild.StageName == 'Fulfilled'){
                            strC = C;
                        }
                    }
                    if(strA == A && strC == C && strB == ''){
                        o.StageName = 'Partially Fulfilled';
                    }
                    if(strA == A && strB == B && strC == ''){
                        o.StageName = 'Partially Fulfilled';
                    }
                    if(strB == B && strC == C && strA == ''){
                        o.StageName = 'Partially Collected';
                    }
                    
                    if(strA == A && strB == B && strC == C){
                        o.StageName = 'Partially Fulfilled';
                    }
                    if(strA == A && strB == '' && strC == ''){
                        o.StageName = 'Pledged';
                    }
                    if(strA == '' && strB == B && strC == ''){
                        o.StageName = 'Uncollectable';
                    }
                    if(strA == '' && strB == '' && strC == C){
                        o.StageName = 'Fulfilled';
                    }
                    system.debug('#######WGBHQC-57-5');
                    system.debug('####################### ' + o.StageName + ' --- ' + o.Id);
                }
                system.debug('#######WGBHQC-57-6');
                /**** WGBH-68 04-Apr-2012 ****/
            }
        }
        
        Set<ID> setParentIds = new Set<ID>();
        for(Opportunity opp: Trigger.New) {
            if(opp.Gift_Kind__c == 'Installment' || opp.Gift_Kind__c == 'Sustaining Gift'){
                if(opp.Recurring_Donation_Opportunity__c == null){
                    setParentIds.add(opp.Id);
                    system.debug('#######WGBHQC-57-8');
                }
            }
        }
        
        /**** WGBHQC-57 JIRA 13-Apr-2012 ****/
        if(setParentIds.size()>0) {
            List<Opportunity> lstParent = [Select ID,StageName,Recurring_Donation_Opportunity__c,payment_amount__c,
            (Select StageName from Giving_Installments__r) from Opportunity where ID IN: setParentIds];
            
            system.debug('#######WGBHQC-57-9');
            List<Opportunity> lstChild = new List<Opportunity>();
            for(Opportunity parent: lstParent) {
                if(parent.StageName == 'Uncollectable' || parent.StageName == 'uncollectible' || parent.StageName == 'Partially Collected'){
                    system.debug('#######WGBHQC-57-10');
                    for(Opportunity Child: parent.Giving_Installments__r){
                        if(child.StageName == 'Pledged'){
                            system.debug('#######WGBHQC-57-11');
                            child.StageName = 'Uncollectable';
                            lstChild.add(child);
                        }
                    }
                }
            }
            if(lstChild.size()>0){
                update lstChild;
            }
        }
        /**** WGBHQC-57 JIRA 13-Apr-2012 ****/
        Set<ID> setPartiallyFulfilled = new Set<ID>();
        Set<ID> setUncollectible = new Set<ID>();
        if(Trigger.IsUpdate) {
            Set<ID> sOpp = New Set<ID>();
            integer i = 0;
            for(Opportunity oppTemp : Trigger.New) {
                if((Trigger.old[i].StageName !='Fulfilled' && Trigger.New[i].StageName =='Fulfilled') 
                    || (Trigger.old[i].StageName !='Partially Fulfilled' && Trigger.New[i].StageName =='Partially Fulfilled')) {
                    setPartiallyFulfilled.add(oppTemp.Id);
                }
                if((Trigger.old[i].StageName !='Uncollectible' && Trigger.New[i].StageName =='Uncollectible')
                    || (Trigger.old[i].StageName !='Partially Collected' && Trigger.New[i].StageName =='Partially Collected')){
                    setUncollectible.add(oppTemp.Id);
                }
                sOpp.add(oppTemp.Id);
                i++;
            }
            
            if(sOpp.size()>0) {
                List<OpportunityLineItem> lstOppItem = [Select ID, Fulfillment_Status__c, OpportunityId
                                        from OpportunityLineItem 
                                        where OpportunityID IN: sOpp And (Fulfillment_Status__c='Pending' or Fulfillment_Status__c='Ready to Process')];
                for(OpportunityLineItem oppLineItem: lstOppItem) {
                    if(setPartiallyFulfilled.contains(oppLineItem.OpportunityId)){
                        oppLineItem.Fulfillment_Status__c = 'Ready to Process';
                    }
                    if(setUncollectible.contains(oppLineItem.OpportunityId)){
                        oppLineItem.Fulfillment_Status__c = 'Cancelled';
                    }
                }            
                if(lstOppItem.size()>0) Update lstOppItem;
            }
        }
        if(lstOpp.size()>0) Update lstOpp;
        
    }
    
    //Update Transaction Batch Records
    if(Trigger.IsUpdate && Trigger.IsAfter) {
        Set<ID> sTransOppIDs = new Set<ID>();
        for(Opportunity oppT: Trigger.New) {
            if((oppT.Payment_Method__c == 'Charge Card' || oppT.Payment_Method__c == 'Electronic Funds Transfer') && 
                (oppT.StageName=='Uncollectible' || oppT.StageName=='uncollectible' || oppT.StageName=='Uncollectable') && 
                oppT.StageName!= Trigger.oldMap.get(oppT.Id).StageName &&
                (oppT.Gift_Kind__c == 'One Payment' || ((oppT.Gift_Kind__c == 'Installment' || oppT.Gift_Kind__c == 'Sustaining Gift') && oppT.Recurring_Donation_Opportunity__c != null))) {
                
                sTransOppIDs.add(oppT.Id);
            }
        }
        
        if(sTransOppIDs.size()>0) {
            List<Transaction_Batch__c> lstTrans = [Select ID,Status__c from Transaction_Batch__c 
            where Giving_Id__c IN: sTransOppIDs and (Status__c ='PROCESS' OR Status__c='FAIL')];
            for(Transaction_Batch__c Trans: lstTrans) {
                Trans.Status__c = 'CLOSE';
            }
            if(lstTrans.size()>0) Update lstTrans;
        }
    
    }
    

}