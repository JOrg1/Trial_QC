public class TabsClassificationsControllerNew {

    public List<Classification__c> classifications {
        get {
             return this.getClassifications();
        }
        set;
    }
    
    public String Delid{get;set;} 
    public string id{get;set;}
    public String Tablabel{get;set;}
    public String RecordType{get;set;}
    
    public String recordId {get; set;}
    public String recordName {get; set;}
    public String sObjectType {get; set;}
    public String labelAppeal {get;set;}
    public String labelBenefit {get;set;}
    public String labelCommunication {get;set;}
    public String labelDatatagging {get;set;}
    public String labelMemberCategory {get;set;}
    public String labelOngoingMembership {get;set;}
    public String labelBoards {get;set;}
    public String labelStation {get;set;}
    public String labelSurveyDisability {get;set;}
    public String labelVolunteer {get;set;}
    public String strObjectId {get;set;}
    public String strClsObjectId {get;set;}
        
    Public List<Classification__c> lstAppeal{get; set;}
    Public List<Classification__c> lstBenefit{get; set;}
    Public List<Classification__c> lstCommunication{get; set;}
    Public List<Classification__c> lstDatatagging{get; set;}
    Public List<Classification__c> lstMemberCategory{get; set;}
    Public List<Classification__c> lstOngoingMembership{get; set;}
    Public List<Classification__c> lstBoards{get; set;}
    Public List<Classification__c> lstStation{get; set;}
    Public List<Classification__c> lstSurveyDisability{get; set;}
    Public List<Classification__c> lstVolunteer{get; set;}
    
    public TabsClassificationsControllerNew() {
        
        Schema.DescribeSObjectResult resultkeyPrefix = Classification__c.sObjectType.getDescribe();
        strObjectId = resultkeyPrefix.getKeyPrefix();
        strClsObjectId = System.Label.classification_object_ID;
        id=ApexPages.CurrentPage().getParameters().get('id');
        Delid='aaa';
        system.debug('__10__'+sObjectType);
        labelAppeal = 'Appeal Preferences';
        labelBenefit = 'Benefit Preferences';        
        labelCommunication = 'Communication Preferences';
        labelDatatagging = 'Data Tagging & Scores';
        labelMemberCategory = 'Member Category';
        labelOngoingMembership = 'Ongoing Membership';
        labelBoards = 'Station Boards and Committees';
        labelStation = 'Station Partners';
        labelSurveyDisability = 'Survey, Disability and Event Information';
        labelVolunteer = 'Volunteer Preferences';
                
    }
    
    public Classification__c[] getClassifications() {
        List<Classification__c> classifications = null;           
                
        system.debug('__sObjectType__'+sObjectType); 
        
        if(sObjectType != null){
            
            if(sObjectType == 'Contact') {                
                lstAppeal= [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Appeal Preferences'];    
                if(lstAppeal.size()>0){                        
                    labelAppeal = 'Appeal Preferences' +' '+'['+String.valueof(lstAppeal.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstAppeal = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Appeal Preferences'];
                if(lstAppeal.size()>0){
                    labelAppeal = 'Appeal Preferences' +' '+'['+String.valueof(lstAppeal.size()) +']';
                }
            }           
        }    
               
        if(sObjectType != null){
            
            if(sObjectType == 'Contact') {                
                lstBenefit= [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Benefit Preferences'];    
                if(lstBenefit.size()>0){                        
                    labelBenefit = 'Benefit Preferences' +' '+'['+String.valueof(lstBenefit.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstBenefit = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Benefit Preferences'];
                if(lstBenefit.size()>0){
                    labelBenefit = 'Benefit Preferences' +' '+'['+String.valueof(lstBenefit.size()) +']';
                }
            }           
        }    
        
        
        if(sObjectType != null){            
            if(sObjectType == 'Contact') {
                lstCommunication = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Communication Preferences'];    
                if(lstCommunication.size()>0){    
                    labelCommunication = 'Communication Preferences' +' '+'['+String.valueof(lstCommunication.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstCommunication = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Communication Preferences'];
                if(lstCommunication.size()>0){
                    labelCommunication = 'Communication Preferences' +' '+'['+String.valueof(lstCommunication.size()) +']';
                        
                }
            }           
        }
        
        if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstDatatagging= [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Data Tagging & Scores'];                   
                if(lstDatatagging.size()>0){                        
                    labelDatatagging = 'Data Tagging & Scores' +' '+'['+String.valueof(lstDatatagging.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstDatatagging = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Data Tagging & Scores'];
                if(lstDatatagging.size()>0){                        
                    labelDatatagging = 'Data Tagging & Scores' +' '+'['+String.valueof(lstDatatagging.size()) +']';
                }
            }           
         }
         
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstMemberCategory = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Member Category'];                   
                if(lstMemberCategory.size()>0){                        
                    labelMemberCategory = 'Member Category' +' '+'['+String.valueof(lstMemberCategory.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstMemberCategory = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Member Category'];
                if(lstMemberCategory.size()>0){                        
                    labelMemberCategory = 'Member Category' +' '+'['+String.valueof(lstMemberCategory.size()) +']';
                }
            }           
         }
         
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstOngoingMembership = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Ongoing Membership'];                   
                if(lstOngoingMembership.size()>0){                        
                    labelOngoingMembership = 'Ongoing Membership' +' '+'['+String.valueof(lstOngoingMembership.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstOngoingMembership = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Ongoing Membership'];
                if(lstOngoingMembership.size()>0){                        
                    labelOngoingMembership = 'Ongoing Membership' +' '+'['+String.valueof(lstOngoingMembership.size()) +']';
                }
            }           
         }
        
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstBoards = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Station Boards and Committees'];                   
                if(lstBoards.size()>0){                        
                    labelBoards = 'Station Boards and Committees' +' '+'['+String.valueof(lstBoards.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstBoards = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Station Boards and Committees'];
                if(lstBoards.size()>0){                        
                    labelBoards = 'Station Boards and Committees' +' '+'['+String.valueof(lstBoards.size()) +']';
                }
            }           
         }
         
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstStation = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Station Partners'];                   
                if(lstStation.size()>0){                        
                    labelStation = 'Station Partners' +' '+'['+String.valueof(lstStation.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstStation= [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Station Partners'];
                if(lstStation.size()>0){                        
                    labelStation = 'Station Partners' +' '+'['+String.valueof(lstStation.size()) +']';
                }
            }           
         }
         
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstSurveyDisability = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Survey, Disability and Event Information'];                   
                if(lstSurveyDisability.size()>0){                        
                    labelSurveyDisability = 'Survey, Disability and Event Information' +' '+'['+String.valueof(lstSurveyDisability.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstSurveyDisability = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Survey, Disability and Event Information'];
                if(lstSurveyDisability.size()>0){                        
                    labelSurveyDisability = 'Survey, Disability and Event Information' +' '+'['+String.valueof(lstSurveyDisability.size()) +']';
                }
            }           
         }
         
         if(sObjectType != null){            
            if(sObjectType == 'Contact') {                
                lstVolunteer = [Select c.start_date__c, c.end_date__c, c.comments__c,c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId  and c.Contact__c!=null and RecordType.Name =: 'Volunteer Preferences'];                   
                if(lstVolunteer.size()>0){                        
                    labelVolunteer = 'Volunteer Preferences' +' '+'['+String.valueof(lstVolunteer.size()) +']';
                }
            }
            else if(sObjectType == 'Account') {                
                lstVolunteer = [Select c.start_date__c, c.end_date__c, c.comments__c, c.Preference__c,c.Preference_Value__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null and RecordType.Name =: 'Volunteer Preferences'];
                if(lstVolunteer.size()>0){                        
                    labelVolunteer = 'Volunteer Preferences' +' '+'['+String.valueof(lstVolunteer.size()) +']';
                }
            }           
         }
          
               
        return classifications;
    }
        
    public PageReference Delmet() {
        System.debug('Deleteing classification: '+Delid);
        try {
            Classification__c c= [SELECT Id from Classification__c where id=:DelId];
            delete c;
        }
        catch(Exception e) {
            System.debug('Unable to delete classification: '+Delid+', ex: '+e);
        }
        pagereference pg = ApexPages.currentPage();
        return pg;
    }
    
    public static testmethod void test(){
        Contact c = new Contact();
        c.Lastname='test';
        insert c;
                       
        Account a = new Account();
        a.Name='test123';
        insert a;
        Classification__c ccBenefit = new Classification__c(Account__c = a.Id);
        insert ccBenefit;
        
        
        
        List<Classification__c> bb = [Select id from Classification__c limit 1];
        
        //Apexpages.CurrentPage().getParameters().put('id', c.id);
        TabsClassificationsControllerNew tcc = new TabsClassificationsControllerNew();
        
        tcc.sobjectType='Contact';
        Classification__c[] cc= tcc.getClassifications();
        
        if(Cc!=null){
            try{
                tcc.delid=cc[0].id;
                
                tcc.delmet();
            }catch(Exception e){}
                
        }       
        
        tcc.sobjectType='Account';
        tcc.RecordType = 'Appeal Preferences';        
        Classification__c[] acc= tcc.getClassifications();        
        
        tcc.recordid=a.id;
        tcc.RecordType = 'Benefit Preferences';     
        acc= tcc.getClassifications();  
        
        tcc.RecordType = 'Communication Preferences';     
        acc= tcc.getClassifications();
        
        tcc.RecordType = 'Data Tagging & Scores';     
        acc= tcc.getClassifications();
                       
        tcc.sobjectType='Account';
        Classification__c[] hcc= tcc.getClassifications();
        
        tcc.sobjectType='Contact';
        tcc.RecordType = 'Appeal Preferences';
        hcc= tcc.getClassifications();
        
        List<Classification__c> lc =tcc.classifications; 
        
        tcc.classifications = lc;        
        //tcc.getClassifications('Appeal');

        //List<Classification__c> b = new List<Classification__c>([SELECT id from Classification__c limit 1]); 
        //tcc.delId = b[0].id;
        PageReference p=tcc.delmet();
    }
 
}