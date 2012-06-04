trigger trgSearchResultBeforeInsert on Search_Result__c (Before Insert) {
    for(Search_Result__c s: Trigger.New) {
        if(s.ContactLookup__c!=null) {
            s.ExternalID__c = s.ContactLookup__c;
        }
        else if(s.LeadLookup__c!=null) {
            s.ExternalID__c = s.LeadLookup__c;
        }
    }
}