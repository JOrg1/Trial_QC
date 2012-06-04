Public Class NewProspectResearchReports{
    public String testURL{get;set;}
    String strRecordType='';
    String strObject='';
    
    Public String AccountRendId = '';
    Public String ContactRendId = '';
    Public String CollegeRendId = '';
    Public String SpouseRendId = '';
    Public String PRR_Prefix = '';
    
    public NewProspectResearchReports(ApexPages.StandardController controller){
        List<ProspectResearchIDSetting__c> lstRendIDs = new List<ProspectResearchIDSetting__c>([Select name,FieldAPIName__c,RendaredValue__c From ProspectResearchIDSetting__c]);
        for(ProspectResearchIDSetting__c RID: lstRendIDs){
            if(RID.FieldAPIName__c == 'Account__c') AccountRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'Contact__c') ContactRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'Most_recent_College__c') CollegeRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'Spouse_Name__c') SpouseRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'PRR Prefix') PRR_Prefix = RID.RendaredValue__c;
            
        }
    }    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;
    }
    public String getSchoolName(String strID){
        String autoData='';
        List<Bios__c> lstBio = new List<Bios__c>();
        try{
            List<RecordType> lstRc = [select id from RecordType where developername =: 'Master'];
            lstBio = [SELECT Id, school_code__c FROM Bios__c WHERE Related_To__c =: strID AND RecordType.Id =: lstRc[0].Id order by createddate desc limit 1];        
            if(lstBio != null && lstBio.size()>0){
               autoData = '&'+ CollegeRendId + '=' + lstBio[0].school_code__c;
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        return autoData;
    }
    
    public String getSpouse(String strId){
        //if(strRecordType != 'Event_Bio') return '';
        if(strRecordType == 'Research_Note') return '';
        List<Relationships__c> lstRel = new List<Relationships__c>();
        string strSpouse='';
        if(strObject == 'Contact'){
         //Related_To_People__c, People__c
            lstRel = [Select id, name from Relationships__c Where Related_To_People__c =: strId OR People__c =: strId order by createddate desc limit 1];             
        }
        else if(strObject == 'Account'){
         //Related_To_Account, Account
            lstRel = [Select id, name from Relationships__c Where Related_To_AccHousehold__c =: strId OR Account_Household__c =: strId order by createddate desc limit 1];                      
        }
        if(lstRel != null && lstRel.size()>0){
            strSpouse = '&CF' + SpouseRendId + '=' + lstRel[0].name;
        }
        return strSpouse;
    }    
    
    Public String AutoPopulateData(String strId){
        String autoData='';
        List<Bios__c> lstBio = new List<Bios__c>();
        strId = strId.replace('/' , '');
        strId = strId.replace('%2F' , '');
        String HouseHoldName='';
        DateTime HouseHoldDate=null;
        //strObject = CommonApex.getObjectNameById(strID);
        if(strId.trim().substring(0,3)=='003')
            strObject = 'Contact';
        else if(strId.trim().substring(0,3)=='001')
            strObject = 'Account';
        system.debug('#######strobject : ' + strObject);
        if(strObject == 'Contact'){
            //Getting most recent collage name
            if(strRecordType=='Event_Bio' || strRecordType=='Profile')
                //autoData += getSchoolName(strId);
            //Contact
            try{
                List<Contact> lstContact = [SELECT firstname, lastname, AccountID, Account_Household__r.name, Account_Household__r.createddate FROM Contact WHERE Id =: strId];
                if(lstContact != null && lstContact.size()>0){
                    autoData += '&CF' + ContactRendId + '_lkid=' + strID;    
                    autoData += '&CF' + ContactRendId +'=' + lstContact[0].firstname + '+' + lstContact[0].lastname;
                    
                    //system.debug('Household name--------------------->' + lstContact[0].Household__r.name);
                    system.debug('Household id--------------------->' + lstContact[0].Account);
                    //Household name
                    if(lstContact[0].Account != null){
                        autoData += '&CF' + AccountRendId +'_lkid=' + lstContact[0].AccountID;    
                        autoData += '&CF' + AccountRendId +'=' + lstContact[0].Account_Household__r.name;
                        //autoData += '&Name=' + getPRRName(lstContact[0].Household__r.name, lstContact[0].Household__r.createddate);
                        HouseHoldName = lstContact[0].Account_Household__r.name;
                        HouseHoldDate = lstContact[0].Account_Household__r.createddate;
                    }
                }
            }catch(Exception ex1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex1.getMessage()));
            }
        } 
        system.debug('############## AccountId : ' + strId);
        if(strObject == 'Account'){
            List<Account> lstHO = [SELECT id, name, createddate FROM Account WHERE Id =: strId];
            if(lstHO != null && lstHO.size()>0){
                autoData += '&CF' + AccountRendId +'_lkid=' + lstHO[0].id;    
                autoData += '&CF'+ AccountRendId +'=' + lstHO[0].name;
                HouseHoldName = lstHO[0].name;
                HouseHoldDate = lstHO[0].createddate;
            }
        }
        autoData += '&Name=' + getPRRName(HouseHoldName, HouseHoldDate);
        //System.debug('COLLAGE------------------------>' + collegeName);
        //autoData += getSpouse(strId);
        return autoData;
    }


    String getPRRName(String HouseHoldName, DateTime dtCreated){
        String PRRName = HouseHoldName;
        String dt;
        if(dt != null && dt.trim().length()>0){
            dt = String.valueOf(date.valueOf(String.valueOf(dtCreated)));
        }
        else{
            dt = String.valueOf(System.today());
        }
        dt = dt.replace('00:00:00','').trim().replace('-','/');
        
        PRRName += ' ' + dt;
        
        system.debug('PRR NAME--------------------->' + PRRName);
        return PRRName.trim();
    }
    public PageReference RedirectToStandardPage() {
        string URL1='';
        
                
        //AccountRendId ='00NF0000008NcKf';
        string retURL1 = ApexPages.CurrentPage().getParameters().get('retURL');        
        String currPageURL =  ApexPages.currentPage().getUrl();
        string Accountid = ApexPages.CurrentPage().getParameters().get('CF'+ AccountRendId +'_lkid');
        string RecordType1 = ApexPages.CurrentPage().getParameters().get('RecordType');
        //Boolean recordfound = false;
        ID PRRId; //= 'a17Q0000000rK4V';
        String AccName='';
        DateTime AccCreated = System.now();
        If(Accountid != null && Recordtype1 != null) {
            list<Prospect_Research_Reports__c> lstPRR = new List<Prospect_Research_Reports__c>([
            Select Id,Name,Account__c, Account_Manager__c,Author__c,Born_Day__c,Born_Month__c,Born_Year__c,Business_Affiliations__c,City__c,CPRT__c,
                    Education__c,Family_Foundation__c,Financial_Information__c,Interests__c,MG_Rating__c,Most_recent_College__c,Notes__c,Other_Philanthropic_Activities__c,
                    Personal_Summary__c,Contact__c,Recent_College__c,Recent_Company__c,Spouse_Name__c,Spouse_Name_Formula__c,State__c,WGBH_Connections__c 
                    FROM Prospect_Research_Reports__c  WHERE Account__c =:Accountid AND RecordTypeID =:Recordtype1 order by CreatedDate Desc limit 1]);
            if(lstPRR.Size() >0) PRRId = lstPRR[0].Id;
             
        }
        List<Account> lstHO = [SELECT id, name, createddate FROM Account WHERE Id =: Accountid ];
        If(lstHO.size()>0) {
            AccName = lstHO[0].name;
            AccCreated = lstHO[0].createddate;
        }
        If(PRRId != null){
            //PRRId = System.Label.PospectDefaultID;//'a17Q0000000rK4V';
            URL1 = '/'+PRRId +'/e?clone=1';
            //URL1 += '&Name=' + getPRRName(AccName, AccCreated ); 
            URL1 += '&CF' + AccountRendId + '=' +EncodingUtil.urlEncode(AccName, 'UTF-8');
            URL1 += '&CF' + AccountRendId + '_lkid=' +Accountid;
            URL1 += '&nooverride=1&RecordType=' +Recordtype1;
            URL1 += '&retURL=%2F' +Accountid;                       
        }
        else{
            String FinalURL = currPageURL;
            if (FinalURL!=null) {
                FinalURL = FinalURL.Replace('/apex/NewProspectResearchReports','');
                FinalURL = FinalURL.Replace('&save_new=1&scontrolCaching=1&sfdc.override=1','');
                FinalURL = FinalURL.Replace('&save_new=1&sfdc.override=1','');
                FinalURL = '/' + PRR_Prefix + '/e' + FinalURL + '&nooverride=1';
    
                URL1 = FinalURL;
            }
        }


        system.debug('###0#:' + URL1);
        system.debug('###1#:' + retURL1);
        system.debug('###2#:' + currPageURL);
        
        PageReference PRClone = new PageReference(URL1);
        PRClone.SetRedirect(true);        
        return PRClone;  
    }
   /* public PageReference RedirectToStandardPage() {
        string URL='';
        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new= ApexPages.CurrentPage().getParameters().get('save_new');
        RecordType r = [Select DeveloperName from RecordType where ID=:RecordType];
        strRecordType = r.DeveloperName;
        Schema.DescribeSObjectResult resultkeyPrefix = Prospect_Research_Reports__c.sObjectType.getDescribe();
        URL += '/'+resultkeyPrefix.getKeyPrefix()+'/e?retURL=' + retURL + '&RecordType=' + RecordType + '&ent=' + ent;
        //if(r.DeveloperName == 'Event_Bio'){
            URL += '&CF00NQ0000000mKs9=' + UserInfo.getName();  
            URL += AutoPopulateData(retURL.replace('%2F',''));
        //}
        URL += '&nooverride=1';        
        system.debug('URL----------------------->' + URL);
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);  
        return P;
        //return null;
    }*/
    
     Static TestMethod void TestNewProspectResearchReports() {
        Recordtype record = [select id  from recordtype where DeveloperName='Household' And SobjectType='Account' limit 1];
        Account a = new Account(Name = 'Test123');
        a.Recordtypeid=record.id;
        insert a;
        
        Contact cnt = new Contact();
        cnt.firstName = 'Test';
        cnt.lastName = 'test';
        cnt.AccountID = a.Id;
        insert cnt;   

        Prospect_Research_Reports__c p = new Prospect_Research_Reports__c();
        RecordType r = [Select DeveloperName from RecordType where DeveloperName='Event_Bio'];
        
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        ApexPages.CurrentPage().getParameters().put('retURL','/' + a.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(p);
        NewProspectResearchReports clsTest = new NewProspectResearchReports(controller);
        clsTest.getCurrentURL();
        clsTest.AutoPopulateData(a.id);
        clsTest.AutoPopulateData(cnt.id);
        clsTest.RedirectToStandardPage();
        clsTest.getSchoolName(cnt.id);
        clstest.getSpouse(cnt.id);
        clsTest.getSpouse(a.id);
    }   
}