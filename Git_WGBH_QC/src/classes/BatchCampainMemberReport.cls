global class BatchCampainMemberReport {
    Public static void BatchCampainMemberReport() {
    	if(Test.IsRunningTest()) {
        	BatchExecCampainMemberReport reassign = new BatchExecCampainMemberReport('select id,Campaign_Member_Id__c,Contact__r.Account.id,Account_Id__c,Campaign__c,Contact__c from Campaign_Member_Report__c where IsProccessed__c = false limit 5');
        	ID batchprocessid = Database.executeBatch(reassign,200);
    	}
    	else {
        	BatchExecCampainMemberReport reassign = new BatchExecCampainMemberReport('select id,Campaign_Member_Id__c,Contact__r.Account.id,Account_Id__c,Campaign__c,Contact__c from Campaign_Member_Report__c where IsProccessed__c = false');
        	ID batchprocessid = Database.executeBatch(reassign,200);
    	}
    }
}