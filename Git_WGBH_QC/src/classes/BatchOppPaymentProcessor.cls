global class BatchOppPaymentProcessor implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;
    
    global static final Integer TOLERANT_ROUND_AMOUNT = 1;

    global BatchOppPaymentProcessor(){
    	// original - Where r.TaTransactions_Id__c != null and New_Balance__c >= 0';
        this.query = 'Select r.TaTransactions_Id__c, batch_process_count__c, New_Balance__c, ' + 
                        '(Select TaTransactions_Id__c, gift_date__c, payment_amount__c From Payments__r order by gift_date__c), ' +  
                        '(Select Name, StageName, Amount, CloseDate, TaTransactions_Id__c, new_installment_amount__c, payment_number__c From Donations__r order by payment_number__c) ' +  
                     'From Recurring_Donation__c r WHERE batch_process_count__c = 2';
    }
    
    global BatchOppPaymentProcessor(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		List<sObject> scope2 = new List<sObject>();
   		List<sObject> scope3 = new List<sObject>();   		
        for(Sobject s : scope) {
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            //Batch condition.
            if(rd.TaTransactions_Id__c != null && rd.New_Balance__c >= 0) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	rd.batch_process_count__c--;	
            }
        }
        if(scope2.size()>0) {
        	execute(scope2); 
        }
        if(scope3.size()>0) {
        	update scope3;
        }         
   }        
    
    global void execute(List<sObject> scope){
    	List<Opportunity> opps = new List<Opportunity>();
		Orphan__c[] orphans = new List<Orphan__c>();      	
        for(Sobject s : scope){
            Recurring_Donation__c rd = (Recurring_Donation__c) s;
            try {
	            List<Opportunity> opportunities = rd.Donations__r;
	            List<TaPayment__c> payments = rd.Payments__r;
	            
	            if(opportunities != null && opportunities.size() > 0 && payments != null && payments.size() > 0) {
	            	for(Opportunity opp : opportunities) {
	                    opp.Amount = opp.new_installment_amount__c;
	                }
	            	processPayments(opportunities, 0, payments, 0);
	            	partialCloseOpps(opportunities);
	            }
	            opps.addAll(opportunities);
            	rd.batch_process_count__c--;
            }
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Recurring_Donation__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchOppPaymentProcessor',
        			ta_id__c=rd.TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}            
        }
        update opps;
		if(orphans.size()>0) insert orphans;          
    }
    
    global void processPayments(List<Opportunity> opportunities, Integer oppIndex, List<TaPayment__c> payments, Integer paymentIndex) {
    	if(oppIndex < opportunities.size() && paymentIndex < payments.size()) {
	    	Opportunity currentOpportunity = opportunities[oppIndex];
	    	TaPayment__c currentPayment = payments[paymentIndex];
	    	
	    	Decimal balance = currentPayment.payment_amount__c - currentOpportunity.Amount;
	    	if(Math.abs(balance) < BatchOppPaymentProcessor.TOLERANT_ROUND_AMOUNT) {
	    		currentPayment.payment_amount__c = currentOpportunity.Amount;
	    		balance = currentPayment.payment_amount__c - currentOpportunity.Amount;
	    	}
	    	System.debug('o: '+oppIndex+', p: '+paymentIndex+', balance: '+balance+', opp amt: '+currentOpportunity.Amount+', payment amt: '+currentPayment.payment_amount__c);
	    	
	    	if(balance == 0) {
	    		closeOpportunity(currentOpportunity, currentPayment.gift_date__c, currentOpportunity.new_installment_amount__c);
	    		processPayments(opportunities, oppIndex + 1, payments, paymentIndex + 1);
	    	}
	    	else if(balance > 0) {
	    		if(oppIndex == opportunities.size() - 1) {
     	    		closeOpportunity(currentOpportunity, currentPayment.gift_date__c, currentPayment.payment_amount__c);
	    		}
	    		else {
	    			currentPayment.payment_amount__c -= currentOpportunity.Amount;
     	    		closeOpportunity(currentOpportunity, currentPayment.gift_date__c, currentOpportunity.new_installment_amount__c);
     	    		processPayments(opportunities, oppIndex + 1, payments, paymentIndex);
	    		}
	        }
	    	else if(balance < 0) {
	    		currentOpportunity.Amount -= currentPayment.payment_amount__c;
	    		processPayments(opportunities, oppIndex, payments, paymentIndex + 1);
	        }
    	}
    }
    
    global void partialCloseOpps(List<Opportunity> opportunities) {
    	if(opportunities != null && opportunities.size() > 0) {
            boolean allClosed = true;
            for(Opportunity opp : opportunities) {
                if(opp.StageName != 'Closed Won') {
                    allClosed = false;
                    break;
                }
            }
            for(Opportunity opp : opportunities) {
                if(opp.StageName == 'Closed Won' && allClosed == false) {
                    opp.StageName = 'Partial Close';
                }
            }
        }
    }
    
    global void closeOpportunity(Opportunity opportunity, Date closeDate, Decimal amount) {
    	System.debug('Closing opp: '+opportunity.name+', opp amt: '+opportunity.Amount+', paid amt: '+amount);
    	opportunity.CloseDate = closeDate;
    	opportunity.StageName = 'Closed Won';
    	opportunity.Amount = amount;
    }
    
    public static testMethod void testBatch() {
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           Name = 'Test RD 1',
           gift_date__c = Date.today(),
           paid_amount__c = 100, 
           Amount__c = 200,  
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert rd1;
        Opportunity o11 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Opporutnity 1',
           StageName = 'Cultivation',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           Recurring_Donation__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 1
        );
        insert o11;
        Opportunity o12 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_02',
           Name = 'Test Opporutnity 2',
           StageName = 'Cultivation',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           Recurring_Donation__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 2
        );
        insert o12;
        Opportunity o13 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_03',
           Name = 'Test Opporutnity 3',
           StageName = 'Cultivation',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           Recurring_Donation__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 3
        );
        insert o13;
        TaPayment__c p11 = new TaPayment__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Payment 1',
           gift_date__c = Date.today() - 3, 
           Recurring_Donation__c = rd1.Id, 
           payment_amount__c = 100
        );    
        insert p11;
        TaPayment__c p12 = new TaPayment__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03_02',
           Name = 'Test Payment 2',
           gift_date__c = Date.today() - 2, 
           Recurring_Donation__c = rd1.Id, 
           payment_amount__c = 80
        );    
        insert p12;
        TaPayment__c p13 = new TaPayment__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03_03',
           Name = 'Test Payment 3',
           gift_date__c = Date.today() - 1, 
           Recurring_Donation__c = rd1.Id, 
           payment_amount__c = 800
        );    
        insert p13;
        /*Recurring_Donation__c rd2 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_00_I_1234387_03',
           Name = 'Test Household RD',
           gift_date__c = Date.today()         
        );
        insert rd2;      
        Recurring_Donation__c rd3 = new Recurring_Donation__c (
           TaTransactions_Id__c = '23456_00_C_1344987_03',
           Name = 'Test Account RD',
           gift_date__c = Date.today()         
        );                      
        insert rd3;*/
        
        Test.StartTest();
        BatchOppPaymentProcessor batch = new BatchOppPaymentProcessor();
        batch.query += ' AND TaTransactions_Id__c IN (\'23456_01_I_1230987_03\') LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Opportunity[] to = [SELECT CloseDate, Amount FROM Opportunity WHERE tatransactions_Id__c IN (:o11.tatransactions_Id__c, :o12.tatransactions_Id__c, :o13.tatransactions_Id__c)];
//todo        System.AssertEquals(to[0].CloseDate, Date.today() - 3);
//todo        System.AssertEquals(to[1].CloseDate, Date.today() - 1);
//todo        System.AssertEquals(to[2].CloseDate, Date.today() - 1);
        
//todo        System.AssertEquals(to[0].Amount, 100);
//todo        System.AssertEquals(to[1].Amount, 100);
//todo        System.AssertEquals(to[2].Amount, 780);
        
        //Recurring_Donation__c trd1 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd1.TaTransactions_Id__c][0];
        //System.AssertEquals(trd1.Contact__c, c.id);
        //Recurring_Donation__c trd2 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd2.TaTransactions_Id__c][0];
        //System.AssertEquals(trd2.Household__c, h.id);        
        //Recurring_Donation__c trd3 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd3.tatransactions_Id__c][0];
        //System.AssertEquals(trd3.Organization__c, a.id);                               
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchOppPaymentProcessor', chainFlag);
    }
}