@isTest
Private Class TesttrgClassificationAfterInsert {

    Public static testmethod void TestTrgClassification() {
        Test.startTest();
        List<RecordType> lstRecType = new List<RecordType>([select ID,Name,DeveloperName from RecordType where SobjectType= 'Classification__c']);
        if(lstRecType.size()>0) {
            
            list<Classification__c> lst = new  List<Classification__c>();
            for(RecordType rt:lstRecType) {
                Classification__c clsf = new Classification__c();
                clsf.RecordtypeId = rt.Id;
                clsf.Station__c = 'WGBH';
                clsf.start_date__c = system.Today();
                clsf.Classification_Type__c = rt.Name;
                lst.add(clsf);
            }
            if(lst.size()>0) {
                Insert lst;
            }
        }
        Test.StopTest();
    }
}