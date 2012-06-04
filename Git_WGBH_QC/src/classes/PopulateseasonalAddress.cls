Public class PopulateseasonalAddress {


    public PopulateseasonalAddress() { }
   
    public PopulateseasonalAddress(List<Address__c> lstAddress) {
   
             
    Map<Id, Address__c> NewAddresses = new Map<Id, Address__c>();
    
    Integer i = 0;
   
    
    for (Address__c adr : lstAddress) 
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
             
            Date MyDate = System.today();
            integer month = MyDate.Month();
            integer day = MyDate.Day();
            
            String StartMonth = String.ValueOf(month);
            String StartDate = String.ValueOf(day);
            String FinalDate = StartMonth+'/'+StartDate;
            
            List<Account> updatedAccount = new List<Account>();

            for (Account a : lstAccount) 
            {

                Address__c parentAddress = NewAddresses.get(a.Id);
                   
                          if(parentAddress.Address_Type__c == 'Seasonal'  && parentAddress.Account_Household__c == a.Id && parentAddress.Seasonal_Start_Date__c == FinalDate)
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

}