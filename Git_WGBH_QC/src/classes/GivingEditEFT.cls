public class GivingEditEFT {

    Public Opportunity objPledges {get; set;}
    public Contact objContact {get; set;}
    public Account objHousehold {get; set;}    
    String Id;
    String ccId;
    public GivingEditEFT(ApexPages.StandardController controller) {

        Id = ApexPages.CurrentPage().getParameters().get('id');
        ccId = ApexPages.CurrentPage().getParameters().get('ccId');
        objPledges = [Select AccountId,Oppty_Related_Contact__c,StageName, Refused_Reason__c , Gift_Kind__c
           ,Schedule_Start_Date__c,Payment_Date__c,Payment_Method__c,payment_amount__c,RecordTypeId
           ,Payment_method_description__c,Charge_Card_Type__c    ,Giving_Amount__c,Station__c , installment_amount__c,
           Recurring_Donation_Opportunity__c, Recurring_Donation_Opportunity__r.AccountId, CC_EFT_Alias__c,
           Recurring_Donation_Opportunity__r.Oppty_Related_Contact__c
            From Opportunity Where Id=:Id]; 
        bDisplayNewCard = true;
            setContactDetail();
            setHouseholdDetail();
        /**** WGBHQC-65 JIRA 11-May-2012 ****/
        checkPaymentMethod();
        /**** WGBHQC-65 JIRA 11-May-2012 ****/
    }
    
    /**** WGBHQC-70 JIRA 01-Jun-2012 ****/
    public List<SelectOption> getPaymentMethod(){
        List<SelectOption> options = new List<SelectOption>();
        /*
        Schema.DescribeFieldResult fieldResult = Opportunity.payment_method__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        */
        options.add(new SelectOption('--None--', '--None--'));
        
        options.add(new SelectOption('Cash', 'Cash'));
        options.add(new SelectOption('Check', 'Check'));
        options.add(new SelectOption('Complimentary', 'Complimentary'));
        options.add(new SelectOption('In Kind', 'In Kind'));
        options.add(new SelectOption('Life Insurance', 'Life Insurance'));
        options.add(new SelectOption('Mutual fund', 'Mutual fund'));
        options.add(new SelectOption('PayPal', 'PayPal'));
        options.add(new SelectOption('Payroll Deduction', 'Payroll Deduction'));
        options.add(new SelectOption('Personal Property', 'Personal Property'));
        options.add(new SelectOption('Real Estate', 'Real Estate'));
        options.add(new SelectOption('Stock', 'Stock'));
        options.add(new SelectOption('Vehicle Giving', 'Vehicle Giving'));
        options.add(new SelectOption('American Express', 'American Express'));
        options.add(new SelectOption('Wire Transfer', 'Wire Transfer'));
        
        Boolean blnFound = false;
        for(SelectOption so:options){
            if(objPledges.payment_method__c == so.getValue()){
                blnFound = true;
                break;
            }
        }
        if(blnFound == false){
            options.add(new SelectOption(objPledges.payment_method__c, objPledges.payment_method__c));
        }
        //options.add(new SelectOption('Charge Card', 'Charge Card'));
        //options.add(new SelectOption('Electronic Funds Transfer', 'Electronic Funds Transfer'));
        
        return options;
    }
    /**** WGBHQC-70 JIRA 01-Jun-2012 ****/
    
    Public PageReference ChoosePaymentMode(){
        /**** WGBHQC-65 JIRA 11-May-2012 ****/
        checkPaymentMethod();
        /**** WGBHQC-65 JIRA 11-May-2012 ****/
        return null;
    }
    /**** WGBHQC-65 JIRA 11-May-2012 ****/
    Public Boolean blnFulfillMsg{get;set;}
    Public String MessageFullfilledStage{get;set;}
    Public void checkPaymentMethod(){
        String AllowFulfillPaymentMethods = System.Label.AllowFulfillPaymentMethods;
        MessageFullfilledStage = System.Label.MessageFullfilledStage;
        if(AllowFulfillPaymentMethods.contains(objPledges.Payment_Method__c) == true){
            if(objPledges.StageName == 'Fulfilled' && decimalNVL(objPledges.Payment_Amount__c) > 0 && objPledges.Payment_Amount__c < objPledges.Giving_Amount__c){
                blnFulfillMsg = true;
            }
            else{
                blnFulfillMsg = false;
            }
        }
        else{
            blnFulfillMsg = false;
        }
    }
    decimal decimalNVL(decimal dec){
        if(dec == null)
            return 0;
        else
            return dec;
    }
    /**** WGBHQC-65 JIRA 11-May-2012 ****/
    public PageReference GivingSave()
    {

        GivingSaveMe();
        
        String retURL;
        retURL = ApexPages.CurrentPage().getParameters().get('Id');
        return RedirectPage('/'+retURL);

    }
    String NVL(String val){
        if(val == null)
            return '';
        else
            return val.trim();
    }
    Private Boolean GivingSaveMe()
    {
        system.debug('######### objPledges.CC_EFT_Alias__c (line 41) : ' + objPledges.CC_EFT_Alias__c);
        if(objCCAlias != null && objCCAlias.Id != null){
            objPledges.CC_EFT_Alias__c = objCCAlias.Id;
            system.debug('******** on Save objCCAlias.Id : ' + objCCAlias.Id);
        }
        if(objCCAlias1 != null && objCCAlias1.Id != null){
            objPledges.CC_EFT_Alias__c = objCCAlias1.Id;
            system.debug('******** on Save objCCAlias1.Id : ' + objCCAlias1.Id);
        }
        Update objPledges;
        /*******************/
        system.debug('######### objPledges.CC_EFT_Alias__c (line 52) : ' + objPledges.CC_EFT_Alias__c);
        system.debug('########## objPledges ==> ' + objPledges);
        
        if(NVL(objPledges.CC_EFT_Alias__c) != '' && NVL(objPledges.Gift_Kind__c) != 'One Payment'){
            List<Opportunity> lstUpdateChild = new List<Opportunity>();
            List<Opportunity> lstChild = 
            [Select Id, CC_EFT_Alias__c, StageName From Opportunity 
            Where Recurring_Donation_Opportunity__c != null and Recurring_Donation_Opportunity__c =: objPledges.Id ];
            if(lstChild != null && lstChild.size()>0){
                for(Opportunity opp:lstChild){
                    if(opp.StageName == 'Pledged'){
                        opp.CC_EFT_Alias__c = objPledges.CC_EFT_Alias__c;
                        opp.Payment_Method__c = objPledges.Payment_Method__c;
                        lstUpdateChild.add(opp);
                    }
                }
                if(lstUpdateChild != null && lstUpdateChild.size()>0){
                    update lstUpdateChild;
                }
            }
        }
        //KCRW-25
        system.debug('###### lstChargeCard2 : ' + lstChargeCard2);
        if(lstChargeCard2 != null && lstChargeCard2.size()>0){
            List<CC_Alias__c> lstUpdate = new List<CC_Alias__c>();
            for(CC_Alias__c cc:lstChargeCard2){
                if(cc.Id != null){
                    lstUpdate.add(cc);
                }
            }
            system.debug('###### lstUpdate : ' + lstUpdate);
            if(lstUpdate.size()>0){
                update lstUpdate;
            }
        }
        //KCRW-25
        
        /*******************/
        Set<ID> setGivingIDs = new Set<ID>();
        if(objPledges.Id != null){
            setGivingIds.add(objPledges.Id);
            try{
                ProcessGivingSummary.UpdateSummary(setGivingIds,true);
            }Catch(Exception ex){
            }
        }
        return true;
    }
    Public List<CC_Alias__c> lstChargeCard2 {get;set;}
    Public List<CC_Alias__c> getExistingChargeCard(){
        lstChargeCard2 = new List<CC_Alias__c>();
        lstChargeCard2 = [Select Id, Name, Card_Type__c, Expire_Date__c, Last_Four_Digits__c,
        Card_Holder_Name__c, Merchant_Account__r.Station__c, City__c, State__c, Street1__c, Street2__c, Zipcode__c
        from CC_Alias__c 
        where (Account__c =: objPledges.AccountId and Account__c != null) 
    or (Contact__c =: objPledges.Oppty_Related_Contact__c and Contact__c != null)];
        /*
        List<CC_Alias__c> lstReturn = new List<CC_Alias__c>();
        CC_Alias__c temp = new CC_Alias__c();
        lstReturn.add(temp);
        for(CC_Alias__c e: lstChargeCard) {
            lstReturn.add(e);
        }
        */
        CC_Alias__c temp = new CC_Alias__c();
        lstChargeCard2.add(temp);
        system.debug('####### from getExistingChargeCard lstChargeCard2 : ' + lstChargeCard2);
        return lstChargeCard2;
        //return lstReturn;
    }
     void setContactDetail(){ 
       
        objContact = new Contact();
    
        if(objPledges.Oppty_Related_Contact__c != null){
            
            //Ketan Benegal - 05/16/2011 - added MailingCountry, MailingStreet, Fax to the following query for Sage Integration.
            objContact = [Select Id, Name, Salutation, FirstName, LastName, Email, MobilePhone,
            Birthdate, Phone, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStreet, Fax,
            Preferred_Address__r.Street_2__c, Preferred_Address__r.Street_1__c, Preferred_Address__r.State__c, Preferred_Address__r.Postal_Code__c, Preferred_Address__r.Country__c, Preferred_Address__r.City__c
            From Contact 
            Where Id =: objPledges.Oppty_Related_Contact__c];
        }
       
    }
    void setHouseholdDetail(){
        objHousehold = new Account();
        if(objPledges.Recurring_Donation_Opportunity__c != null){
            objHousehold = [Select Id, Name, AccountNumber, Phone, AccountType__c,
            Preferred_Address__r.Street_1__c, Preferred_Address__r.Street_2__c,
            Preferred_Address__r.City__c, Preferred_Address__r.State__c, Preferred_Address__r.Postal_Code__c
            From Account
            Where Id =: objPledges.Recurring_Donation_Opportunity__r.AccountId];
        }
    }
    
    PageReference RedirectPage(String URL){
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }
    
    
    Public PageReference NewChargeCode(){
        if(GivingSaveMe()==true){
            setContactDetail();
            setHouseholdDetail();
            system.debug('********** objhousehold 1 : ' + objHousehold);
            SaveCCAlias();
            system.debug('********** objhousehold 3 : ' + objHousehold);
            PageReference P = New PageReference('/apex/SageEditHtml?id=' + objPledges.Id + '&ccId=' + objCCAlias.Id);
            P.SetRedirect(true);
            return P;            
        }
        else
            return null;
    }
    //SAGE////////////////////////////////////////////////////////////////////////////
    public String strOutPut{get{return createGUID();/*return getOutPutString();*/} set;}
    Public List<CC_Alias__c> lstExistingEFT{get{return getExistingEFTInfo();}set;} 
    public CC_Alias__c objCCAlias1{get;set;} 
    public String strBankAccNo{get;set;}
    public String strRoutingNo{get;set;}
    public String strBankName{get;set;}
    public String strAccType{get;set;}
    Public List<CC_Alias__c> lstChargeCard{get;set;}
    public String strMerchantId{get;set;}
    public String strMerchantKey{get;set;}
    public String strCardHolderName{get;set;}
    public String strPledgeId{get; set;}
    public CC_Alias__c objCCAlias;
    public String strEFTGuid{get;set;}
    
    public class ApplicationException extends Exception{}
    public boolean displaySageHtml{get;set;}
    public boolean bDisplayNewCard{get;set;}
    public String strBillingStreet1{get;set;}
    public String strBillingStreet2{get;set;}
    public String strBillingCity{get;set;}
    public String strBillingState{get;set;}
    public String strBillingZipCode{get;set;}
    public boolean bEditBillingAddress{get;set;}
    
    public String strDisplayInformation{get{   return '<br/> Card Holder Name:' + this.strCardHolderName + '<br/> Giving Amount:' + this.objPledges.Giving_Amount__c + '<br/> Card Type:' + this.objPledges.Charge_Card_Type__c + '<br/>';} set;}
    
    boolean SaveCCAlias(){
        Boolean flag = false;
        system.debug('********** objhousehold 2.1 : ' + objHousehold);
        system.debug('********** objhousehold 2.2 : ' + this.objHousehold);
        system.debug('********** Household Id 1 : ' + objHousehold.Id);
        system.debug('********** Household Id 2 : ' + this.objHousehold.Id);
        String strHouseHoldId = this.objHousehold.Id;
        objCCAlias = new CC_Alias__c();
        objCCAlias.Account__c = this.objHousehold.Id;
        objCCAlias.Contact__c = this.objContact.Id;
        //objCCAlias.TransactionID__c = this.objPledges.Id;
        objCCAlias.TransactionID__c = getVaultId();
        objCCAlias.Payment_Method__c = this.objPledges.Payment_Method__c; 
        objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
        objCCAlias.Card_Holder_Name__c = strCardHolderName;
        //Insert Merchant Account
        Merchant_Accounts__c lMerchID = [Select Id, Merchant_Key__c, Merchant_ID__c from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
        objCCAlias.Merchant_Account__c = lMerchId.Id;
        objCCAlias.GUID__c = null;
        //to get the child pledges use lstChild.
        this.strPledgeId = this.objPledges.Id;
        System.debug('SoapPost2 householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
        try{
            insert objCCAlias;
            system.debug('####### Inserted CC Alias Id : ' + objCCAlias.Id);
        }
        catch(Exception ex){
            return false;
        }
        system.debug('######### objPledges.CC_EFT_Alias__c (line 230) : ' + objPledges.CC_EFT_Alias__c);
        this.objPledges.CC_EFT_Alias__c = objCCAlias.Id;
        system.debug('######### objPledges.CC_EFT_Alias__c (line 232) : ' + objPledges.CC_EFT_Alias__c);
        this.objCCAlias1 = objCCAlias;
        //this.objCCAlias1 = setObjCCAliasDetails(objCCAlias.Id);
        this.strMerchantId = lMerchID.Merchant_ID__c;
        this.strMerchantKey = lMerchID.Merchant_Key__c;        
        return flag;
    }
    public void soapPost3(){
        if (this.displaySageHtml != true){
            System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
            System.debug('SoapPost3 111');
            CC_Alias__c objCCAlias = new CC_Alias__c();
            //objPledges.Charge_Card_Type__c = 'Mastercard';
            /*
            if(this.objPledges.Charge_Card_Type__c == '' || this.objPledges.Charge_Card_Type__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the card type.')); 
                system.debug('------------------------Please select the card type.');
                return;
            }
            */
            if(this.strCardHolderName == '' || this.strCardHolderName == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter card holder\'s name.')); 
                system.debug('------------------------Please enter card holder\'s name.');
                return;
            }
            
            if (this.GivingSaveMe()){
                System.debug('Calling save');
                String strHouseHoldId;
                if(objPledges.Recurring_Donation_Opportunity__c != null){
                    strHouseHoldId = objPledges.Recurring_Donation_Opportunity__r.AccountId; //this.objHousehold.Id;
                    objCCAlias.Account__c = objPledges.Recurring_Donation_Opportunity__r.AccountId; //this.objHousehold.Id;
                    objCCAlias.Contact__c = objPledges.Recurring_Donation_Opportunity__r.Oppty_Related_Contact__c;
                }
                else{
                    strHouseHoldId = objPledges.AccountId; //this.objHousehold.Id;
                    objCCAlias.Account__c = objPledges.AccountId; //this.objHousehold.Id;
                    objCCAlias.Contact__c = objPledges.Oppty_Related_Contact__c;
                }
                
                
                objCCAlias.TransactionID__c = getVaultId();
                objCCAlias.Payment_Method__c = this.objPledges.Payment_Method__c; 
                objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
                objCCAlias.Card_Holder_Name__c = strCardHolderName;
                Merchant_Accounts__c lMerchID = [Select Id, Merchant_Key__c, Merchant_ID__c from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
                objCCAlias.Merchant_Account__c = lMerchId.Id;
                objCCAlias.GUID__c = null;
                this.strPledgeId = this.objPledges.Id;
                objCCAlias.Opportunity__c = this.objPledges.Id;
                System.debug('SoapPost2 householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
                insert objCCAlias;
                system.debug('$$$$$$$$$$$ Inserted CC Alias Id : ' + objCCAlias.id);
                if(objCCAlias.Id != null){
                    system.debug('######### objPledges.CC_EFT_Alias__c (line 284) : ' + objPledges.CC_EFT_Alias__c);
                    objPledges.CC_EFT_Alias__c = objCCAlias.Id;
                    system.debug('######### objPledges.CC_EFT_Alias__c (line 286) : ' + objPledges.CC_EFT_Alias__c);
                    update objPledges;
                }
                ccId = objCCAlias.Id;
                //this.objPledges.CC_EFT_Alias__c = objCCAlias.Id;
                this.objCCAlias1 = objCCAlias;
                this.strMerchantId = lMerchID.Merchant_ID__c;
                this.strMerchantKey = lMerchID.Merchant_Key__c;
                System.debug('PledgeId: ' + objPledges.Id+ '***********************************this.objCCAlias1.id: '+this.objCCAlias1.id + '#################'+this.strMerchantId + '#################'+ this.strMerchantKey);
            }else{
                System.debug('SavePleged Failed!!');
            }
            showSageHtml();
        }   
        //get the preferred address values.
        strPreferredAddress();
        return;
    }
    public void showSageHtml(){
        System.debug('inside show');
        this.displaySageHtml = true;
    }
    public void hideSageHtml(){
        System.debug('inside hide');
        this.displaySageHtml = false;
    }
    public void strPreferredAddress(){
        if (this.objPledges.Oppty_Related_Contact__c != null){
            System.debug('Contact available.:' + this.objPledges.Oppty_Related_Contact__c);
            if (this.objContact.Preferred_Address__c != null){
                this.strBillingStreet1 = this.objContact.Preferred_Address__r.Street_1__c;
                this.strBillingStreet2 = this.objContact.Preferred_Address__r.Street_2__c ;
                this.strBillingCity = this.objContact.Preferred_Address__r.City__c;
                this.strBillingState = this.objContact.Preferred_Address__r.State__c;
                this.strBillingZipCode= this.objContact.Preferred_Address__r.Postal_Code__c;
                //return '<br/> Street1: ' + this.objContact.Preferred_Address__r.Street_1__c + '<br/> Street 2:'+ this.objContact.Preferred_Address__r.Street_2__c + '<br/> City:' + this.objContact.Preferred_Address__r.City__c + '<br/> State:' + this.objContact.Preferred_Address__r.State__c + '<br/> Country:' + this.objContact.Preferred_Address__r.Country__c;
            }
            else{
                System.debug('Contact Preferred Address not available.');
            }
         }else{
                System.debug('Contact not available.');
                this.strBillingStreet1 = this.objHousehold.Preferred_Address__r.Street_1__c;
                this.strBillingStreet2 = this.objHousehold.Preferred_Address__r.Street_2__c ;
                this.strBillingCity = this.objHousehold.Preferred_Address__r.City__c;
                this.strBillingState = this.objHousehold.Preferred_Address__r.State__c;
                this.strBillingZipCode = this.objHousehold.Preferred_Address__r.Postal_Code__c;
         }
         System.debug('strPreferredAddress this.strBillingStreet1:' + this.strBillingStreet1 + '^^^^^^^^^^^ this.strBillingStreet2:' + this.strBillingStreet2 + ' ^^^^^^^^^^^^ this.strBillingCity : '+ this.strBillingCity + ' ^^^^^^^^^^^^ this.strBillingZipCode:' + this.strBillingZipCode);
         return ;
    }
    public List<CC_Alias__c> getExistingEFTInfo(){
        lstChargeCard = new List<CC_Alias__c>();
        system.debug('getExistingEFTInfo ###### AccountID : ' +  objPledges.AccountId + ' and Contact__c : ' + objPledges.Oppty_Related_Contact__c );
        /*
        lstChargeCard = [Select c.Zipcode__c, c.VANReference__c, c.TransactionID__c, 
        c.SystemModstamp, c.Street2__c, c.Street1__c, c.State__c, c.Sage_Bank_Account_Type__c, 
        c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, 
        c.RecordTypeId, c.Payment_Method__c, c.Payment_ID__c, c.Payment_Description__c, 
        c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Last_Four_Digits__c, 
        c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, 
        c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.City__c, c.Card_Type__c, 
        c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, 
        c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c,
        Bank_account_number__c, Routing_number__c
        from CC_Alias__c c 
        where (c.Account__c =: objPledges.AccountId and c.Account__c != null) 
        or (c.Contact__c =: objPledges.Oppty_Related_Contact__c or c.Contact__c != null) limit 10];
        */
        List<CC_Alias__c> lstReturn = new List<CC_Alias__c>();
        
        lstReturn = [Select c.Zipcode__c, c.VANReference__c, c.TransactionID__c, c.SystemModstamp, c.Street2__c,
             c.Street1__c, c.State__c, c.Sage_Bank_Account_Type__c, c.Response__c, c.ResponseMessage__c, 
             c.ResponseIndicator__c, c.ResponseCode__c, c.RecordTypeId, c.Payment_Method__c, c.Payment_ID__c, c.Payment_Description__c, 
             c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Last_Four_Digits__c, c.LastModifiedDate, 
             c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, 
             c.Contact__c, c.City__c, c.Card_Type__c, c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, 
             c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c  ,
             c.Bank_account_number__c,c.Routing_number__c 
            from CC_Alias__c c where c.Account__c =: objPledges.AccountId and c.Contact__c =: objPledges.Oppty_Related_Contact__c and c.Payment_Method__c = 'Electronic Funds Transfer'];
        
        
        CC_Alias__c temp = new CC_Alias__c();
        //temp.Card_Type__c = 'New';
        lstReturn.add(temp);
        
        for(CC_Alias__c e: lstChargeCard) {
            lstReturn.add(e);
        }

        return lstReturn;
    }
    public String getOutPutString(){
        System.debug('getOutPutString 111');
        return createGUID();
    }
     
    public String createGUID(){
        String strVaultId2 = getVaultId();
        System.debug('CreateGuid strVaultId :' + ccId);
        System.debug('@@@@@@@@@@@@@ objCCAlias Id : ' + objCCAlias);
        CC_Alias__c objCCAliasTemp = [Select c.Zipcode__c, c.VANReference__c, c.TransactionID__c, 
        c.SystemModstamp, c.Street2__c, c.Street1__c, c.State__c, c.Sage_Bank_Account_Type__c, 
        c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, 
        c.RecordTypeId, c.Payment_Method__c, c.Payment_ID__c, c.Payment_Description__c, 
        c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Last_Four_Digits__c, 
        c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, 
        c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.City__c, c.Card_Type__c, 
        c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, 
        c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c  
        From CC_Alias__c c where c.Id = :ccId LIMIT 1];
        
        String value='<input type="hidden" name="request" value="<?xml version=&quot;1.0&quot; encoding=&quot;utf-16&quot;?>';
        value += '<Request_v1 xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot;>';
        value += '<Application><ApplicationID>ROUNSALE2011000CRMTAAF8USEN</ApplicationID><LanguageID>EN</LanguageID></Application>';
        value += '<VaultOperation><Merchant><MerchantID>'+ this.strMerchantId +'</MerchantID><MerchantKey>'+ this.strMerchantKey +'</MerchantKey></Merchant><VaultStorage><Service>CREATE</Service></VaultStorage><VaultID>' + strVaultId2 +'</VaultID></VaultOperation></Request_v1>" />';
        System.debug('createguid value:' + value);
        
        return value;      
    }
   public void getEFTResponseInformation(){
    String strObjId = objCCAlias.Id;
    if(strObjId instanceof ID){
        system.debug('######### objPledges.CC_EFT_Alias__c (line 409) : ' + objPledges.CC_EFT_Alias__c);
        this.objPledges.CC_EFT_Alias__c = strObjId;
        system.debug('######### objPledges.CC_EFT_Alias__c (line 411) : ' + objPledges.CC_EFT_Alias__c);
        System.debug('######this.objPledges.Id:'+ this.objPledges.Id + '   ############# this.objPledges.CC_EFT_Alias__c: '+ this.objPledges.CC_EFT_Alias__c);
        Opportunity objCurrPledge = [Select CC_EFT_Alias__c, Id from Opportunity where Id = :objPledges.Id];
        objCurrPledge.CC_EFT_Alias__c = strObjId;
        update objCurrPledge;
        System.debug('#########objCurrPledge.CC_EFT_Alias__c:'+ objCurrPledge.CC_EFT_Alias__c);
    }
    System.debug('###########strObjId:'+ strObjId);
   }
    public String getVaultId(){
        String strVaultId1 ;
        if (this.objHousehold != null){
            strVaultId1  = this.objHousehold.Id ; 
        }else{
            strVaultId1  = this.objContact.Id;
        }
        strVaultId1 +=  this.objPledges.Id;
        System.debug('vaultid:' + strVaultId1 + '  householdid:' + this.objHousehold.Id + '    contact id:' + this.objContact.Id + '   pledgeid:' + this.objPledges.Id );
        return strVaultId1;
    }    
    public void setDisplayStatus(){
        bDisplayNewCard = true;
        if (objPledges.Charge_Card_Type__c != null){
            bDisplayNewCard = true;
        }
        return;
    }
    public void getVaultResponseInformation(){
       System.debug('PledgeId: ' + this.objPledges.Id + '*********************************** AccountID:'+ this.objPledges.AccountId + '----ccaliasid:'+ this.objCCAlias1.id + '------- ccalias transactionid: ' + this.objCCAlias1.TransactionID__c);
       CC_Alias__c objCCAlias = [Select c.Zipcode__c, c.VANReference__c, c.TransactionID__c, c.SystemModstamp, c.Street2__c, c.Street1__c, c.State__c, c.Sage_Bank_Account_Type__c, c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, c.RecordTypeId, c.Payment_Method__c, c.Payment_ID__c, c.Payment_Description__c, c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Last_Four_Digits__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.City__c, c.Card_Type__c, c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c  From CC_Alias__c c where c.Id = : this.objCCAlias1.id LIMIT 1];
       Opportunity objCurrentPledge; 
       if(objCCAlias != null){
        if(this.objPledges == null){
            objCurrentPledge = [Select o.ta_campaign_value__c, o.ta_campaign__c, o.systemHouseholdContactRoleProcessor__c, o.source__c, o.schedule_start_date__c, o.purpose__c, o.project_del__c, o.program__c, o.pledge_number__c, o.pledge_amount__c, o.payments_in_schedule__c, o.payment_number__c, o.payment_method__c, o.payment_frequency__c, o.payment_amount__c, o.new_install_ment_date__c, o.installment_amount__c, o.gift_type__c, o.gift_kind__c, o.fund__c, o.effort__c, o.caller__c, o.bulk_load__c, o.bequest__c, o.batch_process_count__c, o.batch_number__c, o.alt_transaction_id__c, o.Type, o.Tribute_Type__c, o.Tribute_Name__c, o.Tribute_Flag__c, o.Tribute_Description__c, o.TrackingNumber__c, o.Total__c, o.TotalOpportunityQuantity, o.TA_Account_ID__c, o.SystemModstamp, o.Support_Designation__c, o.Station__c, o.StageName, o.Source_Code__c, o.Solicitation_Type__c, o.Schedule_Type__c, o.SFDC_Opportunity_ID__c, o.SFDC_GIVING_NUMBER__c, o.Revenue_Date__c, o.Restricted__c, o.Response_Mechanism__c, o.Remove_Opportunity__c, o.Reminder_Sent__c, o.Reminder_Sent_Date__c, o.Refused_Reason__c, o.Refund_Type__c, o.Recurring_Donation_Opportunity__c, o.RecordTypeId, o.Product__c, o.Probability, o.Pricebook2Id, o.Payment_Method_Description__c, o.Payment_Date__c, o.Parent_Giving_Stage__c, o.OwnerId, o.Override_Gift_Type__c, o.OrderNumber__c, o.Oppty_Related_Contact__c, o.NextStep, o.New_Balance__c, o.Name, o.Matching_Gift__c, o.Matching_Gift_Status__c, o.Matching_Company__c, o.MainCompetitors__c, o.LeadSource, o.Last_Payment_Date__c, o.Last_Payment_Date_1_Year__c, o.Last_Payment_Date_18_Month__c, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Installments__c, o.Installment_Period__c, o.Id, o.HasOpportunityLineItem, o.Giving_Segment__c, o.Giving_Amount__c, o.Gift_Date_Time__c, o.Gift_Date_6_Month__c, o.Gift_Date_3_Month__c, o.Gift_Date_18_Month__c, o.Fund_Lookup__c, o.Foundation_Pay__c, o.Foundation_Name__c, o.ForecastCategoryName, o.ForecastCategory, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.ExpectedRevenue, o.Description, o.DeliveryInstallationStatus__c, o.CurrentGenerators__c, o.CreatedDate, o.CreatedById, o.Contact_Id_for_Role__c, o.CombinedRollupFieldset__c, o.Closed_Lost_Reasons__c, o.Close_Month__c, o.CloseDate, o.Charge_Card_Type__c, o.Campaign_Type__c, o.Campaign_Name__c, o.CampaignId, o.CC_EFT_Alias__c, o.Benefit_Counts__c, o.Anonymous__c, o.Amount, o.Ack_Sent__c, o.Ack_Sent_Date__c, o.AccountId From Opportunity o where o.Id = :objCCAlias.TransactionID__c];
           this.objPledges = objCurrentPledge;
        }else{
            System.debug('this.objPledges not null => objCurrentPledge = this.objPledges');
           objCurrentPledge = this.objPledges ;
        }
           String strVaultId3 = objCCAlias.Account__c; 
           strVaultId3 += objCCAlias.TransactionID__c;
           objCCAlias.TransactionID__c = getVaultId(); 
           System.debug('objCCAlias.TransactionID__c:'+ objCCAlias.TransactionID__c +'***********************************strVaultId3: ' + strVaultId3);     
           HttpRequest req = new HttpRequest();
           req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
           req.setEndpoint('https://www.sagevault.com/VirtualPaymentTerminal/frmPayment.aspx');
           req.setMethod('POST');
            
           String value = '<?xml version="1.0" encoding="utf-16"?><Request_v1 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
           value += '<Application><ApplicationID>ROUNSALE2011000CRMTAAF8USEN</ApplicationID><LanguageID>EN</LanguageID></Application>';
           value += '<VaultStatusQuery><Merchant><MerchantID>'+ this.strMerchantId +'</MerchantID><MerchantKey>'+ this.strMerchantKey +'</MerchantKey></Merchant><VaultID>'+ objCCAlias.TransactionID__c +'</VaultID></VaultStatusQuery></Request_v1>';
            System.debug('POSTRESPONSE request string:' + value);
           String encodedValue = EncodingUtil.urlEncode(value, 'UTF-8');            
           req.setBody('request='+ encodedValue);
           System.debug(req.getBody());
           Http http = new Http();
           HTTPResponse res = http.send(req);
           Dom.Document doc = res.getBodyDocument();
           //get root element
           Dom.Xmlnode rootNode = doc.getRootElement();
           //traverse the xml
           for(Dom.Xmlnode body : rootNode.getChildElements()){
                 for(Dom.XMLNode child : Body.getChildElements()) {
                    for(Dom.XMLNode subchild : child.getChildElements()) {
                        System.debug('Node Info: '+ subchild.getName()+'---' + subchild.getText());
                        if (subchild.getName() == 'GUID'){
                            objCCAlias.GUID__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'ExpirationDate'){
                            objCCAlias.Expire_Date__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'Last4'){
                            objCCAlias.Last_Four_Digits__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'PaymentDescription'){
                            objCCAlias.Payment_Description__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'PaymentTypeID'){
                            objCCAlias.PaymentTypeID__c = subchild.getText();
                            continue;
                        } 
                        
                    }
                }      
           }
          objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
           update objCCAlias;
           objCurrentPledge.CC_EFT_Alias__c = objCCAlias.Id;
           update objCurrentPledge;
           //hide the popup.
           hideSageHtml();
           //Enable the billing address fields.
           this.bEditBillingAddress = true;
           //Clear the text box of Card Holder Name.
           this.strCardHolderName = '';
       } 
             System.debug('Leaving PostResponse ');     
    }
    //SAGE////////////////////////////////////////////////////////////////////////////  

   /**********EFT PROCESSING***************************************************************/
   public ID newEFTId{get;set;}
   
   public void createNewEFTGuid(){
       if(newEFTId != null) {
            List<CC_Alias__c> lstEFTForGUID = new List<CC_Alias__c>();
            lstEFTForGUID = [Select c.Id,c.GUID__c,c.Bank_Name__c, c.Bank_Account_Type__c, c.Sage_Bank_Account_Type__c,
                 c.Bank_Account_Owner_Name__c, c.Bank_account_number__c,c.Routing_number__c,
                 c.Merchant_Account__r.Merchant_ID__c,c.Merchant_Account__r.Merchant_Key__c,
                 c.Merchant_Account__r.EFT_Merchant_Key__c,c.Merchant_Account__r.EFT_Merchant_ID__c
            from CC_Alias__c c where Payment_Method__c = 'Electronic Funds Transfer' And Id =: newEFTId Limit 1];
            if(lstEFTForGUID.Size()>0) {
                CC_Alias__c objEFTNew = lstEFTForGUID[0];
                
                String M_ID,M_Key,RoutingNum,AccNum,AcctType;
                //M_Key = objEFTNew.Merchant_Account__r.Merchant_Key__c;
                //M_ID = objEFTNew.Merchant_Account__r.Merchant_ID__c;
                M_Key = objEFTNew.Merchant_Account__r.EFT_Merchant_Key__c;
                M_ID = objEFTNew.Merchant_Account__r.EFT_Merchant_ID__c;
                RoutingNum = objEFTNew.Routing_number__c;
                AccNum = objEFTNew.Bank_account_number__c;
                AcctType = objEFTNew.Sage_Bank_Account_Type__c;
                SageTransactionProcess stp = new SageTransactionProcess();
                strEFTGuid = stp.createEFTGuid(M_ID,M_Key,RoutingNum,AccNum,AcctType);
                if(strEFTGuid != null && strEFTGuid !='') {
                    objEFTNew.GUID__c = strEFTGuid;
                    Update objEFTNew;
                }                
            }
           lstExistingEFT = getExistingEFTInfo();
       }
   }
   /*This function is used to create the get parameters while calling the Sage VIRTUAL_CHECK_DATA.*/
    public void CreateNewBankAccount(){

        CC_Alias__c objCCAlias = new CC_Alias__c();
        
        if(NVL(this.strRoutingNo).trim().length()==0 || NVL(this.strBankAccNo).trim().length()==0  
            || NVL(this.strAccType).trim().length()==0){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter/select bank account information.')); 
            return;
            
        }

        if(GivingSaveMe()==true){
            System.debug('Calling save');
            
           String strHouseHoldId = this.objHousehold.Id;
           objCCAlias.Account__c = this.objHousehold.Id;
           objCCAlias.Contact__c = this.objContact.Id;
           //objCCAlias.TransactionID__c = getVaultId();
           objCCAlias.Payment_Method__c = this.objPledges.Payment_Method__c; 
           objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
           
           objCCAlias.Routing_number__c = strRoutingNo;
           objCCAlias.Bank_account_number__c = strBankAccNo;
           objCCAlias.Bank_Account_Type__c = strAccType;
           objCCAlias.Bank_Name__c = strBankName;
           objCCAlias.Bank_Account_Owner_Name__c = strCardHolderName;
           if(objCCAlias.Bank_Account_Type__c == 'Checking') {
               objCCAlias.Sage_Bank_Account_Type__c = 'DDA';
           }else if(objCCAlias.Bank_Account_Type__c == 'Saving') {
               objCCAlias.Sage_Bank_Account_Type__c = 'SAV';
           }else {
               objCCAlias.Sage_Bank_Account_Type__c = objCCAlias.Bank_Account_Type__c;
           }
           RecordType objRecType = [Select id From RecordType where SobjectType ='CC_Alias__c' and DeveloperName = 'EFT_Alias'];
           objCCAlias.RecordtypeId = objRecType.Id;
           //Insert Merchant Account
           Merchant_Accounts__c lMerchID = [Select Id, Merchant_Key__c, Merchant_ID__c from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
           objCCAlias.Merchant_Account__c = lMerchId.Id;
           objCCAlias.GUID__c = null;
          //to get the child pledges use lstChild.
            this.strPledgeId = this.objPledges.Id;
           // System.debug('SoapPost2 householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
            insert objCCAlias;
            newEFTId = objCCAlias.Id;
            system.debug('######### objPledges.CC_EFT_Alias__c (line 593) : ' + objPledges.CC_EFT_Alias__c);
            this.objPledges.CC_EFT_Alias__c = objCCAlias.Id;
            system.debug('######### objPledges.CC_EFT_Alias__c (line 595) : ' + objPledges.CC_EFT_Alias__c);
            this.objCCAlias1 = objCCAlias;
            //this.objCCAlias1 = setObjCCAliasDetails(objCCAlias.Id);
            this.strMerchantId = lMerchID.Merchant_ID__c;
            this.strMerchantKey = lMerchID.Merchant_Key__c;
            System.debug('PledgeId: ' + objPledges.Id+ '***********************************this.objCCAlias1.id: '+this.objCCAlias1.id + '#################'+this.strMerchantId + '#################'+ this.strMerchantKey);

        }
    
        strRoutingNo = null;   
        strBankAccNo = null;   
        strAccType = null;
        strBankName= null;
        strCardHolderName = null;
        
   
        //get the preferred address values.
        strPreferredAddress();
        return;
    }
    static testMethod void testGivingEditEFT(){
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
        
        insert opp;
        
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        SObject o = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
             
        //EditGiving clsTest = new EditGiving(sc);
        GivingEditEFT clsTest = new GivingEditEFT(sc);
        clsTest.GivingSave();
        clsTest.GivingSaveMe();
        clsTest.setContactDetail();
        clsTest.setHouseholdDetail();
        clsTest.RedirectPage('https://cs3.salesforce.com/006/o');
        clsTest.ChoosePaymentMode();
        clsTest.getExistingChargeCard();
        clsTest.NewChargeCode();
        
    }    
}