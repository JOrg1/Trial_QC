Public Class UploadRecordMatchingGiving{

    Static String ADDGIFT = 'Add Gift';
    Static String UPGRADERESET = 'Upgrade Reset';
    Static String RENEWAL = 'Renewal';
    Static String REJOIN = 'Rejoin';
    Static String NEWTYPE = 'New';
    Static String DONATION = 'Donation';
    Static String PURCHASE = 'Purchase';
    
    Static String ONEPAYMENT = 'One Payment';
    Static String INSTALLMENT = 'Installment';
    Static String SUSTAINING = 'Sustaining Gift';
    
    Static List<RecordType> lstRecordType;
    
    Static Map<ID,List<Opportunity>> mapPB5Giving;
    Static Map<String,ID> mapDeveloperName;
    Static Map<ID, String> mapRecordTypeID;
    
    Static String NVL(String Value){
        if(Value == null)
            return '';
        else
            return Value.trim();
    }
    Static PB5_Fields__c objCustomSetting;
    
    Static void setCustomSetting(){
        objCustomSetting = PB5_Fields__c.getOrgDefaults();
    }

    Static ID getRecordTypeId(String DeveloperName){
        ID recordtypeid=null;
        if(mapDeveloperName != null && mapDeveloperName.size()>0 && mapDeveloperName.containsKey(DeveloperName)==true){
            recordtypeid = mapDeveloperName.get(DeveloperName);
        }
        Return recordtypeid;
    }
    Static ID getRecordTypeIdByName(String RecordTypeName){
        String DeveloperName;
        if(NVL(RecordTypeName) == 'Annual'){
            DeveloperName = 'Annual';
        }
        if(NVL(RecordTypeName) == 'Donation'){
            DeveloperName = 'Donation';
        }
        if(NVL(RecordTypeName) == 'Inkind'){
            DeveloperName = 'Inkind';
        }
        if(NVL(RecordTypeName) == 'Purchase'){
            DeveloperName = 'Purchase';
        }
        if(NVL(RecordTypeName) == 'Major Gifts'){
            DeveloperName = 'Major_Gifts';
        }
        return getRecordTypeId(DeveloperName);
    }
    Static ID getChildRecordTypeId(ID ParentRecordTypeID){
        String childName = '';
        ID ChildId = null;
        String DeveloperName = '';
        if(mapRecordTypeID != null && mapRecordTypeID.size()>0 && mapRecordTypeID.containsKey(ParentRecordTypeID)==true){
            DeveloperName = mapRecordTypeID.get(ParentRecordTypeID);
        }
        system.debug('################ Parent Record Type Id : ' + ParentRecordTypeID);
        system.debug('################ Parent Developer Name : ' + mapRecordTypeId);
        
        if(DeveloperName != null && DeveloperName.length()>0){
            if(DeveloperName.trim().toUpperCase() == 'ANNUAL'){
                childName = 'Annual_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'DONATION'){
                childName = 'Donation_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'INKIND'){
                childName = 'Inkind_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'PURCHASE'){
                childName = 'Purchase_Installment';
            }
            system.debug('########## child developerName : ' + childName);
            
            if(childName != null && childName.trim().length()>0){
                ChildId = getRecordTypeId(ChildName);
            }
            else{
                ChildId = null;
            }   
        }
        system.debug('######Child recordtype Id : ' + ChildId);
        return ChildId;
    }
    
    Static Void getRecordType(){
        lstRecordType = new List<RecordType>();
        lstRecordType = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Opportunity'];
        
        mapDeveloperName = new Map<String,ID>();
        mapRecordTypeID = new Map<ID,String>();
        if(lstRecordType != null && lstRecordType.size() > 0){
            for(RecordType rc:lstRecordType){
                mapDeveloperName.put(rc.DeveloperName, rc.Id);
                mapRecordTypeID.put(rc.Id, rc.DeveloperName);
            }
        }
    }    
    static string checkPaymentFrequency(String Frequency){
        Frequency = NVL(Frequency);
        
        if(Frequency == 'A')
            Frequency = 'Annual';
        else if(Frequency == 'Q')
            Frequency = 'Quarterly';
        else if(Frequency == 'B')
            Frequency = 'Bi-Monthly';
        else if(Frequency == 'M')
            Frequency = 'Monthly';
        else if(Frequency == 'S')
            Frequency = 'Semi-annually';
        
        return Frequency;
    }
    Static String checkGiftType(String GiftType){
        GiftType = NVL(GiftType);
        //RN = Renew RJ = Rejoin, UR = Upgrade Reset, AD = ADDGIFT,DO=Donation, PR=Purchase 
        if(GiftType.toUpperCase() == 'NW')
            GiftType = NEWTYPE;
        else if(GiftType.toUpperCase() == 'RN')
            GiftType = RENEWAL;
        else if(GiftType.toUpperCase() == 'RJ')
            GiftType = REJOIN;
        else if(GiftType.toUpperCase() == 'UR')
            GiftType = UPGRADERESET;
        else if(GiftType.toUpperCase() == 'AD')
            GiftType = ADDGIFT;
        else if(GiftType.toUpperCase() == 'DO')
            GiftType = DONATION;
        else if(GiftType.toUpperCase() == 'PR')
            GiftType = PURCHASE;
        
        Return GiftType;
    }
    Static string checkGiftKind(String GiftKind){
        GiftKind = NVL(GiftKind);
        if(GiftKind == 'O' || GiftKind == 'OP')
            GiftKind = ONEPAYMENT;
        if(GiftKind == 'I' || GiftKind == 'IN')
            GiftKind = INSTALLMENT;
        if(GiftKind == 'S' || GiftKind == 'SG')
            GiftKind = SUSTAINING;
            
        return GiftKind;
    }
    Static String checkPaymentMethod(String PaymentMethod){
        PaymentMethod = NVL(PaymentMethod);
        if(PaymentMethod == 'AA') PaymentMethod = 'CyberSource American Express';
        else if(PaymentMethod == 'AV') PaymentMethod = 'Cybersource Visa';
        else if(PaymentMethod == 'AM') PaymentMethod = 'CyberSource Mastercard';
        else if(PaymentMethod == 'AD') PaymentMethod = 'Cybersource Discover';
        else if(PaymentMethod == 'BA') PaymentMethod = 'Sage American Epxress';
        else if(PaymentMethod == 'BD') PaymentMethod = 'Sage Discover';
        else if(PaymentMethod == 'BM') PaymentMethod = 'Sage Mastercard';
        else if(PaymentMethod == 'BV') PaymentMethod = 'Sage Visa';
        else if(PaymentMethod == 'BX') PaymentMethod = 'Sage Unknown Charge Card';
        else if(PaymentMethod == 'CA') PaymentMethod = 'Cash';
        else if(PaymentMethod == 'CK') PaymentMethod = 'Check';
        else if(PaymentMethod == 'EF') PaymentMethod = 'Electronic Fund Transfer';
        else if(PaymentMethod == 'IK') PaymentMethod = 'In Kind Gift';
        else if(PaymentMethod == 'ND') PaymentMethod = 'No Donation';
        else if(PaymentMethod == 'NP') PaymentMethod = 'Non-Payment';
        else if(PaymentMethod == 'PD') PaymentMethod = 'Payroll Deduction';
        else if(PaymentMethod == 'PP') PaymentMethod = 'PayPal';
        else if(PaymentMethod == 'ST') PaymentMethod = 'Stock';
        else if(PaymentMethod == 'VG') PaymentMethod = 'Vehicle Giving';
        else if(PaymentMethod == 'KA') PaymentMethod = 'Kimbia American Express';
        else if(PaymentMethod == 'KD') PaymentMethod = 'Kimbia Discover';
        else if(PaymentMethod == 'KM') PaymentMethod = 'Kimbia Matsercard';
        
        Return PaymentMethod;
    }
    static Campaign getCPRT(String sourceCode){
        List<Campaign> lstCamp = new List<Campaign>();
        if(sourceCode != null){
            lstCamp = [Select id, name, Support_Designation__c, Override_Gift__c, Solicitation_Type__c, 
            Campaign_Name__c, Giving_Segment__c, station__c,Product_Program__c, Source_Code__c, 
            TA_Campaign_Source_Code__c, Package_Code__c, Response_Mechanism__c, TV_Radio_Show_Program__c 
            From Campaign 
            Where (Source_Code__c=:sourceCode and Source_Code__c!=null) or (TA_Campaign_Source_Code__c =: sourceCode and TA_Campaign_Source_Code__c!=null)];
            
        }
        system.debug('################ Campaign Source : ' + sourceCode);
        system.debug('################ Campaign : ' + lstCamp);
        if(lstCamp != null && lstCamp.size()>0){
            return lstCamp[0];
        }else{
            return null;
        }
    }
    static Campaign objCPRT;
    
    static void stopProcessingFromCaughtException(WGBH_PB5_UPLOAD__c PB, String Reason, Exception pException) {
        stopProcessing(PB, Reason, pException.getTypeName() + ': ' + pException.getMessage());
    }
    
    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason) {
        stopProcessing(PB, Reason, null);
    }
    
    static void stopProcessing(WGBH_PB5_UPLOAD__c PB, String Reason, String additionalInfo) {
        pb.Flag_for_Review__c = true;
        pb.Flag_Review_Reason__c = Reason;
        pb.Flag_Review_Exception__c = additionalInfo;
        pb.PB5_IS_PROCESSED__c = false;
        pb.PB5_IS_NEW__c = true;
        pb.PB5_Stage__c = 'A';
        system.debug('############### STOP PROCESSING GIVING');
        Update pb;
        return;
    }
    Static string InsufficientInfo = 'Insufficient Information';
    Static string MultipleMatching = 'MORE THAN 1 MATCH';
    Static string PledgeIdNumberExists = 'SFDC PLEDGE ID or PLEDGE NUMBER EXIST';
    Static string GiftTypeNull = 'GIFT TYPE IS NULL';
    Static string GiftMembership = 'GIFT MEMBERSHIP';
    Static string CalculateFrequency(Decimal GivingAmount, Decimal InstallmentAmount){
        string freq = '';
        integer intInstallments = 0;
        try{
            intInstallments = Integer.valueOf(GivingAmount/InstallmentAmount);
        }catch(Exception ex){
            intInstallments = 1;
        }
        if(intInstallments == 12){
            freq = 'Monthly';            
        }
        else if(intInstallments == 4){
            freq = 'Quarterly';
        }
        else if(intInstallments == 1){
            freq = 'Yearly';
        }
        else if(intInstallments == 6){
            freq = 'Bi-Monthly';
        }
        else if(intInstallments == 2){
            freq = 'Semi-Annually';
        }
        else if(intInstallments == 2){
            freq = 'Semi-Annually';
        }
        else{
            freq = 'IrregularSchedule';
        }
        system.debug('######## Frequecy from Canculate function : ' + freq);
        return freq;
    }
    
    Static List<Opportunity> getDuplicateGivings(WGBH_PB5_UPLOAD__c pb, String AccountId){
       
        List<Opportunity> lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
        From Opportunity Where AccountID =: ID.valueOf(AccountId)
        AND ((SFDC_GIVING_NUMBER__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and SFDC_GIVING_NUMBER__c!=null)
        OR (pledge_number__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and pledge_number__c != null))];
        return lstDuplicateGiving;
    }
    Static List<Opportunity> checkInstallments(WGBH_PB5_UPLOAD__c pb, String AccountId){
        List<Opportunity> lstDuplicateGiving;
        if(NVL(pb.PB5_PLEDGE_NUMBER__c).length()>0){
            lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
            Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
            SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
            Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
            From Opportunity Where AccountID =: ID.valueOf(AccountId)
            AND ((SFDC_GIVING_NUMBER__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and SFDC_GIVING_NUMBER__c!=null)
            OR (pledge_number__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and pledge_number__c != null))];
        }
        else{
            String GiftKind = checkGiftKind(pb.PB5_GIFT_KIND__c);
            String SourceCode = NVL(pb.PB5_SOURCE__c);
            String Station = '';    
            if(NVL(pb.PB5_STATION_SOURCE__c) == ''){
                Station = NVL(objCustomSetting.Station__c);
            }
            else{
                Station = pb.PB5_STATION_SOURCE__c;
            }
            lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
            Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
            SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
            Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
            From Opportunity 
            Where AccountID =: ID.valueOf(AccountId)
            And (Gift_Kind__c != null And Gift_Kind__c =: GiftKind)
            And (Station__c != null And Station__c =: Station)
            And (CampaignId != null And ((Campaign.Source_Code__c != null And Campaign.Source_Code__c=:SourceCode) 
                Or (Campaign.TA_Campaign_Source_Code__c != null and Campaign.TA_Campaign_Source_Code__c =: sourceCode)))];

        }

        if(lstDuplicateGiving != null && lstDuplicateGiving.size()>0){
            if(lstDuplicateGiving[0].Gift_Kind__C == SUSTAINING || lstDuplicateGiving[0].Gift_Kind__C == INSTALLMENT){
                if(lstDuplicateGiving[0].Recurring_Donation_Opportunity__c == null){
                    String ParentId = lstDuplicateGiving[0].Id;
                    List<Opportunity> lstInstallment = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
                    Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
                    SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
                    Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
                    From Opportunity Where Recurring_Donation_Opportunity__c =: ParentId
                    and StageName <> 'Fulfilled' Order By Schedule_start_date__c Asc Limit 1];
                    if(lstInstallment != null && lstInstallment.size()>0){
                        return lstInstallment;
                    }
                }
            }
        }
        
        return lstDuplicateGiving;
    }
    public static void processGiving(WGBH_PB5_UPLOAD__c PB, String ContactId, String householdId){
        System.debug('#############Process Giving Started ');
        
        if(NVL(householdId) == ''){
            stopProcessing(pb, InsufficientInfo, 'NVL(householdId) == blank');
            return;
        }
        getRecordType();
        Opportunity opp;
        
        Boolean blnProcess = false;
        Boolean blnUpdate = false;
        Boolean blnInsert = false;
        setCustomSetting();
        //List<Opportunity> lstDuplicate = getDuplicateGivings(PB, householdId);
        List<Opportunity> lstDuplicate = checkInstallments(PB, householdId);
        
        objCPRT = getCPRT(NVL(pb.PB5_SOURCE__c));
        if(objCPRT == null){
            stopProcessing(pb, InsufficientInfo, 'objCPRT == null');
            return;
        }
        if(lstDuplicate != null && lstDuplicate.size()>0){
            if(lstDuplicate.size()>1){
                stopProcessing(pb, PledgeIdNumberExists, 'lstDuplicate.size()>1: lstDuplicate = ' + lstDuplicate);
                return;
            }
            else{
                ////////////Update////////////
                opp = new Opportunity();
                opp = lstDuplicate[0];
                blnProcess = true;
                blnUpdate = true;
                blnInsert = false;
            }
        }else{
            opp = new Opportunity();
            blnProcess = true;
            blnUpdate = false;
            blnInsert = true;
        }
        if(blnProcess == true){ 
            system.debug('############# Process start');
            pb.Flag_for_Review__c = false;
            pb.PB5_IS_PROCESSED__c = true;
            pb.PB5_IS_NEW__c = false;                
            if(blnInsert == true){
                if(pb.PB5_GIFT_CDATE__c != null){
                    opp.closeDate = pb.PB5_GIFT_CDATE__c;
                    //opp.Gift_Date_Time__c = pb.PB5_GIFT_CDATE__c;
                }
                else if(pb.PB5_START_CDATE_1__c != null){
                    opp.closeDate = pb.PB5_START_CDATE_1__c;
                    //opp.Gift_Date_Time__c = pb.PB5_START_CDATE_1__c;
                }
                else{
                    opp.closeDate = system.today();
                    //opp.Gift_Date_Time__c = system.now();
                }
                
                if(opp.closeDate != null){
                    //opp.Gift_Date_Time__c = DateTime.valueOf(opp.closeDate);
                    opp.Gift_Date_Time__c = DateTime.newInstance(opp.closeDate.year(), opp.closeDate.month(), opp.closeDate.Day(),0,0,0);
                }
                opp.pledge_number__c = pb.PB5_PLEDGE_NUMBER__c;

                String rcType = '';
                if(NVL(pb.Giving_Record_Type__c)==''){
                    
                    if(NVL(objCustomSetting.Giving_Record_Type__c) == ''){
                        rcType = 'Annual';
                    }else{
                        rcType = objCustomSetting.Giving_Record_Type__c;
                    }
                }
                else{
                    rcType = NVL(pb.Giving_Record_Type__c);
                }
                
                String Anonymous = NVL(pb.PB5_ANONYMOUS_CODE__c);
                if(Anonymous.toUpperCase() == 'Y' || Anonymous.toUpperCase() == 'DO'){
                    opp.Anonymous__c = true;
                }
                
                if(blnInsert == true){
                    opp.AccountId = householdId;
                }
                opp.RecordTypeId = getRecordTypeIdByName(rcType);
                system.debug('########## Giving RecordType : ' + pb.Giving_Record_Type__c + ' ---- ' + opp.RecordTypeId);
                opp.Schedule_Start_Date__c = opp.closeDate;
                opp.Gift_Kind__c = checkGiftKind(pb.PB5_GIFT_KIND__c);
                if(NVL(opp.Gift_Kind__c)==''){
                    opp.Gift_Kind__c = objCustomSetting.Gift_Kind__c;
                    //stopProcessing(pb, InsufficientInfo);
                    //return;
                }
                opp.payment_frequency__c = checkPaymentFrequency(pb.PB5_PAYMENT_FREQUENCY__c);
                opp.Installment_Amount__c = pb.PB5_INSTALLMENT_AMOUNT__c;
                //PB5_ORGANIZATION_NAME__c
                opp.Payment_Amount__c = pb.PB5_PAYMENT_AMOUNT__c;
                opp.Payment_Method__c = checkPaymentMethod(pb.PB5_PAYMENT_METHOD__c);
                
                opp.Installments__c = pb.PB5_PAYMENTS_IN_SCHEDULE__c;
                opp.Giving_Amount__c = pb.PB5_PLEDGE_AMOUNT__c;
                if(opp.Giving_Amount__c == null){
                    opp.Giving_Amount__c = opp.Payment_Amount__c;
                }
                else if(opp.Giving_Amount__c == 0){
                    opp.Giving_Amount__c = opp.Payment_Amount__c;
                }
                else if(opp.Payment_Amount__c != null && opp.Giving_Amount__c < opp.Payment_Amount__c){
                    opp.Giving_Amount__c = opp.Payment_Amount__c;
                }
                if(opp.Giving_Amount__c == null){
                    stopProcessing(pb, InsufficientInfo, 'opp.Giving_Amount__c == null');
                    return;
                }
                else if(NVL(String.valueOf(opp.Giving_Amount__c))==''){
                    stopProcessing(pb, InsufficientInfo, 'NVL(String.valueOf(opp.Giving_Amount__c)) == blank');
                    return;
                }
                else if(Integer.valueOf(opp.Giving_Amount__c)==0){
                    stopProcessing(pb, InsufficientInfo, 'Integer.valueOf(opp.Giving_Amount__c)==0');
                    return;
                }
                if(NVL(opp.payment_frequency__c) == ''){
                    opp.payment_frequency__c = CalculateFrequency(opp.Giving_Amount__c, opp.Installment_Amount__c);
                }
                
                if(NVL(opp.Payment_Method__c)==''){
                    stopProcessing(pb, InsufficientInfo, 'NVL(opp.Payment_Method__c) == blank');
                    return;
                }
                
                //pb.PB5_PLEDGE_CTIME__c;
                //opp.pledge_number__c = pb.PB5_PLEDGE_NUMBER__c;
                if(NVL(pb.PB5_STATION_SOURCE__c) == ''){
                    opp.Station__c = NVL(objCustomSetting.Station__c);
                }
                else{
                    opp.Station__c = pb.PB5_STATION_SOURCE__c;
                }
                opp.Support_Designation__c = pb.PB5_STATION_SUPPORT__c; //(Support Designation)
                opp.SFDC_Opportunity_ID__c = String.valueof(pb.PB5_SFDC_ID__c);
                
                opp.name = generatePledgeName(opp);
                
                opp.Oppty_Related_Contact__c = ContactId;
                ///////////////////////
                if(objCPRT != null){
                    opp.CampaignId = objCPRT.Id;
                    //OverloadedGiftType = objCPRT.Override_Gift__c;
                    opp.Giving_Segment__c = objCPRT.Giving_Segment__c;
                    //opp.Gift_Type__c = objCPRT.Gift_Type__c;
                    opp.Support_Designation__c = objCPRT.Support_Designation__c;
                    opp.station__c = objCPRT.station__c;
                    opp.Response_Mechanism__c = objCPRT.Response_Mechanism__c;
                    opp.product__c = objCPRT.Product_Program__c;
                    opp.ta_campaign__c = objCPRT.TA_Campaign_Source_Code__c;
                    opp.Source_Code__c = objCPRT.Source_Code__c;
                    opp.Campaign_Name__c = objCPRT.Campaign_Name__c;
                    if(objCPRT.TV_Radio_Show_Program__c != null){
                        Program__c objProgram = new Program__c();
                        objProgram = [Select Id, name From Program__c where id =: objCPRT.TV_Radio_Show_Program__c];
                        if(objProgram != null){
                            opp.program__c = objProgram.name;
                        }
                    }
                    
                    opp.Campaign_Name__c = objCPRT.Campaign_Name__c;
                    opp.Solicitation_Type__c = objCPRT.Solicitation_Type__c;            
                }
                ///////////////////////
                if(NVL(pb.PB5_GIFT_TYPE__c)==''){
                    opp.Gift_Type__c = GTR.GTR(opp);
                }else{
                    opp.Gift_Type__c = checkGiftType(pb.PB5_GIFT_TYPE__c);
                }
                if(NVL(opp.Gift_Type__c)==''){
                    stopProcessing(pb, GiftTypeNull, 'NVL(opp.Gift_Type__c) == blank');
                    return;
                }
                if(pb.Payment_Date__c != null){
                    opp.Payment_Date__c = pb.Payment_Date__c;
                }
                else if(pb.Transaction_Date__c != null){
                    opp.Payment_Date__c = pb.Transaction_Date__c.date();
                }
                else if(pb.PB5_PAYMENT_AMOUNT__c != null && pb.PB5_PAYMENT_AMOUNT__c > 0){
                    opp.Payment_Date__c = system.today();
                }
                opp.StageName = 'Pledged';
                if(opp.Payment_Amount__c == null){
                    opp.StageName = 'Pledged';
                }
                else if(opp.Payment_Amount__c == 0){
                    opp.StageName = 'Pledged';
                }    
                else if(opp.Payment_Amount__c < opp.Giving_Amount__c){
                    opp.StageName = 'Partially Fulfilled';
                }
                else if(opp.Payment_Amount__c >= opp.Giving_Amount__c){
                    opp.StageName = 'Fulfilled';
                }
                else{
                    opp.StageName = 'Pledged';
                }
                if(NVL(opp.Gift_Type__c) == '') opp.Gift_Type__c = NEWTYPE;
                system.debug('###############Gift Type LINE 275' + opp.Gift_Type__c);
                system.debug('###############Gift Kind LINE 276' + opp.Gift_Kind__c);
                ////////////SET FREQUENCY/////////////
                String Frequency = '';
                String giftKind = opp.gift_kind__c.trim().toUpperCase();
                system.debug('########## FREQUENCY : ' + opp.payment_frequency__c );
                if(giftKind == INSTALLMENT.toUpperCase() || giftKind == SUSTAINING.toUpperCase()){
                    if(opp.payment_frequency__c != null){
                        Frequency = opp.payment_frequency__c.toUpperCase();            
                        system.debug('##### Frequency at line no 417 : ' + Frequency);
                        if(Frequency == 'MONTHLY'){
                            opp.Installments__c = 12;
                            opp.Installment_Period__c = 'Monthly';
                        }
                        if(Frequency == 'QUARTERLY'){
                            opp.Installments__c = 4;
                            opp.Installment_Period__c = 'Quarterly';
                        }
                        if(Frequency == 'ANNUALLY'){
                            opp.Installments__c = 1;
                            opp.Installment_Period__c = 'Yearly';
                        }
                        if(Frequency == 'BI-MONTHLY'){
                            opp.Installments__c = 6;
                            opp.Installment_Period__c = 'Bi-Monthly';
                        }
                        if(Frequency == 'SEMI-ANNUALLY'){
                            opp.Installments__c = 2;
                            opp.Installment_Period__c = 'Semi-Annually';
                        }
                        if(Frequency == 'IRREGULAR SCHEDULE'){
                            opp.Installment_Period__c = 'IrregularSchedule';
                        }
                        if(opp.Giving_Amount__c != null && opp.Giving_Amount__c >0){
                            if(opp.Installments__c != null && opp.Installments__c >0){
                                opp.installment_amount__c = (opp.Giving_Amount__c / opp.Installments__c).setScale(2);
                            }
                        }
                    }
                    system.debug('############### Installments : ' +  opp.Installments__c);
                    
                }            
            }

            system.debug('########### is insert process : ' + blnInsert);
            system.debug('########### is update process : ' + blnUpdate);
            if(blnInsert == true){
                system.debug('####### inserting giving ');
                opp.AccountId = householdId;
                Insert opp;
                Set<ID> setGivingIds = new Set<ID>();
                setGivingIds.add(opp.Id);
                system.debug('######## Giving Ids : ' + setGivingIds);
                ProcessGivingSummary.UpdateSummary(setGivingIds,false);
                system.debug('############### calling function create child');
                createChild(opp);
            }
            if(blnUpdate == true){
                if(opp.Payment_Amount__c != null){
                    opp.Payment_Amount__c += pb.PB5_PAYMENT_AMOUNT__c;
                }
                else{
                    opp.Payment_Amount__c = pb.PB5_PAYMENT_AMOUNT__c;
                }
                if(opp.Payment_Amount__c == null){
                    opp.StageName = 'Pledged';
                }
                else if(opp.Payment_Amount__c == 0){
                    opp.StageName = 'Pledged';
                }    
                else if(opp.Payment_Amount__c < opp.Giving_Amount__c){
                    opp.StageName = 'Partially Fulfilled';
                }
                else if(opp.Payment_Amount__c >= opp.Giving_Amount__c){
                    opp.StageName = 'Fulfilled';
                }
                else{
                    opp.StageName = 'Pledged';
                }
                Update opp;
                Set<ID> setGivingIds = new Set<ID>();
                setGivingIds.add(opp.Id);
                system.debug('######## Giving Ids : ' + setGivingIds);
                ProcessGivingSummary.UpdateSummary(setGivingIds,true);
                
            }
            addBenefits(pb,opp);
            GivingBenefit.ApplyBenefit(opp, pb);
            processClassification(pb, contactid, householdid, opp);
        }
        if(flagGiftMembership(pb) == false){
            Update pb;
        }
    }
    static boolean flagGiftMembership(WGBH_PB5_UPLOAD__c pb){
        boolean flag = false;
        
        String recgName = NVL(pb.PB5_Recognition_FName__c) + NVL(pb.PB5_Recognition_LName__c);
        if(recgName.trim().length()>0){
            flag = true;
            stopProcessing(pb,GiftMembership,GiftMembership);
        }
        return flag;
    }
    static void processClassification(WGBH_PB5_UPLOAD__c pb, String contactId, String householdId, Opportunity opp){
        List<Classification__c> lstClass = new List<Classification__c>();
        sObject spb = (sObject) pb;
        if(spb != null){
            Integer i = 0;
            for(i=1; i<=10; i++){
                String Preference = NVL(String.valueOf(spb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c')));
                List<RecordType> lstRc;
                if(opp.Gift_Kind__c.trim() == SUSTAINING){
                    lstRc = [Select ID from RecordType where DeveloperName='ongoing_membership' limit 1];
                }
                else{
                    lstRc = [Select ID from RecordType where DeveloperName='benefit_preferences' limit 1];
                }
                
                if(Preference.length()>0){
                    Classification__c cls = new Classification__c();
                    cls.Preference__c = Preference;
                    cls.Station__c = NVL(pb.PB5_STATION_SOURCE__c);
                    if(lstRc != null && lstRc.size()>0){
                        cls.RecordTypeId = lstRc[0].Id;
                    }
                    String startDate = NVL(String.valueOf(spb.get('PB5_START_CDATE_' + String.valueOf(i) + '__c')));
                    String endDate = NVL(String.valueOf(spb.get('PB5_END_CDATE_' + String.valueOf(i) + '__c')));
                    if(startDate.length()>0){
                        cls.start_date__c = date.valueOf(startDate);
                    }
                    if(endDate.length()>0){
                        cls.end_date__c = date.valueOf(endDate);
                    }
                    cls.Contact__c = contactId;
                    cls.Account__c = householdId;
                    cls.Preference_Value__c = NVL(String.valueOf(spb.get('PB5_CLASSIFICATION_VALUE_' + String.valueOf(i) + '__c')));
                    lstClass.add(cls);
                }
            }
            if(lstClass != null && lstClass.size()>0){
                insert lstClass;
            }
        }
    }
    Static void addBenefits(WGBH_PB5_UPLOAD__c PB5, Opportunity Opp){
        Set<String> setBenefitCode = new Set<String>();
        List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
        sObject sPB5 = (sObject) PB5;
        for(Integer i=1;i<=10;i++){
            String code = '';
            code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
            if(code != ''){
                setBenefitCode.add(code);
            }
        }
        
        List<Pricebook2> lstPricebook = [Select Id, name from Pricebook2 Where name =:Opp.Station__c];
        //PricebookEntry 
        if((setBenefitCode != null && setBenefitCode.size()>0) && (lstPricebook != null && lstPricebook.size()>0)){
            system.debug('######### benefits : ' + setBenefitCode);
            system.debug('#########Pricebook Entry ID : ' + lstPricebook[0].Id);
            Set<ID> setPriceBookIds = new Set<ID>();
            List<PricebookEntry> lstProduct = [Select UnitPrice, ProductCode, Product2Id, Product2.no_of_items__c, 
                Pricebook2Id, Name, Id, Product2.Description
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: lstPricebook[0].Id
                and ProductCode in: setBenefitCode];   
                
            if(lstProduct != null && lstProduct.size()>0){
                for(PricebookEntry prod:lstProduct){
                    OpportunityLineItem item = new OpportunityLineItem();    
                    item.Quantity = 1;
                    item.Description = Prod.Product2.Description;
                    item.UnitPrice = prod.UnitPrice;
                    if(NVL(opp.Oppty_Related_Contact__r.name) == ''){
                        item.Name__c = prod.Name;
                    }
                    item.Committed_Number__c = prod.Product2.no_of_items__c;
                    item.IsBenefit__c = true;
                    //item.TotalPrice = o.TotalPrice;
                    item.OpportunityId = opp.Id;
                    item.PricebookEntryId = prod.Id;                            
                    if(opp.Payment_Amount__c != null && opp.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                        
                    lstLineItems.add(item);      
                }
            }
            
            if(lstLineItems != null && lstLineItems.size()>0){
                system.debug('###### total line items to add ' + lstLineItems.size());
                insert lstLineItems;
            }        
        }        
    }
    
    Static Void createChild(Opportunity Parent){
        system.debug('######### createchild');
        List<Opportunity> lstChild = new List<Opportunity>();
        String giftKind = parent.gift_kind__c.trim().toUpperCase();
        system.debug('###################### Gift Kind : ' + giftKind);
        if(giftKind == INSTALLMENT.toUpperCase() || giftKind == SUSTAINING.toUpperCase()){
            /////////////////////////////////////////////////////////////        
            Decimal installs = parent.Installments__c;
            Integer installments = installs.intValue();
            Decimal LastAmount = 0;
            system.debug('############## Total Installments : ' + parent.Installments__c);
            for ( Integer j=0;j<installments;j++ )
            {
                Opportunity opp = new Opportunity();
                if(parent.RecordTypeId != null){
                    opp.RecordTypeID = getChildRecordTypeId(parent.RecordTypeId);
                }
                opp.AccountId = parent.AccountId;
                opp.Recurring_Donation_Opportunity__c = parent.Id;
                //add the remainder to the last installment, otherwise use the amount
                opp.Solicitation_Type__c = parent.Solicitation_Type__c;
                opp.Response_Mechanism__c = parent.Response_Mechanism__c;
                //opp.Gift_Type__c = objPledges.Gift_Type__c;
                opp.Gift_Kind__c = parent.Gift_Kind__c;
                opp.Product__c = parent.Product__c;
                opp.Source_Code__c = parent.Source_Code__c;
                opp.Campaign_Name__c = parent.Campaign_Name__c;
                opp.Giving_Segment__c = parent.Giving_Segment__c;
                opp.Giving_Amount__c = parent.Giving_Amount__c;
                opp.Gift_Date_Time__c = parent.Gift_Date_Time__c;
                opp.Station__c = parent.Station__c;
                opp.Amount = parent.Installment_Amount__c;
                opp.StageName = 'Pledged';
                if(j==0){
                    opp.Payment_Amount__c = parent.payment_Amount__c;
                    if(opp.Payment_Amount__c == null){
                        opp.StageName = 'Pledged';
                    }
                    else if(opp.Payment_Amount__c == 0){
                        opp.StageName = 'Pledged';
                    }    
                    else if(opp.Payment_Amount__c > 0 && opp.Payment_Amount__c < opp.Amount){
                        opp.StageName = 'Partially Fulfilled';
                    }
                    else if(opp.Payment_Amount__c >= opp.Amount){
                        opp.StageName = 'Fulfilled';
                    }
                    else{
                        opp.StageName = 'Pledged';
                    }
                    if(parent.Payment_Date__c != null){
                        opp.Payment_Date__c = parent.Payment_Date__c;
                    }
                }
                opp.CloseDate = calculateDate(parent.schedule_start_date__c, parent.Installment_Period__c, j);
                opp.schedule_start_date__c = opp.CloseDate;
                opp.Installment_Period__c = parent.Installment_Period__c;
                
                opp.payment_number__c = j+1;
                opp.payment_method__c = parent.payment_method__c;
                //opp.StageName = System.Label.RecurringDonationStageName;
                //opp.StageName = parent.Stagename;
                
                
                if(j == (installments-1)){
                    LastAmount = (parent.Giving_Amount__c - LastAmount).setScale(2);
                    opp.Installment_Amount__c = LastAmount;
                }
                else{
                    LastAmount += parent.Installment_Amount__c;
                    opp.Installment_Amount__c = parent.Installment_Amount__c;
                    if(j == 0){
                        //objPledges.Payment_Amount__c = opp.Installment_Amount__c;
                    }
                }
                
                opp.name = generateName(opp.CloseDate, j, Installments, Parent.Name);
                lstChild.add(opp);
            }                    
            /////////////////////////////////////////////////////////////
        }
        if(lstChild != null && lstChild.size()>0){
            system.debug('################### Total childs to create: ' + lstChild.size());
            Insert lstChild;
        }
    }
    Static Date calculateDate(DateTime bookDate, string InstallmentPeriod, integer element){
        Date closeDate;
        if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodYearly)
            closeDate = bookDate.date().addYears(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodQuarterly)
            closeDate = bookDate.date().addMonths(3*element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodMonthly)
            closeDate = bookDate.date().addMonths(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodWeekly)
            closeDate = bookDate.date().addDays(7*element);
        else if (InstallmentPeriod == 'Bi-Monthly')
            closeDate = bookDate.date().addMonths(2*element).addDays(1);
        else if (InstallmentPeriod == 'Semi-Annually')
            closeDate = bookDate.date().addMonths(6*element).addDays(1);
        else
            closeDate = bookDate.date().addDays(1);        
        return closeDate;
    }

    static String generatePledgeName(Opportunity objPledges){
        //Gift year (from gift date), STATION, CAMAPIGN & SOLICITATION TYPE 
        String pName='';
        //system.debug('############## YEAR: ' + String.ValueOf(objPledges.Gift_Date_Time__c.Year()));
        if(objPledges.Gift_Date_Time__c != null){
            pName = String.ValueOf(objPledges.Gift_Date_Time__c.Year());
            objPledges.Schedule_Start_Date__c = objPledges.Gift_Date_Time__c.Date();
        }
        if(objCPRT != null){
            if(objCPRT.Station__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Station__c;
                else
                    pName += objCPRT.Station__c;
            if(objCPRT.Campaign_Name__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Campaign_Name__c;
                else
                    pName += objCPRT.Campaign_Name__c;
            if(objCPRT.Giving_Segment__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Giving_Segment__c;
                else
                    pName += objCPRT.Giving_Segment__c;
                
            if(objCPRT.Solicitation_Type__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Solicitation_Type__c;
                else
                    pName += objCPRT.Solicitation_Type__c;
        
        }
        //objPledges.name = pName;
        return pName;
    }
    Static String generateName(Date CloseDate, integer Installments, integer TotalInstallment, String ParentName){
        String oName = '';
        //oName += objPledges.Donor_Name__c; 
        oName += ParentName; 
        oName += ' ';
        oName += System.Label.RecurringDonationPrefix;
        oName += ' (';
        oName += Installments+1;
        oName += ' of ';
        oName += TotalInstallment;
        oName += ') ';
        oName += CloseDate.format();
        return oName;
    }    
    
    
    
     /////////////////////////////TEST METHODS///////////////////////////////

    static testmethod void test() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cnt = new Contact();
        cnt.firstName = 'Test';
        cnt.lastName = 'test';
        cnt.AccountID = a.Id;
        insert cnt;        
        
        
        Campaign c2 = new Campaign();
        c2.name = 'test campaign';
        c2.Station__c = 'KCRW';
        c2.Product_Program__c = 'MEMBERSHIP';
        c2.Campaign_Name__c = 'ANNUAL';
        c2.Solicitation_Type__c = 'ACQUISITION';
        c2.Giving_Segment__c = 'ON-AIR PLEDGE';
        c2.Channel_Technique__c = 'TV';
        c2.Start_Time_Date__c = system.Now();
        c2.source_code__c = 'CRWASG120512011';
        c2.Effort_for_Project__c = '1';
        Insert c2;
        
        //c2.Source_code__c = 'GBHAO2110504003';
        //update c2;
    
        List<Campaign> lstCamp = [Select source_code__c from campaign where source_code__c != null and campaign_name__c = 'Annual' and station__c = 'KCRW' limit 1];  
        String sourcecode = '';
        if(lstCamp != null && lstCamp.size()>0){
            sourcecode = lstCamp[0].source_code__c;
        }     
        
        WGBH_PB5_UPLOAD__c PB = new WGBH_PB5_UPLOAD__c();

        pb.PB5_PAYMENT_AMOUNT__c = 25.00;  
        pb.PB5_END_CDATE_4__c = System.today();  
        pb.PB5_STATION_SOURCE__c = 'KCRW';  
        pb.PB5_CLASSIFICATION_CODE_6__c = 'COMMUNICATN';  
        pb.Giving_Record_Type__c = 'Annual'; 
        pb.PB5_START_CDATE_3__c = System.today();  
        pb.PB5_END_CDATE_6__c = System.today();  
        pb.PB5_STATE__c = 'CA';  
        pb.PB5_CLASSIFICATION_VALUE_2__c = 'NO PHONE';  
        pb.PB5_Stage__c = 'A';  
        pb.PB5_GIFT_CDATE__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_2__c = 'APPEAL';  
        pb.PB5_CLASSIFICATION_CODE_3__c = 'AUTO_RENEW';  
        pb.PB5_LAST_NAME__c = 'Test1234';  
        pb.PB5_CLASSIFICATION_VALUE_4__c = 'YCK';  
        pb.PB5_CLASSIFICATION_VALUE_6__c = 'YCH';  
        pb.PB5_UPLOAD_SOURCE__c = 'ARIA';  
        pb.PB5_IS_NEW__c = true;  
        pb.PB5_SUFFIX__c = 'Sr.';  
        pb.PB5_CITY__c = 'pb5 5';  
        pb.PB5_CLASSIFICATION_VALUE_7__c = '50 TO 64';  
        pb.PB5_CLASSIFICATION_CODE_7__c = 'APPEAL';  
        pb.PB5_END_CDATE_2__c = System.today();  
        pb.PB5_STATION_SUPPORT__c = 'Radio General';  
        pb.PB5_CLASSIFICATION_VALUE_1__c = 'SENIOR';  
        pb.PB5_TITLE__c = 'Mr.';  
        pb.PB5_BENEFIT_1__c = 'PTDH0001';  
        pb.PB5_STREET_1__c = '555';  
        pb.PB5_CLASSIFICATION_VALUE_3__c = 'CK';  
        pb.PB5_CLASSIFICATION_VALUE_5__c = 'Y ARONLY';  
        pb.PB5_ZIP_CODE__c = '432567';  
        pb.PB5_CLASSIFICATION_CODE_4__c = 'H MEMBERTYPE';  
        pb.PB5_END_CDATE_1__c = System.today();  
        pb.PB5_TITLE_2__c = 'Major';  
        pb.PB5_PLEDGE_AMOUNT__c = 100.00;  
        pb.PB5_PAYMENT_FREQUENCY__c = 'Quarterly';  
        pb.PB5_COUNTRY__c = 'USA';  
        pb.PB5_ADDRESS_TYPE__c = 'Work';  
        pb.PB5_SFDC_ID__c = '47352';  
        pb.PB5_RECORD_TYPE__c = 'PB5TEST';  
        pb.PB5_CLASSIFICATION_CODE_1__c = 'DISCOUNT';  
        pb.PB5_START_CDATE_5__c = System.today();  
        pb.PB5_SUFFIX_2__c = 'O.D.';  
        pb.PB5_PAYMENTS_IN_SCHEDULE__c = 4;  
        pb.PB5_START_CDATE_6__c = System.today();  
        pb.PB5_REQUIRES_REVIEW__c = false;  
        pb.PB5_START_CDATE_4__c = System.today();  
        pb.PB5_EMAIL_ADDRESS_2__c = 'test5@pb5.com';  
        pb.PB5_END_CDATE_3__c = System.today();  
        pb.PB5_FIRST_NAME__c = 'Test1234';  
        pb.PB5_START_CDATE_1__c = System.today();  
        pb.PB5_CLASSIFICATION_CODE_5__c = 'Y MEMBERTYPE'; 
        pb.PB5_END_CDATE_5__c = System.today();   
        pb.PB5_IS_PROCESSED__c = false;  
        //pb.PB5_SOURCE__c = 'GBHAO2110504003';  
        if(sourcecode != ''){
            pb.PB5_Source__c = sourcecode;
        }else{
            pb.PB5_Source__c = c2.source_code__c; 
        }
        pb.PB5_START_CDATE_2__c = System.today();  
        pb.PB5_TELEPHONE_TYPE_2__c = 'FH';  
        pb.IS_DUPLICATE__c = false;  
        pb.PB5_INSTALLMENT_AMOUNT__c = 25.00;  
        pb.PB5_PAYMENT_METHOD__c = 'Sage Discover';  
        pb.PB5_GIFT_KIND__c = 'SG';  
        pb.PB5_EMAIL_TYPE_2__c = 'Work';  
        pb.Flag_for_Review__c = false;  
        pb.PB5_TRANSACTION_TYPE__c = 'PLEDGE WITH PAYMENT';   
        pb.PB5_GIFT_TYPE__c = 'NEW';      
        insert pb;     

        
        RecordType r = [select id from RecordType where DeveloperName = 'Annual' limit 1];
        
        Opportunity opp = New Opportunity();
        opp.AccountID = a.Id;
        opp.Name = 'Test';
        opp.Gift_Kind__c = 'SUSTAINING';
        opp.CloseDate = system.Today().AddDays(15);
        opp.StageName = 'Pledged';
        opp.CampaignID = c2.Id;
        opp.RecordTypeId = r.id;
        insert opp;
        
        
        processGiving(PB,cnt.id,a.id);

        stopProcessing(pb, InsufficientInfo);
        
        processClassification(pb, cnt.id,a.id,opp);
        addBenefits(pb,opp);
        createChild(opp);
        generatePledgeName(opp);
        
        ID pID;
        
        pID = getRecordTypeIdByName('Annual');
        getChildRecordTypeId(pID);
        
        pID = getRecordTypeIdByName('Donation');
        getChildRecordTypeId(pID);
        
        pID = getRecordTypeIdByName('Inkind');
        getChildRecordTypeId(pID);
        
        pID = getRecordTypeIdByName('Purchase');
        getChildRecordTypeId(pID);
        
        pID = getRecordTypeIdByName('Major Gifts');
        getChildRecordTypeId(pID);
        
        pID = getRecordTypeIdByName('Annual');
        getChildRecordTypeId(pID);
        
        checkPaymentFrequency('A');
        checkPaymentFrequency('Q');
        checkPaymentFrequency('B');
        checkPaymentFrequency('S');
        checkPaymentFrequency('K');
        
        checkGiftType('RN');
        checkGiftType('RJ');
        checkGiftType('UR');
        checkGiftType('AD');
        checkGiftType('DO');
        checkGiftType('PR');
        checkGiftType('KK');
        
        checkGiftKind('OP');
        checkGiftKind('IN');
        checkGiftKind('SG');
        
        checkPaymentMethod('AV');
        checkPaymentMethod('AM');
        checkPaymentMethod('AD');
        checkPaymentMethod('BA');
        checkPaymentMethod('BD');
        checkPaymentMethod('BM');
        checkPaymentMethod('BV');
        checkPaymentMethod('BX');
        checkPaymentMethod('CA');
        checkPaymentMethod('CK');
        checkPaymentMethod('EF');
        checkPaymentMethod('IK');
        checkPaymentMethod('ND');
        checkPaymentMethod('NP');
        checkPaymentMethod('PD');
        checkPaymentMethod('PP');
        checkPaymentMethod('ST');
        checkPaymentMethod('VG');
        checkPaymentMethod('KA');
        checkPaymentMethod('KD');
        checkPaymentMethod('KM');
        
        calculateDate(system.today(), System.Label.RecurringDonationInstallmentPeriodYearly, 1);
        calculateDate(system.today(), System.Label.RecurringDonationInstallmentPeriodQuarterly, 1);
        calculateDate(system.today(), System.Label.RecurringDonationInstallmentPeriodMonthly, 1);
        calculateDate(system.today(), System.Label.RecurringDonationInstallmentPeriodWeekly, 1);
        calculateDate(system.today(), 'Bi-Monthly', 1);
        calculateDate(system.today(), 'Semi-Annually', 1);
        calculateDate(system.today(), 'TestAnnually', 1);

        generateName(system.today(), 1, 1, 'Test');
        
        
    }
}