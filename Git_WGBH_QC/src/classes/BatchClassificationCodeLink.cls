global class BatchClassificationCodeLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchClassificationCodeLink(){
    	// original condition. c.Classification_Code_Value__c = null
        // this.query = 'Select c.classification_value__c, c.classification_code__c, c.Classification_Code_Value__c From Classification__c c Where c.Classification_Code_Value__c = null';    	
        this.query = 'Select c.batch_process_count__c, c.classification_value__c, c.classification_code__c, c.Classification_Code_Value__c From Classification__c c Where c.batch_process_count__c = 1';
    }
    
    global BatchClassificationCodeLink(Boolean chainFlag){
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
            Classification__c c = (Classification__c) s;
            //Batch condition.            
            if(c.Classification_Code_Value__c == null) {
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
        List<String> classCodes = new List<String>();
        List<String> classValues = new List<String>();
        
        for(Sobject s : scope){
            Classification__c c = (Classification__c) s;
            classCodes.add(c.classification_code__c);
            classValues.add(c.classification_value__c);
        }
        
        List<Classification_Code__c> codeValues = [Select classification_value__c, classification_code__c, Id From Classification_Code__c where classification_code__c IN :classCodes AND classification_value__c IN :classValues];
        Map<String, ID> codeValueIds = new Map<String, ID>();
        for(Classification_Code__c codeValue : codeValues) {
        	codeValueIds.put(codeValue.classification_code__c + '_' + codeValue.classification_value__c, codeValue.Id);
        }
        
        for(Sobject s : scope){
            Classification__c c = (Classification__c) s;
            c.Classification_Code_Value__c = codeValueIds.get(c.classification_code__c + '_' + c.classification_value__c);
            c.batch_process_count__c--;
        }
        
        update scope;
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchClassificationCodeLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Classification__c c1 = new Classification__c(
           ta_classification_id__c = '12345_01_I_CODE_VALUE', 
           classification_code__c = 'CODE', 
           classification_value__c = 'VALUE',
           bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert c1;
        
        Classification_Code__c cc = new Classification_Code__c(
            classification_code__c = 'CODE', 
            classification_value__c = 'VALUE'
        );
        insert cc;
        
        Test.StartTest();
        BatchClassificationCodeLink batch = new BatchClassificationCodeLink();
        batch.query += ' AND c.ta_classification_id__c = \'12345_01_I_CODE_VALUE\' LIMIT 1 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Classification__c tc1 = [SELECT Classification_Code_Value__c FROM Classification__c WHERE ta_classification_id__c = :c1.ta_classification_id__c][0];
        System.AssertEquals(tc1.Classification_Code_Value__c, cc.id);
    }
}