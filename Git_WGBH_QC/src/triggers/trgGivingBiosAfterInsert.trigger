trigger trgGivingBiosAfterInsert on Opportunity (after insert) {
    ///////////////////////////////////
    if(System.label.DisableGivingTriggers != null && System.label.DisableGivingTriggers == 'yes'){
        return;
    }
    if(System.label.EnableTempGivingTrigger != null && System.label.EnableTempGivingTrigger == 'yes'){
        return;
    }
    ///////////////////////////////////
    
    List<RecordType> RecType = new List<RecordType>([select id from RecordType where DeveloperName = 'Interest' and sObjectType = 'Bios__c']);
    if (RecType != null && RecType.size()>0) { // && RecType[0].Id != null)
        List<Bios__c> bio = new List<Bios__c>();
        Bios__c objbio;
        
        List<Opportunity> lstOpp = [Select ID,RecordTypeID,Station__c,Oppty_Related_Contact__c,
                                    accountId,Campaign.TV_Radio_Show_Program__r.Interest_Topic__c,
                                    Campaign.TV_Radio_Show_Program__r.Genre__c,Campaign.TV_Radio_Show_Program__r.Type__c,
                                    Campaign.TV_Radio_Show_Program__c,CreatedDate ,Campaign.TV_Radio_Show_Program__r.Series__c                                    
                                    from Opportunity where ID IN: Trigger.NewMap.Keyset()];
        
        for(Opportunity o :  lstOpp){
            if (o.CampaignId != null){
                objbio = new Bios__c();           
                objbio.RecordTypeId = RecType[0].Id;
                objbio.Interest_Status__c = 'Implied';
                objbio.Station__c = o.station__c;
                //objbio.Channel__c = ?;
                objbio.Related_To__c = o.Oppty_Related_Contact__c;
                objbio.Account__c = o.accountId;      
                objbio.Interest_Topic__c = o.Campaign.TV_Radio_Show_Program__r.Interest_Topic__c;
                objbio.Genre__c = o.Campaign.TV_Radio_Show_Program__r.Genre__c;
                objbio.Type__c = o.Campaign.TV_Radio_Show_Program__r.Type__c;
                if(o.Campaign.TV_Radio_Show_Program__c != null && o.Campaign.TV_Radio_Show_Program__r.Series__c == true) {
                    objbio.Program_Show__c = o.Campaign.TV_Radio_Show_Program__c; 
                }         
                //objbio.Intensity__c = ?;
                objbio.First_Applied__c = o.CreatedDate.date();
                objbio.First_Interest_Applied_via__c = 'Gift Transaction';
                objbio.Most_Recently_Applied__c = null;
                objbio.last_interest_source__c = null;
                bio.add(objbio);        
            }
         }
         
         if(bio.size() > 0){
             insert bio;             
         }
     }   
}