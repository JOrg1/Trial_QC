global class BatchCampaignOppLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchCampaignOppLink(){
        this.query = 'SELECT id, CampaignId, ta_campaign_value__c, FiscalYear FROM Opportunity WHERE tatransactions_id__c != null and CampaignId = null';
    }
    
    global BatchCampaignOppLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Campaign> campaigns = [SELECT id, name, fiscal_year__c, campaign_type_value__c FROM Campaign where fiscal_year__c != null];
        Map<String, ID> campaingsMap = new Map<String, ID>();
        for(Campaign campaign : campaigns) {
        	System.debug('campaign: '+campaign.name+', c fiscal: '+campaign.fiscal_year__c);
        	if(Integer.valueof(campaign.fiscal_year__c) >= 2007) {
        		campaingsMap.put(campaign.fiscal_year__c + '_' + campaign.campaign_type_value__c, campaign.Id);
        	}
            else if(Integer.valueof(campaign.fiscal_year__c) < 2007 && Integer.valueof(campaign.fiscal_year__c) >= 2000) {
            	campaingsMap.put(campaign.fiscal_year__c + '_overall', campaign.Id);
            }
        }
		Orphan__c[] orphans = new List<Orphan__c>();         
        for(Sobject s : scope) {
        	try {        	
	            Opportunity opp = (Opportunity) s;
	            System.debug('o fiscal: '+opp.FiscalYear);
	            if(opp.FiscalYear >= 2007) {
	            	opp.CampaignId = campaingsMap.get(String.valueOf(opp.FiscalYear) + '_' + opp.ta_campaign_value__c);
	            }
	            else if(opp.FiscalYear < 2007 && opp.FiscalYear >= 2000) {
	            	opp.CampaignId = campaingsMap.get(String.valueOf(opp.FiscalYear) + '_overall');
	            }
        	}
        	catch (Exception ex) {
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Opportunity',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchCampaignOppLink',
        			ta_id__c=((Opportunity)s).TaTransactions_Id__c,
        			object_id__c=s.id)
        		);
        	}	            
        }
        
        update scope;
		if(orphans.size()>0) insert orphans;           
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchCampaignOppLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Campaign c1 = new Campaign(
           Name = 'Campaign 1', 
           StartDate = date.parse('01/22/2005'), 
           EndDate = date.parse('01/21/2006'), 
           campaign_type_value__c = 'CAMP', 
           fiscal_year__c = '2005'
        );
        insert c1;
        
        Opportunity o1 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Contact Opporutnity 1',
           closeDate = date.parse('01/22/2006'), 
           StageName = 'Cultivation'
        );
        insert o1;
        
        Campaign c2 = new Campaign(
           Name = 'Campaign 2', 
           StartDate = date.parse('01/22/2006'), 
           EndDate = date.parse('01/21/2007'), 
           campaign_type_value__c = 'CAMP', 
           fiscal_year__c = '2007'
        );
        insert c2;
        
        Opportunity o2 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_02',
           Name = 'Test Contact Opporutnity 2',
           closeDate = date.parse('01/22/2008'), 
           StageName = 'Cultivation'
        );
        insert o2;
        
        Test.StartTest();
        BatchCampaignOppLink batch = new BatchCampaignOppLink();
        batch.query += ' AND tatransactions_id__c IN (\'23456_01_I_1230987_03_01\', \'23456_01_I_1230987_03_02\') LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Opportunity to1 = [SELECT CampaignId FROM Opportunity WHERE tatransactions_Id__c = :o1.tatransactions_Id__c][0];
//todo        System.assertEquals(to1.CampaignId, c1.Id);
        
        Opportunity to2 = [SELECT CampaignId FROM Opportunity WHERE tatransactions_Id__c = :o2.tatransactions_Id__c][0];
//todo        //System.assertEquals(to2.CampaignId, c2.Id);
    }
}