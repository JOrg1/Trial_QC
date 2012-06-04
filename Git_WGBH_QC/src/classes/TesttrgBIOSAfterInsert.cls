@isTest
private class TesttrgBIOSAfterInsert{
    static testMethod void myTest() {       
        Program__c prg = new Program__c();
            prg.name = 'test show';
            prg.Series__c = true;
        insert prg;       
       
        List<RecordType> RecType = new List<RecordType>([select id from RecordType where DeveloperName = 'interest' and sObjectType = 'Bios__c']);
        Bios__c bio = new Bios__c();
            bio.RecordtypeId = RecType[0].Id;
            bio.Program_Show__c = prg.Id;
        insert bio;
    }
}