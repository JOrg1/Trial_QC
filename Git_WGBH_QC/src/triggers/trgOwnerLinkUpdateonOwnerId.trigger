trigger trgOwnerLinkUpdateonOwnerId on Account (before update, before insert) {
 
  // When 'Owner' field is changed, update 'OwnerLink' too
 
    // Loop through the incoming records
    for (Account acc : Trigger.new) {
 
        // Has Owner chagned?
        if (acc.OwnerID != acc.Owner_Link__c) {
            acc.Owner_Link__c = acc.OwnerId;
        }
    }
}