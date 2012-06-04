global class BatchHouseholdStaffLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchHouseholdStaffLink(){
        this.query = 'Select h.Account_Manager__c, h.staff__c FROM Household__c h WHERE h.staff__c != null';
    }
    
    global BatchHouseholdStaffLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<String> staffNames = new List<String>();
        for(Sobject s : scope){
            Household__c household = (Household__c) s;
            if(household.staff__c != null && household.staff__c.length() > 0) {
                staffNames.add(household.staff__c);
            }
        }
        
        List<User> users = [SELECT id, EmployeeNumber FROM User WHERE EmployeeNumber IN :staffNames];
        Map<String, ID> usersMap = new Map<String, ID>();
        for(User user : users) {
            usersMap.put(user.EmployeeNumber, user.Id);
        }
        
        for(Sobject s : scope){
            Household__c household = (Household__c) s;
            household.Account_Manager__c = usersMap.get(household.staff__c);
        }
        
        update scope;
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchHouseholdStaffLink', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Household__c h1 = new Household__c(
           Name = 'Mr. & Mrs. Joe Dirt', 
           Ta_Account_Id__c = 900123451, 
           Staff__c = 'FRED'
        );
        insert h1;
        
        User u1 = [SELECT id, EmployeeNumber FROM User LIMIT 1][0];
        u1.EmployeeNumber = 'FRED';
        update u1;
        
        Test.StartTest();
        BatchHouseholdStaffLink batch = new BatchHouseholdStaffLink();
        batch.query += ' AND h.Ta_Account_Id__c = 900123451';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Household__c th1 = [SELECT Staff__c, Account_Manager__c FROM Household__c WHERE Ta_Account_Id__c = :h1.Ta_Account_Id__c][0];
        System.AssertEquals(th1.Account_Manager__c, u1.id);
    }
}