global class BatchCaseProgramLink implements Database.Batchable<sObject> {
    global String query;
    global Boolean chainFlag = false;
    
    global BatchCaseProgramLink(){
    	// original - 'WHERE ta_interactions_Id__c != null and program_code__c != null and Program__c = null';
        this.query = 
        	'Select id, ta_interactions_Id__c, program_code__c, Program__c, batch_process_count__c ' + 
        	'From Case ' +
        	'WHERE batch_process_count__c = 1';
    }
    global BatchCaseProgramLink(Boolean chainFlag){
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
            Case c = (Case) s;
            //Batch condition.
            if(c.ta_interactions_Id__c != null && c.program_code__c != null && c.Program__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	c.batch_process_count__c--;	
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
    	List<Case> cases = (List<Case>)scope;
        List<String> programCodes = new List<String>();    	 	  	    	
        for(Case cas : cases) {
        	programCodes.add(cas.program_code__c);
        }
            	
        List<Program__c> programs = [SELECT id, ta_program_id__c FROM Program__c WHERE ta_program_id__c IN :programCodes];
        Map<String, ID> programMap = new Map<String, ID>();
        for(Program__c program : programs) {
            programMap.put(program.ta_program_id__c,program.Id);
        }
        
        for(Sobject s : scope){
            Case cas = (Case) s;        	
        	cas.Program__c = programMap.get(cas.program_code__c);
        	cas.batch_process_count__c--;
        }
        
        update scope;
    }
    
    public static testMethod void testBatch() {
    	Program__c p = new Program__c(Name='Hoops',ta_program_id__c='HOOPSTER', program_description__c='Basketball Show');
    	insert p;
    	
    	Case case1 = new Case(
    	   Origin='Email',
    	   Station__c='WGBH',
    	   Type='Jazz',
    	   Status='Open',
    	   program_code__c = 'HOOPSTER',
    	   contact_date__c=System.today(),
    	   ta_interactions_id__c = '12345_00_I_SO_ED',
    	   bulk_load__c = true,
    	   batch_process_count__c = 1
    	);   	
    	insert case1;     	    	  	 	
        
        Test.StartTest();
		BatchCaseProgramLink batch = new BatchCaseProgramLink();
		batch.query += ' AND ta_interactions_Id__c IN (\'12345_00_I_SO_ED\') LIMIT 10 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
		
		Case tcase1 = [SELECT ContactId, Household__c, Program__c, AccountId FROM Case WHERE ta_interactions_Id__c = :case1.ta_interactions_Id__c][0];
		System.Assert(case1.id == tcase1.id);
		System.Assert(tcase1.Program__c!=null);					
    }
    
    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchCaseProgramLink',chainFlag);
    }
}