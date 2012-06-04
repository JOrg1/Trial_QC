trigger trgBIOSAfterInsert on Bios__c (After Insert) {
   
    List<RecordType> RecType = new List<RecordType>([select id from RecordType where DeveloperName = 'interest' and sObjectType = 'Bios__c']);
    if(RecType  !=null && RecType.Size()>0) {
        Id IntersId = RecType[0].Id;
        Set<Id> sBiosIDs = new Set<Id>();
        For(Bios__c BIOSInters:Trigger.New) {
           if(BIOSInters.RecordTypeid == IntersId &&  BIOSInters.Program_Show__c != null) {
               sBiosIDs.Add(BIOSInters.Id);
           }
        }
        If(sBiosIDs.Size()>0) {
            
            List<Bios__c> lstBios = new List<Bios__c>([Select Id,Program_Show__c,Interest_Topic__c,Program_Show__r.Interest_Topic__c,Genre__c,Program_Show__r.Genre__c, Type__c ,Program_Show__r.Type__c from Bios__c Where ID IN:sBiosIDs]);
            
            for(Bios__c B: lstBios) {                
                B.Interest_Topic__c = B.Program_Show__r.Interest_Topic__c;
                B.Genre__c = B.Program_Show__r.Genre__c;
                B.Type__c = B.Program_Show__r.Type__c;
            }
            
            if(lstBios.size()>0) {
                Update lstBios;
            }
        } 
    }
}