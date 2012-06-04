trigger trgPrefferedAddress on Account (after Insert) {

    
    Set<Id> setAccId = new Set<Id>();   
    List<Address__c> NewAddress  = new List<Address__c>();
    
    Address__c add;
    
    for(Account a: trigger.new)     
    {
        setAccId.Add(a.id);  
        String BillingAddress = '';
        if(a.BillingStreet !=null) BillingAddress +=a.BillingStreet;
        if(a.BillingCity !=null) BillingAddress +=a.BillingCity;
        if(a.BillingState !=null) BillingAddress +=a.BillingState;
        if(a.BillingCountry !=null) BillingAddress +=a.BillingCountry;
        
        //a.BillingStreet + a.BillingCity + a.BillingState +a.BillingCountry;
        
        if(BillingAddress!=null && BillingAddress!=''){
            add = new Address__c();  
            add.Street_1__c = a.BillingStreet;
            add.PreferredAddress__c = true;
            add.City__c = a.BillingCity;
            add.State__c = a.BillingState;
            add.Country__c = a.BillingCountry;
            add.Postal_Code__c = a.BillingPostalCode;
            add.Account_Household__c = a.Id;
            add.Address_Type__c = 'Billing';
            add.Address_Create_Date__c = system.today();
            NewAddress.add(add);
        }    
    }
    
    for(Account a: trigger.new) 
    {
    
        String ShippingAddress = '';
        if(a.ShippingStreet!=null) ShippingAddress+=a.ShippingStreet;
        if(a.ShippingCity!=null) ShippingAddress+=a.ShippingCity;
        if(a.ShippingState!=null) ShippingAddress+=a.ShippingState;
        if(a.ShippingCountry!=null) ShippingAddress+=a.ShippingCountry;
        
        if(ShippingAddress!= null && ShippingAddress!=''){
            add = new Address__c();
            add.Street_1__c = a.ShippingStreet;
            add.PreferredAddress__c = true;
            add.City__c = a.ShippingCity;
            add.State__c = a.ShippingState;
            add.Country__c = a.ShippingCountry;
            add.Postal_Code__c = a.ShippingPostalCode;
            add.Address_Type__c = 'Shipping';
            add.Account_Household__c = a.Id;
            add.Address_Create_Date__c = system.today();
            NewAddress.add(add);
        }
    }
    if(NewAddress!= null && NewAddress.size()>0){        
        insert NewAddress;        
        List<Account> lstacc = [select id from Account where id IN: setAccId];
        if(lstacc.size() > 0){
            for(Address__c addr: NewAddress){
                if(addr.Address_Type__c == 'Billing'){                
                    for(Account acc:lstacc){
                        acc.Preferred_Address__c = addr.id;
                    }                                
                }
            }            
            update lstacc;   
        }        
    }
}