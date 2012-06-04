trigger trgAddressToAccountNew on Address__c(after Insert,after update) {

    
    
    Map<Id, Address__c> NewAddresses = new Map<Id, Address__c>();
    
    Integer i = 0;
   
    
    for (Address__c adr : trigger.new) 
     {
        if(adr.PreferredAddress__c == true && adr.Account_Household__c != null)
        {
            if(NewAddresses.containsKey(adr.Account_Household__c)==false) NewAddresses.put(adr.Account_Household__c,adr);
        }
         i++;
    }
    

    List<Account> lstAccount = [Select Id,Name,BillingStreet,BillingCity,BillingState,BillingCountry,
            BillingPostalCode,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,
            ShippingPostalCode from Account where Id IN :NewAddresses.keySet()];
    
    List<Account> updatedAccount = new List<Account>();

    for (Account a : lstAccount) 
    {

        Address__c parentAddress = NewAddresses.get(a.Id);
        
        if(parentAddress.Address_Type__c == 'Shipping')
              {
                    a.ShippingStreet = parentAddress.Street_1__c;
                    a.ShippingCity = parentAddress.City__c;
                    a.ShippingState = parentAddress.State__c;
                    a.ShippingCountry = parentAddress.Country__c;
                    a.ShippingPostalCode = parentAddress.Postal_Code__c;
                    updatedAccount.add(a);
                    
              }

        if(parentAddress.Address_Type__c == 'Billing')
              {
                
                    a.BillingStreet = parentAddress.Street_1__c;
                    a.BillingCity = parentAddress.City__c;
                    a.BillingState = parentAddress.State__c;
                    a.BillingCountry = parentAddress.Country__c;
                    a.BillingPostalCode = parentAddress.Postal_Code__c;
                    updatedAccount.add(a);
                   
              }

        if(parentAddress.Address_Type__c != 'Seasonal' && parentAddress.Address_Type__c != 'Billing' && parentAddress.Address_Type__c != 'Shipping')
              {
                a.BillingStreet = parentAddress.Street_1__c;
                a.BillingCity = parentAddress.City__c;
                a.BillingState = parentAddress.State__c;
                a.BillingCountry = parentAddress.Country__c;
                a.BillingPostalCode = parentAddress.Postal_Code__c;
                a.ShippingStreet = parentAddress.Street_1__c;
                a.ShippingCity = parentAddress.City__c;
                a.ShippingState = parentAddress.State__c;
                a.ShippingCountry = parentAddress.Country__c;
                a.ShippingPostalCode = parentAddress.Postal_Code__c;
                updatedAccount.add(a);
                
               
              }      
    
        
        }
    if(updatedAccount.size()>0 && updatedAccount!= null)
    { 
         system.debug('updatedAccount :'+updatedAccount.size());   
         update updatedAccount;
    
    }
}