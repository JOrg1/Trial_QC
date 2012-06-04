trigger AddressNameTrigger on Address__c (before insert, before update) {
    for(Address__c addr :  Trigger.new) {
        String Name = '';
        if(addr.street_1__c!=null) Name+=addr.street_1__c;
        if(addr.city__c!=null) {
            if(Name=='')
                Name += addr.city__c;
            else
                Name += ', ' + addr.city__c;
        }
        if(addr.state__c!=null) {
            if(Name=='')
                Name += addr.state__c;
            else
                Name += ', ' + addr.state__c;
        }
        if(addr.Postal_Code__c!=null) {
            if(Name=='')
                Name += addr.Postal_Code__c;
            else
                Name += ', ' + addr.Postal_Code__c;
        }                
        
        //addr.Name = addr.street_1__c + ', ' + addr.city__c + ', ' + addr.state__c + ' - ' + addr.Postal_Code__c;      
        addr.Name = Name;
    }
}