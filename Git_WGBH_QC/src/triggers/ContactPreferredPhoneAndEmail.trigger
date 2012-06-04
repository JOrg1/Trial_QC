trigger ContactPreferredPhoneAndEmail on Contact (Before Insert,Before Update) {
    For(Contact C: Trigger.New) {
        //Set Phone
        if(C.PreferredPhone__c == 'Home') {
            C.Phone = C.HomePhone;
        }
        else if(C.PreferredPhone__c == 'Work') {
            C.Phone = C.WorkPhone__c;
        }
        else if(C.PreferredPhone__c == 'Mobile') {
            C.Phone = C.MobilePhone;
        }else {
            C.Phone = null;
        }
        
        //Set Email
        if(C.Preferred_Email__c == 'Personal') {
            C.Email = C.HomeEmail__c;
        }
        else if(C.Preferred_Email__c == 'Work') {
            C.Email = C.WorkEmail__c;
        }
    }
}