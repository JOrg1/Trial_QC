Public Class commonApex{
    Public Static String getMaskedString(String str, String MaskChar, Integer LastDigit){
        String strFinal = '';
        str = NVL(str);
        if(str != ''){
            if(str.length()>LastDigit){
                Integer maskLength = str.Length()-LastDigit;
                String maskStr = '';                
                for(integer i=1; i<=maskLength; i++){
                    maskStr += MaskChar;
                }
                System.debug('######### maskLength : ' + maskLength);
                System.debug('######### maskStr : ' + maskStr);
                strFinal = maskStr + str.substring(maskLength, str.Length());
            }
            else{
                strFinal = str;
            }
        }
        System.debug('########### strFinal : ' + strFinal);
        return strFinal;
    }
    Public Static String getCharcardTypeById(String PaymentId){
        String CardType = '';
        try{
            //List<PaymentType__c> lstPaymentType = PaymentType__c.getAll();
            PaymentType__c paymentType = PaymentType__c.getValues(PaymentId);
            CardType = NVL(paymentType.Charge_Card_Type__c);
        }
        Catch(Exception ex){
            CardType = '';
        }
        return CardType;
    }
    Public Static String getInEligibilityMessage(){
        return 'Premium is not eligible.';
    }
    public static string setSpecialCharacters(String str){
        str = NVL(str);
        if(str != ''){
            if(str.contains('\'')==true){
                str = str.replace('\'', '\\\'');
            }
        }
        return str;
    }
    Public Static void UpdatePB5Lookups(WGBH_PB5_UPLOAD__c pb, String ContactId, String AccountId, String GivingId, String CampaignId){
        Boolean blnUpdate = false;
        if(NVL(ContactId).length()>0){
            pb.Contact__c = ContactId;
            blnUpdate = true;
        }
        if(NVL(AccountId).length()>0){
            pb.Account__c = AccountId;
            blnUpdate = true;
        }
        if(NVL(GivingId).length()>0){
            pb.Giving__c = GivingId;
            blnUpdate = true;
        }
        if(NVL(CampaignId).length()>0){
            pb.CPRT__c = CampaignId;
            blnUpdate = true;
        }
        if(blnUpdate == true){
            update pb;
        }
    }
    Public Static String getDeveloperNameById(ID recordId){
        String DeveloperName = '';
        if(recordId != null){
            List<RecordType> lstRc = [Select DeveloperName From RecordType Where Id=:recordId];
            if(lstRc != null && lstRc.size()>0){
                DeveloperName = NVL(lstRc[0].DeveloperName);
            }
        }
        Return DeveloperName;
    }
    Public Static String NVL(String val){
        if(val == null)
            return '';
        else
            return val.trim();
    }
    Public Static List<String> checkBenefitEligibility(Opportunity Giving, Set<ID> BenefitID){
        List<String> lstInEligibleBenefit = new List<String>();
        List<Product2> lstBenefit = new List<Product2>();
        Opportunity Parent = new Opportunity();
        Parent = getParentGiving(Giving);
        lstBenefit = [Select Id, ProductCode, Qualifying_Gift_Kind__c, Qualifying_Payment_Method__c From Product2 Where Id in: BenefitID];
        if(lstBenefit != null && lstBenefit.size()>0){
            for(Product2 Benefit:lstBenefit){
                if(isEligible(Giving, Benefit)==false){
                    if(Parent!= null && isEligible(Parent, Benefit)==false){
                        //lstInEligibleBenefit.add(Benefit.ProductCode);
                        lstInEligibleBenefit.add(Benefit.Id);
                    }
                    else{
                        //lstInEligibleBenefit.add(Benefit.ProductCode);
                        lstInEligibleBenefit.add(Benefit.Id);
                    }
                }
            }
        }
        return lstInEligibleBenefit;
    }
    Public Static Boolean isEligible(Opportunity Giving, Product2 Benefit){
        boolean eligibal = false;
        if((Benefit.Qualifying_Gift_Kind__c != null && Benefit.Qualifying_Gift_Kind__c.trim().length()>0) &&
        (Benefit.Qualifying_Payment_Method__c != null && Benefit.Qualifying_Payment_Method__c.trim().length()>0)){
            if((Giving.Gift_Kind__c != null && Giving.Gift_Kind__c.trim().toUpperCase() == Benefit.Qualifying_Gift_Kind__c.trim().toUpperCase()) &&
            (Giving.Payment_Method__c != null && Giving.Payment_Method__c.trim().toUpperCase() == Benefit.Qualifying_Payment_Method__c.trim().toUpperCase())){
                eligibal = true;
            }
            else{
                eligibal = false;
            }
        }else{
            eligibal = true;
        }
        return eligibal;
    }
    
    Static Opportunity getParentGiving(Opportunity Giving){
        Opportunity Parent = new Opportunity();
        try{
            if(Giving != null && Giving.Recurring_Donation_Opportunity__c != null){
                Parent = [Select Id, Gift_Kind__c, Payment_Method__c 
                From Opportunity Where Id=:Giving.Recurring_Donation_Opportunity__c];
            }
        }catch(Exception ex){
        }
        return Parent;
    }

    Public Static String getDeveloperNameByCampaignName(String CampaignName){
        String developerName = '';
        if(CampaignName != null && CampaignName.trim().length()>0){
            if(CampaignName == 'Restricted Giving')
                developerName = 'Restricted_Giving';
            if(CampaignName == 'In Kind')
                developerName = 'In_Kind_Gifts';
            if(CampaignName == 'Auction')
                developerName = 'Auction_Giving';
            if(CampaignName == 'Annual')
                developerName = 'Annual_Giving';
            if(CampaignName == 'Matching Gift')
                developerName = 'Matching_Gifts';
            if(CampaignName == 'Capital')
                developerName = 'Capital_Campaign_Giving';
            if(CampaignName == 'Planned Gift')
                developerName = 'Planned_Giving';
            if(CampaignName == 'Sales')
                developerName = 'Sales_Giving';
            if(CampaignName == 'Foundation Development')
                developerName = 'Foundation_Giving';
            if(CampaignName == 'Events')
                developerName = 'Events_Giving';    
        }
        return developerName;
    }
    Public Static String getCampaignByDeveloperName(String DeveloperName){
        String CampaignName = '';
        if(DeveloperName != null && DeveloperName.trim().length()>0){
            if(DeveloperName == 'Restricted_Giving')
                CampaignName = 'Restricted Giving';
            if(DeveloperName == 'In_Kind_Gifts')
                CampaignName = 'In Kind';
            if(DeveloperName == 'Auction_Giving')
                CampaignName = 'Auction';
            if(DeveloperName == 'Annual_Giving')
                CampaignName = 'Annual';
            if(DeveloperName == 'Matching_Gifts')
                CampaignName = 'Matching Gift';
            if(DeveloperName == 'Capital_Campaign_Giving')
                CampaignName = 'Capital';
            if(DeveloperName == 'Planned_Giving')
                CampaignName = 'Planned Gift';
            if(DeveloperName == 'Sales_Giving')
                CampaignName = 'Sales';
            if(DeveloperName == 'Foundation_Giving')
                CampaignName = 'Foundation Development';
            if(DeveloperName == 'Events_Giving')
                CampaignName = 'Events';    
        }
        return CampaignName;
    }
    
    /**** WGBHQC-20(51) JIRA 17-Feb-2012 ****/
    Public Static String getMemberYear(Giving_Summary__c gs){
        String memYear = '';
        
        if(gs.Summary_Count__c == null){
            memYear = 'Current Year';
        }
        else if(gs.Summary_Count__c == 0){
            memYear = 'Current Year';
        }
        else if(gs.Summary_Count__c > 0){
            memYear = 'Previous - ' + String.ValueOf(Integer.ValueOf(gs.Summary_Count__c));
        }
        
        return memYear;
    }
    /**** WGBHQC-20(51) JIRA 17-Feb-2012 ****/
    
    Public Static String getSolicitationCycle(Giving_Summary__c Summary, Opportunity opp){
        String SolicitationCycle = '';
        if(Summary.current_mem_yr_add_amt__c != null && Summary.current_mem_yr_add_amt__c > 0){
            SolicitationCycle = 'Multiple Gifts';
        }
        else if(opp.Gift_Kind__c != null && opp.Gift_Kind__c == 'One Payment'){
            SolicitationCycle = 'One Payment';
        }
        else if(opp.Gift_Kind__c != null && (opp.Gift_Kind__c == 'Installment' || opp.Gift_Kind__c == 'Sustaining Gift')){
            SolicitationCycle = 'Installment';
        }
        
        return SolicitationCycle;
    }
    
    /**** WGBHQC-20(51) JIRA 21-Feb-2012 ****/
    Public Static String getTrack(String GiftType, String ResponseMechanism){
        String Track = '';
        if(GiftType == 'New' || GiftType == 'Renewal' || GiftType == 'Rejoin'){
            if(NVL(ResponseMechanism) != ''){
                Track = GiftType + ' by ' + ResponseMechanism;
            }
            else{
                Track = GiftType + ' by other';
            }
        }
        return Track;
    }
    /*
    Public Static String getTrack(String GiftType, String Channel, String SubChannel){
        String Track = '';
        String RadioTV = 'by Pledge';
        String Mail = 'by Mail';
        String Email = 'by Email';
        String TelesalesInbound = 'by Member Service';
        String TelesalesOutbound = 'by Telemarketing';
        String Mobile = 'by Mobile';
        String EventType = 'by Event';
        String Web = 'by Web';
        if(Channel == null) Channel = '';
        if(SubChannel == null) SubChannel = '';
        if(GiftType != null && GiftType.Trim().Length()>0){
            if(GiftType.Trim().ToUpperCase()=='NEW' || GiftType.Trim().ToUpperCase()=='RENEWAL' ||
            GiftType.Trim().ToUpperCase()=='REJOIN'){   
                if(Channel.Trim().ToUpperCase() == 'RADIO'){
                    Track = RadioTV;
                }
                else if(Channel.Trim().ToUpperCase() == 'TV'){
                    Track = RadioTV;
                }
                else if(Channel.Trim().ToUpperCase() == 'MAIL'){
                    Track = Mail;
                }
                else if(Channel.Trim().ToUpperCase() == 'EMAIL'){
                    Track = Email;
                }
                else if(Channel.Trim().ToUpperCase() == 'TELESALES' && SubChannel.Trim().ToUpperCase() == 'INBOUND'){
                    Track = TelesalesInbound;
                }
                else if(Channel.Trim().ToUpperCase() == 'TELESALES' && SubChannel.Trim().ToUpperCase() == 'OUTBOUND'){
                    Track = TelesalesOutbound;
                }
                else if(Channel.Trim().ToUpperCase() == 'MOBILE'){
                    Track = Mobile;
                }
                else if(Channel.Trim().ToUpperCase() == 'EVENT TYPE'){
                    Track = EventType;
                }
                else if(Channel.Trim().ToUpperCase() == 'WEB'){
                    Track = Web;
                }
                Track = GiftType + ' ' + Track;             
            }
        }
        return Track;
    }
    */
    /**** WGBHQC-20(51) JIRA 21-Feb-2012 ****/
    public static String getObjectNameById(String strId) 
    {
        Map<String, Schema.SObjectType> schemas = Schema.getGlobalDescribe();
        Set<String> keys = schemas.keySet();
        String strKey=''; 
        String strObject = 'Not Found';
        strId = strId.substring(0,3);            
        for (String key : keys) 
        {
            Schema.SObjectType schema = schemas.get(key);
            Schema.DescribeSObjectResult d = schema.getDescribe();
           strKey = d.getKeyPrefix();
           if(strKey == null)
               strKey = '';
            if(strId == strKey)
                strObject = d.getName();
        }            
        return strObject;
    }  
    public static String getFieldName(String strId){
        String strObject = getObjectNameById(strId);
        String field = strObject;
        if(field.lastIndexOf('__')<0)
        {
            field = field + '__c';
        }   
        return field;  
    }
    
    public static String getFields(String ObjectName){
        //List<String> fields = new List<String>();
        List<String> fields = new List<String>();
        String strField='';
        fields = getFieldsInArray(ObjectName);
        for(integer i=0;i<fields.size();i++){
            if(strField=='')
                strField = fields[i];
            else
                strField = strField + ', ' + fields[i];            
        }
        
        return strField;
    }
    public static List<String> getFieldsInArray(String ObjectName) {        
        List<String> fields = new List<String>();
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( ObjectName ).getDescribe().fields.getMap();            
        //a0cQ0000001ckSF
        System.assert( accountFieldMap != null );                  
        for( String fieldName : accountFieldMap.keySet() ) {              
            Schema.DescribeFieldResult field = accountFieldMap.get( fieldName ).getDescribe();                
            String fieldType = ( '' + field.getType() ).replace( 'Schema.DisplayType.', '' );                
            //fields.add( new String( field.getLocalName(), field.getLabel() ) );                   
            fields.add( field.getLocalName());                   
        }     
        //System.debug( 'options values: ' + options );             
        //return options; 
        return fields;         
   }

    Public Static Integer getFiscalYearStartMonth() {
        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        return FiscalYearStartMonth;
    }
    
    Public Static Date getFirstDateCurrentFY() {
        Integer CurrentFicsalYear = system.today().year();
        Integer CurrentMonth = system.today().Month();
        Integer CurrentFiscalYearStartMonth = getFiscalYearStartMonth();
        if(CurrentMonth<CurrentFiscalYearStartMonth) {
            CurrentFicsalYear = System.today().Year()-1;
        }
        return Date.newInstance(CurrentFicsalYear,CurrentFiscalYearStartMonth,1);
    }      
   /*
    public static string generatePB5Record(String ObjectName) {        
        List<String> fields = new List<String>();
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( ObjectName ).getDescribe().fields.getMap();            
        //a0cQ0000001ckSF
        sObject pb = database.query('select PB5_MIDDLE_NAME_2__c, PB5_PAYMENT_AMOUNT__c, PB5_END_CDATE_4__c, CreatedById, PB5_SHIP_TO_TITLE__c, PB5_STATION_SOURCE__c, PB5_RECIP_ACCOUNT_IDENTIFIER_5__c, PB5_END_CDATE_9__c, PB5_START_CDATE_9__c, PB5_ALT_ACCOUNT_ID_ARIA__c, PB5_CLASSIFICATION_CODE_6__c, Giving_Record_Type__c, IsDeleted, RecordTypeId, PB5_START_CDATE_3__c, PB5_END_CDATE_10__c, SystemModstamp, PB5_SHIP_TO_SUFFIX__c, PB5_END_CDATE_6__c, PB5_BENEFIT_7__c, PB5_STATE__c, PB5_END_CDATE_8__c, PB5_CHARGE_CARD_HOLDER_FNAME__c, PB5_RESPONSE_TYPE__c, PB5_CLASSIFICATION_VALUE_2__c, PB5_Stage__c, PB5_GIFT_CDATE__c, PB5_CLASSIFICATION_CODE_9__c, PB5_TELEPHONE_EXTENSION_2__c, CreatedDate, PB5_TELEPHONE_NUMBER_2__c, OwnerId, PB5_CLASSIFICATION_CODE_2__c, PB5_COMMENTS__c, PB5_CLASSIFICATION_CODE_3__c, PB5_LAST_NAME__c, PB5_TELEPHONE_NUMBER_1__c, PB5_CLASSIFICATION_VALUE_4__c, PB5_CLASSIFICATION_VALUE_6__c, PB5_LAST_NAME_2__c, LastModifiedById, PB5_CHARGE_CARD_ALIAS__c, PB5_UPLOAD_SOURCE__c, PB5_ALT_ACCOUNT_ID_AUCTION__c, PB5_IS_NEW__c, PB5_CLASSIFICATION_VALUE_8__c, PB5_BENEFIT_5__c, PB5_SUFFIX__c, PB5_ORGANIZATION_NAME__c, PB5_CHARGE_CARD_MASK__c, PB5_CHARGE_CARD_HOLDER_LNAME__c, PB5_CITY__c, SF_Duplicate_ID__c, PB5_CLASSIFICATION_VALUE_7__c, PB5_CLASSIFICATION_CODE_7__c, PB5_BENEFIT_6__c, PB5_GIFT_TYPE__c, PB5_SHIP_TO_STATE__c, PB5_RESPONSE_CATEGORY__c, PB5_SHIP_TO_FIRST_NAME__c, PB5_END_CDATE_2__c, PB5_SHIP_TO_MIDDLE_NAME__c, PB5_STATION_SUPPORT__c, PB5_CLASSIFICATION_VALUE_1__c, PB5_TITLE__c, PB5_BENEFIT_1__c, PB5_STREET_1__c, PB5_CLASSIFICATION_VALUE_3__c, PB5_CLASSIFICATION_VALUE_5__c, PB5_ZIP_CODE__c, PB5_START_CDATE_7__c, PB5_ALT_ACCOUNT_ID_FDNDEV__c, PB5_CLASSIFICATION_CODE_4__c, PB5_CHARGE_CARD_TYPE__c, PB5_END_CDATE_1__c, PB5_TITLE_2__c, PB5_PLEDGE_AMOUNT__c, PB5_RECIP_ACCOUNT_IDENTIFIER_10__c, PB5_PAYMENT_FREQUENCY__c, PB5_NO_PHONE_PREFERRED__c, Flag_Review_Reason__c, PB5_COUNTRY__c, PB5_RECIP_ACCOUNT_IDENTIFIER_7__c, PB5_RECIP_ACCOUNT_IDENTIFIER_6__c, PB5_START_CDATE_10__c, PB5_ADDRESS_TYPE__c, LastActivityDate, PB5_ZIP_EXTENSION__c, PB5_EMAIL_TYPE_1__c, PB5_ALT_ACCOUNT_ID_LOCKBOX__c, PB5_SFDC_ID__c, PB5_RECIP_ACCOUNT_IDENTIFIER_4__c, PB5_SHIP_TO_LAST_NAME__c, PB5_CLASSIFICATION_CODE_8__c, PB5_FIRST_NAME_2__c, PB5_RECORD_TYPE__c, PB5_BENEFIT_2__c, PB5_CLASSIFICATION_CODE_1__c, PB5_BENEFIT_3__c, PB5_SHIP_TO_CITY__c, PB5_START_CDATE_5__c, PB5_ALT_ACCOUNT_ID_PBSD__c, PB5_SUFFIX_2__c, PB5_UPLOAD_FILENAME__c, PB5_SHIP_TO_ZIP_CODE__c, PB5_BENEFIT_9__c, PB5_PAYMENTS_IN_SCHEDULE__c, PB5_START_CDATE_6__c, PB5_RECIP_ACCOUNT_IDENTIFIER_1__c, PB5_BENEFIT_10__c, PB5_RECIP_ACCOUNT_IDENTIFIER_3__c, PB5_END_CDATE_7__c, PB5_REQUIRES_REVIEW__c, PB5_START_CDATE_4__c, PB5_ALT_ACCOUNT_ID_CARS__c, PB5_BENEFIT_4__c, PB5_EMAIL_ADDRESS_1__c, PB5_EMAIL_ADDRESS_2__c, PB5_RECIP_ACCOUNT_IDENTIFIER_8__c, PB5_END_CDATE_3__c, PB5_FIRST_NAME__c, PB5_SHIP_TO_EXTRA_LINE_1__c, PB5_SHIP_TO_ZIP_EXTENSION__c, PB5_START_CDATE_8__c, PB5_START_CDATE_1__c, PB5_CLASSIFICATION_CODE_10__c, PB5_CLASSIFICATION_CODE_5__c, LastModifiedDate, PB5_END_CDATE_5__c, Id, PB5_IS_PROCESSED__c, PB5_SHIP_TO_STREET_1__c, PB5_NO_PHONE_OTHER__c, Name, PB5_MIDDLE_NAME__c, PB5_SOURCE__c, PB5_PLEDGE_NUMBER__c, PB5_START_CDATE_2__c, PB5_CLASSIFICATION_VALUE_10__c, PB5_TELEPHONE_TYPE_2__c, IS_DUPLICATE__c, PB5_RECIP_ACCOUNT_IDENTIFIER_9__c, PB5_TELEPHONE_EXTENSION_1__c, PB5_CALLER__c, PB5_INSTALLMENT_AMOUNT__c, PB5_TELEPHONE_TYPE_1__c, PB5_PLEDGE_CTIME__c, PB5_PAYMENT_METHOD__c, PB5_RESPONSE_CDATE__c, PB5_EXTRA_LINE_1__c, PB5_GIFT_KIND__c, PB5_CHARGE_EXPIRE_CDATE__c, PB5_EMAIL_TYPE_2__c, PB5_BENEFIT_8__c, Flag_for_Review__c, PB5_TRANSACTION_TYPE__c, PB5_CLASSIFICATION_VALUE_9__c, PB5_RECIP_ACCOUNT_IDENTIFIER_2__c from WGBH_PB5_UPLOAD__c where id=\'a0cQ0000001ckSF\'');
        string insertstr = '';
        System.assert( accountFieldMap != null );                  
        for( String fieldName : accountFieldMap.keySet() ) {              
            Schema.DescribeFieldResult field = accountFieldMap.get( fieldName ).getDescribe();                
            String fieldType = ( '' + field.getType() ).replace( 'Schema.DisplayType.', '' );                
            //fields.add( new String( field.getLocalName(), field.getLabel() ) );                   
            fields.add( field.getLocalName());               
            if(NVL(string.valueof(pb.get(field.getLocalName()))) != ''){    
            insertstr += 'pb.' + field.getLocalName() + ' = \'' + string.valueof(pb.get(field.getLocalName())) + '\';     ';
            }
        }     
        system.debug('#################################   insertstr   : ' + insertstr);
        //System.debug( 'options values: ' + options );             
        //return options; 
        return insertstr;         
   } 
   */   
    static testMethod void commonApex()
    {
        //commonApex controller = new commonApex();
        commonApex.getInEligibilityMessage();
        
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        
        Opportunity opp = New Opportunity();
        opp.AccountID = a.Id;
        opp.Name = 'Test';
        opp.gift_kind__c = 'One Payment';
        opp.CloseDate = system.Today().AddDays(15);
        opp.Gift_Date_Time__c = system.now();
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        opp.campaign_name__c = 'Annual';
        opp.station__c = 'WGBH';
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';
        opp.Gift_Kind__c = 'One Payment';
        opp.Payment_Method__c = 'Cash';
        insert opp;       
        
        Product2 p = new Product2();
        p.Qualifying_Gift_Kind__c='One Payment';
        p.Qualifying_Payment_Method__c='Cash';
        commonApex.isEligible(opp,p);
        
        
        Product2 p2 = new Product2();
        p2.ProductCode = '1222121';
        p2.Name = 'Test Products';
        p2.Qualifying_Gift_Kind__c = '3222222';
        p2.Qualifying_Payment_Method__c = 'Post';
        insert p2;
        
        Set<ID> pid1 = new Set<ID>();
        pid1.add(p2.Id);
        commonApex.checkBenefitEligibility(opp,pid1);
        
        commonApex.getObjectNameById('ObjName');
        commonApex.getFieldName('FieldName');
        //commonApex.getFields('Account');
        //commonApex.getFieldsInArray('Account');
        //commonApex.getDeveloperNameByCampaignName('Test Campaign');
        //commonApex.getLocalName();
       // commonApex.getFieldsInArray('FieldName1');
       
        //Insert p;
        try {
            Set<ID> pid;
            pid.add(p.Id);
            commonApex.checkBenefitEligibility(opp,pid);
        }catch(Exception ex) {}
        
        commonApex.getParentGiving(opp);
        commonApex.getDeveloperNameByCampaignName('Restricted');
        commonApex.getDeveloperNameByCampaignName('In Kind');
        commonApex.getDeveloperNameByCampaignName('Auction');
        commonApex.getDeveloperNameByCampaignName('Annual');
        commonApex.getDeveloperNameByCampaignName('Matching');
        commonApex.getDeveloperNameByCampaignName('Capital');
        commonApex.getDeveloperNameByCampaignName('Planned Gift');
        commonApex.getDeveloperNameByCampaignName('Sales');
        commonApex.getDeveloperNameByCampaignName('Foundation');
        commonApex.getDeveloperNameByCampaignName('Events');
        
        commonApex.getCampaignByDeveloperName('Restricted_Giving');
        commonApex.getCampaignByDeveloperName('In_Kind_Gifts');
        commonApex.getCampaignByDeveloperName('Auction_Giving');
        commonApex.getCampaignByDeveloperName('Annual_Giving');
        commonApex.getCampaignByDeveloperName('Matching_Gifts');
        commonApex.getCampaignByDeveloperName('Capital_Campaign_Giving');
        commonApex.getCampaignByDeveloperName('Planned_Giving');
        commonApex.getCampaignByDeveloperName('Sales_Giving');
        commonApex.getCampaignByDeveloperName('Foundation_Giving');
        commonApex.getCampaignByDeveloperName('Events_Giving');
        /*
        commonApex.getTrack('NEW','RADIO','','');
        commonApex.getTrack('NEW','MAIL','','');
        commonApex.getTrack('NEW','EMAIL',null,'');
        commonApex.getTrack('NEW','TELESALES','INBOUND','');
        commonApex.getTrack('NEW','TELESALES','OUTBOUND','');
        commonApex.getTrack('NEW','TV','OUTBOUND','');
        commonApex.getTrack('NEW','MOBILE',null,'');
        commonApex.getTrack('NEW','EVENT TYPE','','');
        commonApex.getTrack('NEW','WEB','','');
        */
    }
   
}