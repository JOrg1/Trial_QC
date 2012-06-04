Public Class UploadRecordMatchingGivingNew{

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
    Static Integer intPaymentDateRange = 30;
    Static Integer PaymentDateRange(){
        String strInt = System.Label.PB5PaymentDateRange;
        if(NVL(strInt) <> ''){
            intPaymentDateRange = Integer.valueOf(strInt);
        }
        else{
            intPaymentDateRange = 30;
        }
        return intPaymentDateRange;
    }
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
    static void setRequiresReview(WGBH_PB5_UPLOAD__c PB, String Reason, String additionalInfo) {
        pb.Flag_for_Review__c = true;
        pb.Flag_Review_Reason__c = Reason;
        pb.Flag_Review_Exception__c = additionalInfo;
        pb.PB5_IS_PROCESSED__c = false;
        pb.PB5_IS_NEW__c = true;
        pb.PB5_Stage__c = 'A';
        pb.PB5_REQUIRES_REVIEW__c = true;
        system.debug('############### STOP PROCESSING GIVING: setRequiresReview');
        Update pb;
        return;
    }
    Static string InsufficientInfo = 'Insufficient Information';
    Static string MultipleMatching = 'MORE THAN 1 MATCH';
    Static string PledgeIdNumberExists = 'SFDC PLEDGE ID or PLEDGE NUMBER EXIST';
    Static string GiftTypeNull = 'GIFT TYPE IS NULL';
    Static string GiftMembership = 'GIFT MEMBERSHIP';
    Static string InstallmentNotFound = 'Installment not found';
    Static String ParentSustaininggift = 'Parent Sustaining gift';
    Static String PledgeAlreadyExists = 'Pledge already exists';
    Static String RequiresReview = 'Requires Review';
    
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
            freq = 'Annually';
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
    
    Static Boolean UpdateChild(WGBH_PB5_UPLOAD__c PB, Opportunity objParent){
        List<Opportunity> lstChild = new List<Opportunity>();
        Date CompareDate = null;
        system.debug('######## From Update Child');
        if(PB.Payment_Date__c != null){
            CompareDate = PB.Payment_Date__c;
        }
        else if(PB.PB5_GIFT_CDATE__c != null){
            CompareDate = PB.PB5_GIFT_CDATE__c;
        }
        system.debug('####### CompareDate >>> ' + CompareDate);
        if(CompareDate != null){
            lstChild = getChildByDate(objParent.Id,CompareDate);
        }
        if(lstChild.size() == 0){
            lstChild = getRecentChild(objParent.Id);
        }
        system.debug('###### Child found : ' + lstChild.size());
        if(lstChild != null && lstChild.size()>0){
            return ProcessChild(PB, lstChild);
        }
        else{
            stopProcessing(pb, InstallmentNotFound, InstallmentNotFound);
            return false;
        }
    }
    Static Decimal decimalNVL(Decimal val){
        if(val == null)
            return 0.0;
        else
            return val;
    }
    Static Boolean checkInstallments(WGBH_PB5_UPLOAD__c pb, String AccountId, String ContactId){
        setCustomSetting();
        Decimal PB5InstallmentAmount = decimalNVL(pb.PB5_Installment_Amount__c);
        Decimal PB5PaymentAmount = decimalNVL(pb.PB5_Payment_Amount__c);
        Date PB5PaymentDate = null;
        Date PB5GiftDate = null;
        if(pb.Payment_Date__c != null){
            PB5PaymentDate = pb.Payment_Date__c;
        }
        else if(pb.PB5_Gift_Cdate__c != null){
            PB5PaymentDate = pb.PB5_Gift_Cdate__c;
        }
        if(pb.PB5_Gift_Cdate__c != null){
            PB5GiftDate = pb.PB5_Gift_Cdate__c;
        }
        List<Opportunity> lstDuplicateGiving = new List<Opportunity>();
        if(NVL(pb.PB5_PLEDGE_NUMBER__c).length()>0){
            lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
            Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
            SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
            Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c,
            Campaign.Source_Code__c, Campaign.TA_Campaign_Source_Code__c, CampaignId
            From Opportunity Where AccountID =: ID.valueOf(AccountId)
            AND ((SFDC_GIVING_NUMBER__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and SFDC_GIVING_NUMBER__c!=null)
            OR (pledge_number__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and pledge_number__c != null))];
            system.debug('###### Record Found (1) : ' + lstDuplicateGiving.size());
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
            /////Extra Check for Convio and Kimbia
            //String RecordType = NVL(pb.RecordType.DeveloperName).toUpperCase();
            String RecordType = NVL(pb.PB5_UPLOAD_SOURCE__c).toUpperCase();
            if(lstDuplicateGiving.size() == 0 && RecordType != '' && (RecordType == 'CONVIO' || RecordType == 'KIMBIA')){
                if(objCPRT == null){
                    objCPRT = getCPRT(SourceCode);
                }
                List<Opportunity> lstDup = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
                Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
                SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
                Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c,
                Campaign.Source_Code__c, Campaign.TA_Campaign_Source_Code__c, CampaignId
                From Opportunity 
                Where AccountID =: ID.valueOf(AccountId)
                And (Gift_Kind__c != null And Gift_Kind__c =: GiftKind)
                And (Installment_Amount__c != null And Installment_Amount__c =: PB5PaymentAmount)
                //And (Schedule_Start_Date__c != null and Schedule_Start_Date__c =: PB5GiftDate)
                And (Station__c != null and Station__c =: Station)];
                
                if(lstDup != null && lstDup.size()>0){
                    for(Opportunity opp:lstDup){
                        if(opp.Schedule_Start_Date__c != null && (opp.Schedule_Start_Date__c >= PB5GiftDate.addDays((-1)*PaymentDateRange()) && opp.Schedule_Start_Date__c <= PB5GiftDate.addDays(PaymentDateRange()))){
                            lstDuplicateGiving.add(opp);
                        }
                    }                
                    system.debug('###### Record Found (2) : ' + lstDuplicateGiving.size());
                }
            }
            //////////////////////////////////////
            if(lstDuplicateGiving.size() == 0){
                lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
                Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
                SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
                Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c,
                Campaign.Source_Code__c, Campaign.TA_Campaign_Source_Code__c, CampaignId
                From Opportunity 
                Where AccountID =: ID.valueOf(AccountId)
                And (Gift_Kind__c != null And Gift_Kind__c =: GiftKind)
                And (Station__c != null And Station__c =: Station)
                And (CampaignId != null And ((Campaign.Source_Code__c != null And Campaign.Source_Code__c=:SourceCode) 
                    Or (Campaign.TA_Campaign_Source_Code__c != null and Campaign.TA_Campaign_Source_Code__c =: sourceCode)))];
                
                system.debug('###### Record Found (3) : ' + lstDuplicateGiving.size());
                System.debug('#### Record found based on Source code, station etc...' + lstDuplicateGiving);
            }
            if(lstDuplicateGiving.size() == 0){
                if(objCPRT == null){
                    objCPRT = getCPRT(SourceCode);
                }
                system.debug('########## Household : ' + AccountId);
                lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
                Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
                SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
                Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c,
                Campaign.Source_Code__c, Campaign.TA_Campaign_Source_Code__c, CampaignId
                From Opportunity 
                Where AccountID =: ID.valueOf(AccountId)
                and Product__c =: objCPRT.Product_Program__c
                and Station__c =: objCPRT.Station__c
                and Campaign_Name__c =: objCPRT.Campaign_Name__c]; 
                
                system.debug('###### Record Found (4) : ' + lstDuplicateGiving.size());           
                System.debug('##### Record found based on Campaign Details : ' + lstDuplicateGiving);
            }
        }
        system.debug('########## lstDuplicateGiving.size() ' + lstDuplicateGiving.size());
        if(lstDuplicateGiving != null && lstDuplicateGiving.size()>0){
            if(lstDuplicateGiving[0].Gift_Kind__C == SUSTAINING || lstDuplicateGiving[0].Gift_Kind__C == INSTALLMENT){
                for(Opportunity opp:lstDuplicateGiving){
                    if(opp.Recurring_Donation_Opportunity__c == null){
                        system.debug('######### Parent found ProcessChild Line 257');
                        return UpdateChild(PB,opp);                        
                    }
                }
                if(lstDuplicateGiving.size()>1){
                    if(PB.Payment_Date__c != null){
                        List<Opportunity> lstChild = new List<Opportunity>();
                        for(Opportunity opp:lstDuplicateGiving){
                            if(opp.Schedule_Start_Date__c >= PB.Payment_Date__c.addDays((-1)*PaymentDateRange()) && opp.Schedule_Start_Date__c <= PB.Payment_Date__c.addDays(PaymentDateRange())){
                                lstChild.add(opp);
                                system.debug('######### Child found ProcessChild Line 268');
                                return ProcessChild(PB, lstChild);
                            }
                        }
                        lstChild.add(lstDuplicateGiving[0]);
                        system.debug('######### Child found ProcessChild Line 272');
                        return ProcessChild(PB, lstChild);
                    }
                }
                else if(lstDuplicateGiving.size() == 1){
                    List<Opportunity> lstChild = new List<Opportunity>();
                    lstChild.add(lstDuplicateGiving[0]);
                    system.debug('######### Child found ProcessChild Line 279');
                    return ProcessChild(PB, lstChild);
                }
            }
            else{
                /*
                List<Opportunity> lstChild = new List<Opportunity>();
                lstChild.add(lstDuplicateGiving[0]);
                system.debug('######### Parent found ProcessChild (one payment) Line 286');
                return ProcessChild(PB, lstChild);
                */
                //PB5InstallmentAmount 
                //PB5PaymentAmount
                Boolean blnFound = false;
                for(Opportunity opp:lstDuplicateGiving){
                    Date GivingDate = null;
                    if(opp.Schedule_Start_Date__c != null){
                        GivingDate = opp.Schedule_Start_Date__c;
                    }
                    else if(opp.Gift_Date_Time__c != null){
                        GivingDate = opp.Gift_Date_Time__c.date();
                    }
                    else{
                        GivingDate = opp.CloseDate;
                    }
                    if((GivingDate >= PB5PaymentDate.addDays((-1)*PaymentDateRange()) && GivingDate <= PB5PaymentDate.addDays(PaymentDateRange())) &&
                    PB5PaymentAmount == opp.Giving_Amount__c){
                        List<Opportunity> lstChild = new List<Opportunity>();
                        lstChild.add(lstDuplicateGiving[0]);
                        system.debug('######### Parent found ProcessChild (one payment) Line 286');
                        blnFound = true;
                        return ProcessChild(PB, lstChild);
                    }
                }
                if(blnFound == false){
                    stopProcessing(PB,InstallmentNotFound ,InstallmentNotFound);
                    return false;
                }
            }
        }
        else{
            System.debug('#### No giving found ');
            createGiving(PB, ContactId, AccountId);
        }
        return false;
    }    
    static boolean checkWithGiftDateAmount(WGBH_PB5_UPLOAD__c PB, String householdId){
        Boolean flag = false;
        Campaign objCampaign = getCPRT(NVL(pb.PB5_SOURCE__c));
        if(objCampaign != null){
            String GiftKind = checkGiftKind(pb.PB5_GIFT_KIND__c);
            Date PB5GiftDate = PB.PB5_Gift_CDate__c;
            System.debug('########## checkWithGiftDateAmount Gift Kind : ' + GiftKind);
            System.debug('########## checkWithGiftDateAmount PB5 GiftDate : ' + PB5GiftDate);
            
            List<Opportunity> lstOpp = [Select Gift_Date_Time__c, CloseDate
            From Opportunity Where AccountId =:householdId
            and Giving_Amount__c =:PB.PB5_Pledge_Amount__c
            and Gift_Kind__c =: GiftKind
            and (CampaignId != null And ((Campaign.Source_Code__c != null And Campaign.Source_Code__c=:NVL(pb.PB5_SOURCE__c)) 
                Or (Campaign.TA_Campaign_Source_Code__c != null and Campaign.TA_Campaign_Source_Code__c =: NVL(pb.PB5_SOURCE__c))))];

            System.debug('########### checkWithGiftDateAmount found Opportunity : ' + lstOpp);
            if(lstOpp != null && lstOpp.size()>0){
                
                for(Opportunity opp:lstOpp){
                    Date GivingDate = null;
                    if(opp.Gift_Date_Time__c != null){
                        GivingDate = opp.Gift_Date_Time__c.date();
                    }
                    else{
                        GivingDate = opp.CloseDate;
                    }
                    if(GivingDate >= PB5GiftDate.addDays((-1)*PaymentDateRange()) && GivingDate <= PB5GiftDate.addDays(PaymentDateRange())){
                        system.debug('####### record Matched  ' + opp);
                        flag = true;
                        break;
                    }
                }        
            }                
        }
        system.debug('>>>>>>>>>> checkWithGiftDateAmount >>>>--- ' + flag);
        return flag;
    }
    public static void processGiving(WGBH_PB5_UPLOAD__c PB, String ContactId, String householdId){        
        setCustomSetting();
        objCPRT = getCPRT(NVL(pb.PB5_SOURCE__c));
        if(objCPRT == null){
            stopProcessing(pb, InsufficientInfo, 'PB5_Source code is null Or does not matched with Campaign.');
            return;
        }
        //IsSFDCIDOrPledgeNumberExists
        //In order to determine the Transaction Type 
        //(PL = new gift or PP = payment on existing gift):
        if(NVL(householdId) == ''){
            stopProcessing(pb, InsufficientInfo, 'Account not found.');
            return;
        }
        String TransactionType = NVL(pb.PB5_TRANSACTION_TYPE__c);
        if(TransactionType == 'PL'){//new gift
            /*
            if(checkGiftKind(PB.PB5_Gift_Kind__c) == SUSTAINING){
                stopProcessing(pb, ParentSustainingGift, ParentSustainingGift);
                return;
            }
            */
            if(checkGiftKind(PB.PB5_Gift_Kind__c) == SUSTAINING && (PB.PB5_READY_FOR_PROCESSING__C == false)){
                setRequiresReview(pb, RequiresReview, ParentSustainingGift);
                return;
            }
            
            if(IsSFDCIDOrPledgeNumberExists(pb,householdId)==false){
                if(checkWithGiftDateAmount(pb, householdId)==true){
                    stopProcessing(pb, PledgeAlreadyExists, PledgeAlreadyExists);
                    return;                
                }
                else{
                    createGiving(PB, ContactId, householdId);
                }
            }
            else{
                stopProcessing(pb, PledgeIdNumberExists, PledgeIdNumberExists);
                return;
            }
        }
        else if(TransactionType == 'PP'){//payment on existing gift
            if(checkInstallments(PB, householdId, ContactId)==false){
                //createGiving(PB, ContactId, householdId);
                return;
            }
        }
        else if(TransactionType == ''){
            stopProcessing(pb, InsufficientInfo,'Transaction Type is blank.');
            return;
        }
        else{
            stopProcessing(pb, InsufficientInfo,'Value for Transaction Type should should be PP or PL.');
            return;
        }
        return;
        /*
        if(NVL(householdId) == ''){
            stopProcessing(pb, InsufficientInfo, 'NVL(householdId) == blank');
            return;
        }
        if(checkInstallments(PB, householdId)==false){
            system.debug('############## Parent or child not found going to create...');
            createGiving(PB, ContactId, householdId);
        }
        else{
            system.debug('############## Parent or Child found and updated successfully !!!');
        }
        */
    }
    Static Boolean IsSFDCIDOrPledgeNumberExists(WGBH_PB5_UPLOAD__c pb, String AccountId){
        setCustomSetting();
        Boolean flag = false;
        List<Opportunity> lstOpp;
        if(NVL(pb.PB5_PLEDGE_NUMBER__c).length()>0){
            lstOpp = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
            Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
            SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c, CampaignId,
            Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
            From Opportunity Where AccountID =: ID.valueOf(AccountId)
            AND ((SFDC_GIVING_NUMBER__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and SFDC_GIVING_NUMBER__c!=null)
            OR (pledge_number__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and pledge_number__c != null))];
            
            if(lstOpp != null && lstOpp.size()>0){
                flag = true;
            }
        }
        return flag;
    }
    Static List<Opportunity> getChildByDate(ID ParentId, Date PaymentDate){
        List<Opportunity> lstGiving =
        [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, CampaignId, Product__c, Schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
        From Opportunity 
        Where Recurring_Donation_Opportunity__c =: ParentId
        and StageName <> 'Fulfilled' Order By Schedule_start_date__c Asc];
        List<Opportunity> child = new List<Opportunity>();
        System.debug('############## PB5 Payment Date : ' + PaymentDate);
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity opp:lstGiving){
                if(opp.Schedule_Start_Date__c >= PaymentDate.addDays((-1)*PaymentDateRange()) && opp.Schedule_Start_Date__c <= PaymentDate.addDays(PaymentDateRange())){
                    system.debug('####### record Matched  ' + opp);
                    child.add(opp);
                }
            }        
        }
        return child;
    }
    Static List<Opportunity> getRecentChild(ID ParentId){
        List<Opportunity> lstGiving =
        [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, CampaignId, Product__c, Schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
        From Opportunity 
        Where Recurring_Donation_Opportunity__c =: ParentId
        and StageName <> 'Fulfilled' Order By Schedule_start_date__c Asc Limit 1];
        
        return lstGiving;
    }
    Static Opportunity getParentByChild(Opportunity objChild){
        if(objChild != null && objChild.Recurring_Donation_Opportunity__c != null){
            List<Opportunity> lstOpp = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
            Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
            SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
            Payment_Method_Description__c, CampaignId, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
            From Opportunity
            Where Id =:objChild.Recurring_Donation_Opportunity__c];
            if(lstOpp != null && lstOpp.size()>0){
                return lstOpp[0];
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
    }
    Static Boolean ProcessChild(WGBH_PB5_UPLOAD__c PB, List<Opportunity> lstChild){
        Opportunity objChild = new Opportunity();
        Opportunity objParent = new Opportunity();
        if(lstChild != null && lstChild.size() > 0){
            
            system.debug('########## Updating Child ');
            objChild = lstChild[0];
            objParent = getParentByChild(objChild);
            if(objParent == null){
                objParent = objChild;
            }
            if(objChild.Payment_Amount__c != null){
                objChild.Payment_Amount__c += PB.PB5_PAYMENT_AMOUNT__c;
            }
            else{
                objChild.Payment_Amount__c = PB.PB5_PAYMENT_AMOUNT__c;
            }
            if(pb.Payment_Date__c != null){
                objChild.Payment_Date__c = pb.Payment_Date__c;
            }
            else if(pb.Transaction_Date__c != null){
                objChild.Payment_Date__c = pb.Transaction_Date__c.date();
            }
            else if(pb.PB5_PAYMENT_AMOUNT__c != null && pb.PB5_PAYMENT_AMOUNT__c > 0){
                objChild.Payment_Date__c = system.today();
            }
            Decimal InstallmentAmount;
            
            if(objChild.Recurring_Donation_Opportunity__c == null){
                InstallmentAmount = objChild.Giving_Amount__c;
            }
            else{
                InstallmentAmount = objChild.installment_Amount__c;
            }
            
            if(objChild.Payment_Amount__c == null){
                objChild.StageName = 'Pledged';
            }
            else if(objChild.Payment_Amount__c == 0){
                objChild.StageName = 'Pledged';
            }    
            else if(objChild.Payment_Amount__c < InstallmentAmount){
                objChild.StageName = 'Partially Fulfilled';
            }
            else if(objChild.Payment_Amount__c >= InstallmentAmount){
                objChild.StageName = 'Fulfilled';
            }
            else{
                objChild.StageName = 'Pledged';
            }
            if(objChild.Gift_Date_Time__c == null){
                if(objParent != null && objParent.Gift_Date_Time__c != null){
                    objChild.Gift_Date_Time__c = objParent.Gift_Date_Time__c;
                }
            }
            if(NVL(objChild.Gift_Kind__c) == ''){
                if(objParent != null && objParent.Gift_Kind__c != null){
                    objChild.Gift_Kind__c = objParent.Gift_Kind__c;
                }
            }
            if(NVL(objChild.Gift_Type__c) == ''){
                if(objParent != null && objParent.Gift_Type__c != null){
                    objChild.Gift_Type__c = objParent.Gift_Type__c;
                }
            }
            try{
                Update objChild;
                commonApex.UpdatePB5Lookups(pb,null, null, objChild.Id,objParent.CampaignId);
                Set<ID> setGivingIds = new Set<ID>();
                setGivingIds.add(objChild.Id);
                system.debug('######## Giving Ids : ' + setGivingIds);
                ProcessGivingSummary.UpdateSummary(setGivingIds,true);
                
                
                pb.Flag_for_Review__c = false;
                pb.PB5_IS_PROCESSED__c = true;
                pb.PB5_IS_NEW__c = false;
                pb.Flag_Review_Reason__c = '';
                pb.Flag_Review_Exception__c = '';
                pb.PB5_Stage__c = 'C';
                Update PB; 
                return true;                       
            }
            catch(Exception ex){
                stopProcessing(pb, InsufficientInfo, ex.getMessage());
                return false;
            }
        }
        else{
            stopProcessing(pb, InstallmentNotFound, InstallmentNotFound);
            return false;
        }
    }

    public static void CreateGiving(WGBH_PB5_UPLOAD__c PB, String ContactId, String householdId){
        if(NVL(householdId) == ''){
            stopProcessing(pb, InsufficientInfo, 'NVL(householdId) == blank');
            return;
        }
        getRecordType();
        Opportunity opp = new Opportunity();
        if(objCPRT == null){
            objCPRT = getCPRT(NVL(pb.PB5_SOURCE__c));
        }
        if(objCPRT == null){
            stopProcessing(pb, InsufficientInfo, 'objCPRT == null');
            return;
        }
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
        opp.AccountId = householdId;
        opp.RecordTypeId = getRecordTypeIdByName(rcType);
        system.debug('########## Giving RecordType : ' + pb.Giving_Record_Type__c + ' ---- ' + opp.RecordTypeId);
        opp.Schedule_Start_Date__c = opp.closeDate;
        opp.Gift_Kind__c = checkGiftKind(pb.PB5_GIFT_KIND__c);
        if(NVL(opp.Gift_Kind__c)==''){
            opp.Gift_Kind__c = objCustomSetting.Gift_Kind__c;
            //stopProcessing(pb, InsufficientInfo);
            //return;
        }
        opp.Caller__c = NVL(pb.PB5_CALLER__c);
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
        if(NVL(opp.payment_frequency__c) == '' && opp.Gift_Type__c != 'One Payment'){
            opp.payment_frequency__c = CalculateFrequency(opp.Giving_Amount__c, opp.Installment_Amount__c);
        }
        
        if(NVL(opp.Payment_Method__c)==''){
            stopProcessing(pb, InsufficientInfo, 'NVL(opp.Payment_Method__c) == blank');
            return;
        }
        
        //pb.PB5_PLEDGE_CTIME__c;
        try{
            opp.pledge_number__c = pb.PB5_PLEDGE_NUMBER__c;
        }Catch(Exception ex){
        }
        if(NVL(pb.PB5_STATION_SOURCE__c) == ''){
            opp.Station__c = NVL(objCustomSetting.Station__c);
        }
        else{
            opp.Station__c = pb.PB5_STATION_SOURCE__c;
        }
        opp.Support_Designation__c = NVL(pb.PB5_STATION_SUPPORT__c); //(Support Designation)
        opp.SFDC_Opportunity_ID__c = String.valueof(pb.PB5_SFDC_ID__c);
        
        opp.name = generatePledgeName(opp);
        
        opp.Oppty_Related_Contact__c = ContactId;
        ///////////////////////
        if(objCPRT != null){
            opp.CampaignId = objCPRT.Id;
            //OverloadedGiftType = objCPRT.Override_Gift__c;
            opp.Giving_Segment__c = objCPRT.Giving_Segment__c;
            //opp.Gift_Type__c = objCPRT.Gift_Type__c;
            if(NVL(opp.Support_Designation__c) == ''){
                opp.Support_Designation__c = objCPRT.Support_Designation__c;
            }
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
                    opp.Installment_Period__c = 'Annually';
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
        try{
            opp.AccountId = householdId;
            Insert opp;
            commonApex.UpdatePB5Lookups(pb,null, null, opp.Id,objCPRT.Id);
            Set<ID> setGivingIds = new Set<ID>();
            setGivingIds.add(opp.Id);
            system.debug('######## Giving Ids : ' + setGivingIds);
            ProcessGivingSummary.UpdateSummary(setGivingIds,false);
            system.debug('############### calling function create child');
            createChild(opp);
            
            //addBenefits(pb,opp);
            GivingBenefit.ApplyBenefit(opp, pb);
            processClassification(pb, contactid, householdid, opp);   
            
            pb.Flag_for_Review__c = false;
            pb.PB5_IS_PROCESSED__c = true;
            pb.PB5_IS_NEW__c = false;
            pb.Flag_Review_Reason__c = '';
            pb.Flag_Review_Exception__c = '';
            pb.PB5_Stage__c = 'C';
        }Catch(Exception ex){
            pb.Flag_for_Review__c = true;
            pb.PB5_IS_PROCESSED__c = false;
            pb.PB5_IS_NEW__c = true;
            pb.Flag_Review_Reason__c = InsufficientInfo;
            pb.Flag_Review_Exception__c = ex.GetMessage();
            pb.PB5_Stage__c = 'B';
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
                opp.Caller__c = NVL(parent.Caller__c);
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

    public static String generatePledgeName(Opportunity objPledges){
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
                    pName += ' ' + objCPRT.Station__c;
                else
                    pName += objCPRT.Station__c;
            if(objCPRT.Campaign_Name__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Campaign_Name__c;
                else
                    pName += objCPRT.Campaign_Name__c;
            if(objCPRT.Giving_Segment__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Giving_Segment__c;
                else
                    pName += objCPRT.Giving_Segment__c;
                
            if(objCPRT.Solicitation_Type__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Solicitation_Type__c;
                else
                    pName += objCPRT.Solicitation_Type__c;
        
        }
        return pName;
    }
    static String generatePledgeName1(Opportunity objPledges){
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