trigger trgCaseBiosAfterInsert on Case (after insert) {
    
    List<RecordType> RecType = new List<RecordType>([select id from RecordType where DeveloperName = 'Interest' and sObjectType = 'Bios__c']);
    if (RecType != null && RecType.size()>0) { // && RecType[0].Id != null)
        List<Bios__c> bio = new List<Bios__c>();
        Bios__c objbio;
        
        List<Case> lstCase = [Select ID,Station__c,ContactID,AccountID,Program__r.Interest_Topic__c,Program__r.Genre__c,
                            Program__r.Type__c,Program__c,Program__r.Series__c,CreatedDate from Case where ID IN: Trigger.NewMap.KeySet()];
        
        /****=====To test 25May2012==========*/
        System.debug('##lstCase==>'+lstCase);
        /**=======================*/
        
        for(case c :  lstCase){
            if (c.Program__c != null){
                objbio = new Bios__c();           
                objbio.RecordTypeId = RecType[0].Id;
                objbio.Interest_Status__c = 'Implied';
                objbio.Station__c = c.station__c;
                //objbio.Channel__c = ?;
                objbio.Related_To__c = c.contactId;
                objbio.Account__c = c.accountId;      
                objbio.Interest_Topic__c = c.Program__r.Interest_Topic__c;
                objbio.Genre__c = c.Program__r.Genre__c;
                objbio.Type__c = c.Program__r.Type__c;
                if(c.Program__r.Series__c==true) objbio.Program_Show__c = c.Program__c;
                //objbio.Intensity__c = ?;
                objbio.First_Applied__c = c.CreatedDate.date();
                objbio.First_Interest_Applied_via__c = 'Case';
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