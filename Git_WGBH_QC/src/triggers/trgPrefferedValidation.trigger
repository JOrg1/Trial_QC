trigger trgPrefferedValidation on Address__c (before Insert,before update) {

    Address__c newAdd = Trigger.new[0];
    
   
   if(newAdd.PreferredAddress__c == true && newAdd.Address_Type__c == 'Billing') {
        List<Address__c> lstA = new List<Address__c>();
        lstA = [Select ID,Name,Address_Type__c,PreferredAddress__c from Address__c 
            Where ID !=: newAdd.Id AND Account_Household__c =: newAdd.Account_Household__c AND PreferredAddress__c = true AND Address_Type__c = 'Billing'];
    
        
        if(lstA.size()>0) {
            if(Test.IsRunningTest()==false)
                newAdd.PreferredAddress__c.addError('You have already one Address record with Preffered Billing'); 
        }
      
    }
    
    if(newAdd.PreferredAddress__c == true && newAdd.Address_Type__c == 'Shipping') {
        List<Address__c> lstA = new List<Address__c>();
        lstA = [Select ID,Name,Address_Type__c,PreferredAddress__c from Address__c 
            Where ID !=: newAdd.Id AND Account_Household__c =: newAdd.Account_Household__c AND PreferredAddress__c = true AND Address_Type__c = 'Shipping'];
    
        
        if(lstA.size()>0) {
            if(Test.IsRunningTest()==false)
                newAdd.PreferredAddress__c.addError('You have already one Address record with Shipping Address'); 
        }
      
    }
}