trigger trgclssifibforeinsbeforeupd on Classification__c (Before Insert,Before Update) {
    
    System.Debug('####mytrigger_trgclssifibforeinsbeforeupd');
    Map<Id,RecordType> MapRecType = new Map<Id,RecordType>([select ID,DeveloperName from RecordType where SobjectType= 'Classification__c']);
        
    List<RecordType> lstRecordType = [select ID,DeveloperName from RecordType where SobjectType= 'Classification__c'];
    for(Classification__c c: Trigger.New)
    {
        if(MapRecType.containskey(c.RecordtypeID) == true) {
            
            string recTypeName = MapRecType.get(c.RecordtypeID).DeveloperName;
            System.debug('####recTypeName: ' + recTypeName );
            if(recTypeName  == 'appeal_preferences') {
                c.classification_tabname__c = 'Appeal';
            } else if(recTypeName  == 'benefit_preferences') {
                c.classification_tabname__c = 'Benefit';
            } else if(recTypeName  == 'Communication_Preferences') {
                c.classification_tabname__c = 'Email';
            } else if(recTypeName  == 'Data_Tagging_Scores') {
                c.classification_tabname__c = 'Data Tagging';
            } else if(recTypeName  == 'member_category') {
                c.classification_tabname__c = 'Discount';
            } else if(recTypeName  == 'ongoing_membership') {
                c.classification_tabname__c = 'Membership Type';
            } else if(recTypeName  == 'station_board_committee') {
                c.classification_tabname__c = 'Committee';
            } else if(recTypeName  == 'station_partners') {
                c.classification_tabname__c = 'Misc';
            } else if(recTypeName  == 'survey_event_information') {
                c.classification_tabname__c = 'Misc';
            } else if(recTypeName  == 'volunteer_preferences') {
                c.classification_tabname__c = 'Misc';
            }
        }        
    }
    
  
}