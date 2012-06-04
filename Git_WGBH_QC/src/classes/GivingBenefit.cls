Public Class GivingBenefit{
    Static Opportunity objPledges;
    Static String mode = '';
    Static Campaign objCPRT;
    Public Static void ApplyBenefit(Opportunity objOpp, WGBH_PB5_UPLOAD__c pb){
        if(objOpp == null) return;
        objPledges = new Opportunity();
        objPledges = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, CampaignId, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c, Account.Preferred_Address__c,
        CC_EFT_Alias__c
        From Opportunity
        Where Id =: objOpp.Id];
        
        
        if(objPledges.CampaignId != null){
            objCPRT = [Select Id, Package_Code__c, Creative_Package__c From Campaign Where Id=:objPledges.CampaignId];
        }
        else{
            return;
        }
        
        LoadExistingProduct();
        getProduct();
        saveBenefit();
        processCCAlias(pb);
        addBenefitsWithFFMiles(pb);
    }
    Static Address__c objPreferredAdd;
    ///////////////////////////////////////////////////
    Static Boolean getContactPreferredAddress(){
        Boolean Flag = false;
        List<Address__c> lstAdd = new List<Address__c>();
        String AddressId;
        if(objPledges != null && NVL(objPledges.Oppty_Related_Contact__c) != ''){
            List<Contact> lstContact = [Select id, Preferred_Address__c From Contact Where Id =: objPledges.Oppty_Related_Contact__c];
            if(lstContact != null && lstContact.size()>0){
                AddressId = NVL(lstContact[0].Preferred_Address__c);
                if(AddressId != ''){
                    lstAdd = [Select Id, Street_1__c, Street_2__c, City__c, Country__c, Postal_Code__c, State__c From Address__c Where Id =: AddressId];
                    if(lstAdd != null && lstAdd.size()>0){
                        objPreferredAdd = new Address__c();
                        objPreferredAdd = lstAdd[0];
                        Flag = true;
                    }
                }
            }
        }
        Return Flag;
    }
    Static Boolean getAccountPreferredAddress(){
        Boolean Flag = false;
        List<Address__c> lstAdd = new List<Address__c>();
        String AddressId;
        if(objPledges != null && NVL(objPledges.AccountId) != ''){
            List<Account> lstAccount = [Select id, Preferred_Address__c From Account Where Id =: objPledges.AccountId];
            if(lstAccount != null && lstAccount.size()>0){
                AddressId = NVL(lstAccount[0].Preferred_Address__c);
                if(AddressId != ''){
                    lstAdd = [Select Id, Street_1__c, Street_2__c, City__c, Country__c, Postal_Code__c, State__c From Address__c Where Id =: AddressId];
                    if(lstAdd != null && lstAdd.size()>0){
                        objPreferredAdd = new Address__c();
                        objPreferredAdd = lstAdd[0];
                        Flag = true;
                    }
                }
            }
        }
        Return Flag;
    }
    ///////////////////////////////////////////////////
    Static String checkChargeCardType(String PaymentMethod){
        PaymentMethod = NVL(PaymentMethod);
        if(PaymentMethod == 'AA') PaymentMethod = 'CyberSource American Express';
        else if(PaymentMethod == 'AV') PaymentMethod = 'Cybersource Visa';
        else if(PaymentMethod == 'AM') PaymentMethod = 'CyberSource Mastercard';
        else if(PaymentMethod == 'AD') PaymentMethod = 'Cybersource Discover';
        else if(PaymentMethod == 'BA') PaymentMethod = 'Sage American Epxress';
        else if(PaymentMethod == 'BD') PaymentMethod = 'Sage Discover';
        else if(PaymentMethod == 'BM') PaymentMethod = 'Sage Mastercard';
        else if(PaymentMethod == 'BV') PaymentMethod = 'Visa';//'Sage Visa';
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
    static Id processCCAlias(WGBH_PB5_UPLOAD__c pb){
        //if(NVL(objPledges.Payment_Method__c) == 'Charge Card'){
        if(NVL(pb.PB5_CHARGE_CARD_ALIAS__C).length()>0){
            CC_Alias__c objCC = new CC_Alias__c();
            objCC.Amount__c = objPledges.Payment_Amount__c;
            objCC.Account__c = objPledges.AccountId;
            if(NVL(objPledges.Oppty_Related_Contact__c).length()>0){
                objCC.Contact__c = objPledges.Oppty_Related_Contact__c;
            }
            //pb.PB5_CALLER__c = '';
            //pb.PB5_CHARGE_CARD_ALIAS_FName__c
            //pb.PB5_CHARGE_CARD_ALIAS_LName__c
            //pb.PB5_CHARGE_CARD_ALIAS_MName__c
            //pb.PB5_CHARGE_CARD_ALIAS_ProfSuffix__c
            //pb.PB5_CHARGE_CARD_ALIAS_Suffix__c
            //pb.PB5_CHARGE_CARD_HOLDER_FNAME__c 
            //pb.PB5_CHARGE_CARD_HOLDER_LNAME__c
            objCC.Card_Holder_Name__c = getCardHolderName(pb);
            objCC.Last_Four_Digits__c = pb.PB5_CHARGE_CARD_MASK__c;
            objCC.Card_Type__c = checkChargeCardType(NVL(pb.PB5_CHARGE_CARD_TYPE__c));        
            objCC.Expire_Date__c = pb.PB5_CHARGE_EXPIRE_CDATE__c;
            objCC.Payment_Method__c = objPledges.Payment_Method__c;
            objCC.GUID__c = pb.PB5_CHARGE_CARD_ALIAS__C;
            /////////////////////////Address
            if(getContactPreferredAddress() == true){
                if(objPreferredAdd != null){
                    objCC.Street1__c = NVL(objPreferredAdd.Street_1__c);
                    objCC.Street2__c = NVL(objPreferredAdd.Street_2__c);
                    objCC.City__c = NVL(objPreferredAdd.City__c);
                    objCC.State__c = NVL(objPreferredAdd.State__c);
                    objCC.Zipcode__c = NVL(objPreferredAdd.Postal_Code__c);
                }
            }
            else if(getAccountPreferredAddress() == true){
                if(objPreferredAdd != null){
                    objCC.Street1__c = NVL(objPreferredAdd.Street_1__c);
                    objCC.Street2__c = NVL(objPreferredAdd.Street_2__c);
                    objCC.City__c = NVL(objPreferredAdd.City__c);
                    objCC.State__c = NVL(objPreferredAdd.State__c);
                    objCC.Zipcode__c = NVL(objPreferredAdd.Postal_Code__c);
                }
            }
            else{
                objCC.Street1__c = getStreet1(pb);
                //objCC.Street2__c = getStreet2(pb);
                objCC.City__c = getCity(pb);
                objCC.State__c = getState(pb);
                objCC.Zipcode__c = getZip(pb);
            }
            /////////////////////////Address
            
            List<Merchant_Accounts__c> lMerchID = [Select Id from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
            if(lMerchID != null && lMerchID.size()>0){
                objCC.Merchant_Account__c = lMerchId[0].Id;
            }
            Insert objCC;
            objPledges.CC_EFT_Alias__c = objCC.Id;
            
            update objPledges;
            if(objPledges.Gift_kind__c != null && (objPledges.Gift_kind__c.toUpperCase() == 'SUSTAINING GIFT' || objPledges.Gift_kind__c.toUpperCase() == 'INSTALLMENT')){
                List<Opportunity> lstChild = [Select id, CC_EFT_Alias__c from Opportunity where Recurring_Donation_Opportunity__c <> null and Recurring_Donation_Opportunity__c =: objPledges.Id];
                if(lstChild != null && lstChild.size()>0){
                    for(Opportunity opp:lstChild){
                        opp.CC_EFT_Alias__c = objPledges.CC_EFT_Alias__c;
                    }
                    Update lstChild;
                }
            }
            
            return objCC.Id;
        }
        else{
            return null;
        }
    }
    static string getStreet1(WGBH_PB5_UPLOAD__c pb){
        String street = '';
        street = NVL(pb.PB5_SHIP_TO_STREET_1__c);
        if(street == ''){
            street = NVL(pb.PB5_STREET_1__c);
        }
        return street;
    }
    /*
    static string getStreet2(WGBH_PB5_UPLOAD__c pb){
        String street = '';
        street = NVL(pb.PB5_SHIP_TO_STREET_2__c);
        return street;
    }
    */
    static string getCity(WGBH_PB5_UPLOAD__c pb){
        String city = '';
        city = NVL(pb.PB5_SHIP_TO_CITY__c);
        if(city == ''){
            city = NVL(pb.PB5_CITY__c);
        }
        return city;
    }
    static string getState(WGBH_PB5_UPLOAD__c pb){
        String state = '';
        state = NVL(pb.PB5_SHIP_TO_STATE__c);
        if(state == ''){
            state = NVL(pb.PB5_STATE__c);
        }
        return state;
    }
    static string getZip(WGBH_PB5_UPLOAD__c pb){
        String zip = '';
        zip = NVL(pb.PB5_SHIP_TO_ZIP_CODE__c);
        if(zip == ''){
            zip = NVL(pb.PB5_ZIP_CODE__c);
        }
        return zip;
    }
    static String getCardHolderName(WGBH_PB5_UPLOAD__c pb){
        String CardHolder = '';
        if(NVL(pb.PB5_CHARGE_CARD_HOLDER_FNAME__c) != ''){
            CardHolder = NVL(pb.PB5_CHARGE_CARD_HOLDER_FNAME__c);
        }
        if(NVL(pb.PB5_CHARGE_CARD_HOLDER_LNAME__c) != ''){
            if(CardHolder == ''){
                CardHolder = NVL(pb.PB5_CHARGE_CARD_HOLDER_FNAME__c);
            }
            else{
                CardHolder += ' ' + NVL(pb.PB5_CHARGE_CARD_HOLDER_FNAME__c);
            }
        }
        if(CardHolder == ''){
            if((NVL(pb.PB5_CHARGE_CARD_ALIAS_FName__c) + NVL(pb.PB5_CHARGE_CARD_ALIAS_LName__c)) != ''){ 
                if(NVL(pb.PB5_CHARGE_CARD_ALIAS_FName__c) != ''){
                    CardHolder = NVL(pb.PB5_CHARGE_CARD_ALIAS_FName__c);
                }
                if(NVL(pb.PB5_CHARGE_CARD_ALIAS_LName__c) != ''){
                    if(CardHolder == ''){
                        CardHolder = NVL(pb.PB5_CHARGE_CARD_ALIAS_LName__c);
                    }
                    else{
                        CardHolder += ' ' + NVL(pb.PB5_CHARGE_CARD_ALIAS_LName__c);
                    }
                }
            }
        }
        Return CardHolder;
    }
    Static String getPricebookId(){
        List<Pricebook2> lstPricebook;
        String pricebookId = null;
        if(objPledges.Station__c != null){
            lstPricebook = [Select Id from Pricebook2 Where name like:objPledges.Station__c];
            if(lstPricebook.size()>0){
                //objPledges.Pricebook2Id = lstPricebook[0].Id;
                pricebookId = lstPricebook[0].Id;
            }
        }
        return pricebookId;
    }
    Static void LoadExistingProduct(){
        try{
            System.debug('######### Load Product Called ########');
            List<OpportunityLineItem> lstLineItem = new List<OpportunityLineItem>();
            lstLineItem = [Select Id, PricebookEntry.ProductCode, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, OpportunityId, PricebookEntryId, Street__c, Shipping_Method__c, Committed_Number__c, IsBenefit__c,
            State__c, Postal_Code__c, Name__c, Package_Name__c, Package_Code__c, Country__c, Quantity, Description, UnitPrice, TotalPrice, City__c, Gift_Membership__c
            From OpportunityLineItem 
            Where OpportunityId =: objPledges.Id and Fulfillment_Status__c != 'Cancelled'];
            //Ketan Benegal-system debug statement
            System.debug('LoadProduct***********************************************PledgeId: '+ objPledges.Id +'AccountId: ' + objPledges.AccountId);
            List<Address__c> lstAddress = new List<Address__c>();
            if(objPledges.AccountId != null){
                lstAddress = [Select Id, City__c, State__c, Street_1__c, Postal_Code__c, 
                Country__c, Name From Address__c Where Account_Household__c =: objPledges.AccountId];
            }
            lstOppProduct = new List<OppProduct>();
            if(lstLineItem != null && lstLineItem.Size()>0){
                for(OpportunityLineItem o:lstLineItem){
                    OppProduct benefit = new OppProduct();
                    benefit.ProductCode = o.PricebookEntry.ProductCode;
                    benefit.ProductName = o.PricebookEntry.Product2.Name;
                    benefit.PricebookEntryId = o.PricebookEntryId;
                    benefit.Product2Id = o.PricebookEntry.Product2Id;
                    benefit.CommittedNo = o.Committed_Number__c;
                    system.debug('############## LineItem Id : ' + o.Id);
                    benefit.LineId = o.Id;
                    benefit.Name = NVL(o.Name__c);
                    benefit.PackageName = NVL(o.Package_Name__c);
                    benefit.PackageCode = NVL(o.Package_Code__c);
                    benefit.Street = NVL(o.Street__c);
                    benefit.City = NVL(o.City__c);
                    benefit.State = NVL(o.State__c);
                    benefit.Zip = NVL(o.Postal_Code__c);
                    benefit.Country = NVL(o.Country__c);
                    benefit.Quantity = Integer.valueOf(o.Quantity);
                    benefit.Description = NVL(o.Description);
                    benefit.UnitPrice = o.UnitPrice;
                    benefit.TotalPrice = o.TotalPrice;
                    benefit.IsBenefit = o.IsBenefit__c;
                    benefit.ShippingMethod = o.Shipping_Method__c;
                    if(o.Gift_Membership__c == null)
                        benefit.GiftMembership = false;
                    else
                        benefit.GiftMembership = o.Gift_Membership__c;
                    if(lstAddress != null && lstAddress.size()>0){
                        for(Address__c add:lstAddress){
                            if((add.Street_1__c != null && add.Street_1__c.trim().toUpperCase() == benefit.Street.trim().toUpperCase()) &&
                               (add.City__c != null && add.City__c.trim().toUpperCase() == benefit.City.trim().toUpperCase()) &&
                               (add.State__c != null && add.State__c.trim().toUpperCase() == benefit.State.trim().toUpperCase()) &&
                               (add.Postal_Code__c != null && add.Postal_Code__c.trim().toUpperCase() == benefit.Zip.trim().toUpperCase()) &&
                               (add.Country__c != null && add.Country__c.trim().toUpperCase() == benefit.Country.trim().toUpperCase())){                               
                               benefit.AddressId = add.Id;
                               benefit.blnOtherAddress = false;                               
                            }                                
                        }
                    }else{
                        benefit.AddressId = 'other';
                        benefit.blnOtherAddress = true;
                    }
                    lstOppProduct.add(benefit);
                }
            }
            if(lstOppProduct.size()>0){
                mode = 'edit';
            }
            else{
                mode = 'new';
            }
        }
        catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug('############# ERROR : ' + ex.getMessage());
        }
    }     

    static void getProduct(){
        system.debug('########### Package Code (Creative_Package__c) : ' + objCPRT.Creative_Package__c);
        system.debug('########### Package Code (Package_Code__c) : ' + objCPRT.Package_Code__c);
        
        List<Member_Benefits_Control__c> lstMem = new List<Member_Benefits_Control__c>();
        
        if(NVL(objCPRT.Creative_Package__c).length()>0){
            lstMem  = [select id, Membership_Benefit_Package__c , Gift_Type__c, Maximum__c, Minimum_Parent_Pledge_Amt__c,
            Membership_Benefit_Package__r.name
            from Member_Benefits_Control__c
            Where Station__c =: objPledges.Station__c
            and Product__c =: objPledges.Product__c
            and Campaign_Type__c =: objPledges.Campaign_Name__c
            and Package__c =: objCPRT.Creative_Package__c];
        }
        
        if(lstMem.size() == 0){
            lstMem  = [select id, Membership_Benefit_Package__c , Gift_Type__c, Maximum__c, Minimum_Parent_Pledge_Amt__c,
            Membership_Benefit_Package__r.name
            from Member_Benefits_Control__c
            Where Station__c =: objPledges.Station__c
            and Product__c =: objPledges.Product__c
            and Campaign_Type__c =: objPledges.Campaign_Name__c
            and Package__c =: objCPRT.Package_Code__c];
        }
        
        
        Set<ID> memIds = new Set<ID>();
        String PackageName = '';
        if(lstMem != null)system.debug('###### total member benefit records ==> ' + lstMem.size());
        for(Member_Benefits_Control__c mbc:lstMem){
            if(mbc.Gift_Type__c!=null) {
                if(mbc.Gift_Type__c.contains(objPledges.Gift_Type__c)) {
                    if(objPledges.Giving_Amount__c <= mbc.Maximum__c && objPledges.Giving_Amount__c >= mbc.Minimum_Parent_Pledge_Amt__c){
                        memIds.add(mbc.Membership_Benefit_Package__c);
                        PackageName = mbc.Membership_Benefit_Package__r.name;
                        system.debug('#### Member Benefit Control ID: ' + mbc.Id);
                        system.debug('#### Membership Benefit Package: ' + mbc.Membership_Benefit_Package__c);                        
                        system.debug('#### Gift Type: ' + mbc.Gift_Type__c);
                    }
                }
            }
        }
        List<PricebookEntry> lstProduct = new List<PricebookEntry>();
        system.debug('####### member benefit package ==> ' + memIds);
        List<Package_Item__c> lstPackageItem = [Select Id,Item__r.ProductCode, Item__r.name, 
        Item__r.Description, Package__r.name, Package__r.Id, Package__c from Package_Item__c 
        Where Package__c IN:memIds];
        
        Set<ID> ProductIds = new Set<ID>();
        Map<ID,String> mapPackage = new Map<ID, String>();
        Map<ID,ID> mapPackageID = new Map<ID,ID>();
        if(lstPackageItem.size()>0){
            for(Package_Item__c p:lstPackageItem){
                ProductIds.add(p.Item__c);
                mapPackage.put(p.Item__c, p.Package__r.name);
                mapPackageID.put(p.Item__c, p.Id);
            }
            if(ProductIds.size()>0){
                system.debug('####### Product Ids : ' + ProductIds);
                system.debug('####### Price book id : ' + getPricebookId());
                lstProduct = [Select UnitPrice, ProductCode, Product2Id, Product2.no_of_items__c, 
                Pricebook2Id, Name, Id, Product2.Description, Product2.Id
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: getPricebookId()
                and Product2Id in: ProductIds];
            }
        }
        if(mode=='new'){
            //lstOppProduct = new List<OppProduct>();
        }else{
            if(lstOppProduct == null)
                lstOppProduct = new List<OppProduct>();
        }
        Account objAcc = new Account();
        List<Address__c> lstAdd = new List<Address__c>();
        lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
        State__c, Country__c from Address__c 
        where account_household__c =: objPledges.accountId and account_household__c!=null];
        
        List<Account> lstPrefAddress = [select preferred_address__c from account where id =: objPledges.accountId];
        String PreferredAddress = '';
        if(lstPrefAddress.size()>0){
            PreferredAddress = lstPrefAddress[0].preferred_address__c;
        }
        List<Contact> lstContact = [Select name from Contact where id =: objPledges.Oppty_Related_Contact__c];
        String strName = '';
        if(lstContact.size()>0){
            strName = lstContact[0].name;        
        }        
        system.debug('#####Total products : ' + lstProduct.size());
        for(PricebookEntry it:lstProduct){
            OppProduct o = new OppProduct();
            o.selected = false;
            if(mapPackage != null && mapPackage.size()>0 && mapPackage.containsKey(it.Product2Id)){
                o.PackageName = mapPackage.get(it.Product2Id);
                o.PackageCode = mapPackageID.get(it.Product2Id);
            }
            //o.PackageName = PackageName;
            //o.PackageCode = it.Product2.Id;
            o.IsBenefit = true;
            o.Product2Id = it.Product2Id;
            o.ProductCode = it.ProductCode;//it.Item__r.ProductCode;
            o.ProductName = it.name;//it.Item__r.Name;
            o.Description = it.Product2.Description;//it.Item__r.Description;
            o.PricebookEntryId = it.id;//it.Item__r.Id;
            o.Quantity = 1;
            o.CommittedNo = it.Product2.no_of_items__c;
            o.UnitPrice = it.UnitPrice;
            o.TotalPrice = o.UnitPrice*o.Quantity;
            o.name = strName;
            o.AddressId = objPledges.Account.Preferred_Address__c;
            if(lstAdd.size()>0){
                for(Address__c a:lstAdd){
                    if(a.id == PreferredAddress){
                        o.Street = a.Street_1__c;
                        o.City = a.City__c;
                        o.State = a.State__c;
                        o.Zip = a.Postal_Code__c;
                        o.Country = a.Country__c;
                        o.AddressId = a.id;
                        o.blnOtherAddress = false;
                    }
                }
            }else{
                o.AddressId = 'other';
                o.blnOtherAddress = true;
            }
            lstOppProduct.add(o);
        }
    }

    static void saveBenefit(){
        List<OpportunityLineItem> lstLineItemInsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstLineItemUpdate = new List<OpportunityLineItem>();
        Set<ID> benefitIds = new Set<ID>();
        Boolean blnBenefitApplied = false;
        try{
            if(lstOppProduct != null && lstOppProduct.size()>0){
                List<OpportunityLineItem> lstLineItem = new List<OpportunityLineItem>();
                for(OppProduct o:lstOppProduct){
                    OpportunityLineItem item = new OpportunityLineItem();
                    if(o.LineId != null){
                        item = [select id from OpportunityLineItem where Id =: o.LineId];
                    }
                    if(mode != 'edit' && o.LineId == null && o.IsBenefit == true){
                        blnBenefitApplied = true;
                    }
                    item.Street__c = o.Street;
                    item.City__c = o.City;
                    item.State__c = o.State;
                    item.Postal_Code__c = o.Zip;
                    item.Country__c = o.Country;
                    item.Quantity = Decimal.valueOf(o.Quantity);
                    item.Description = o.Description;
                    item.UnitPrice = o.UnitPrice;
                    item.Name__c = o.Name;
                    item.Package_Name__c = NVL(o.PackageName);
                    item.Package_Code__c = NVL(o.PackageCode);
                    item.Committed_Number__c = o.CommittedNo;
                    item.IsBenefit__c = o.IsBenefit;
                    if(o.GiftMembership == null)
                    {
                        item.Gift_Membership__c = false;
                    }
                    else{
                        item.Gift_Membership__c = o.GiftMembership;
                    }
                    //item.TotalPrice = o.TotalPrice;
                    item.Shipping_Method__c = o.ShippingMethod;
                    if(o.LineId == null){
                        item.OpportunityId = objPledges.Id;
                        item.PricebookEntryId = o.PricebookEntryId;
                        lstLineItemInsert.add(item);
                    }
                    if(o.LineId != null){
                        lstLineItemUpdate.add(item);
                    }
                    if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                    
                }
                if(lstLineItemInsert.size()>0){
                    system.debug('##### Total Benefits to insert: ' + lstLineItemInsert.size());
                    insert lstLineItemInsert;
                    for(OpportunityLineItem it:lstLineItemInsert){
                        benefitIds.add(it.id);
                    }
                }
                if(lstLineItemUpdate.size()>0){
                    system.debug('##### Total Benefits to update: ' + lstLineItemUpdate.size());
                    update lstLineItemUpdate;
                    for(OpportunityLineItem it:lstLineItemUpdate){
                        benefitIds.add(it.id);
                    }
                }    
           }
                if(mode == 'edit'){
                    List<OpportunityLineItem> lstItem;
                    if(benefitIds != null && benefitIds.size()>0){
                        lstItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode, Gift_Membership__c
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: objPledges.Id And Id not in: benefitIds];
                    }else{
                        lstItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode, Gift_Membership__c
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: objPledges.Id];
                    }
                    Map<String, Decimal> mapCodeWithCommitted = New Map<String, Decimal>();
                    if(mapCodeWithCommitted != null && mapCodeWithCommitted.size() > 0){
                        List<OpportunityLineItem> lstOppNumber = [Select Id, PricebookEntry.ProductCode, Committed_Number__c, Sent_Number__c, Gift_Membership__c From OpportunityLineItem 
                        Where OpportunityId =: objPledges.Id and Fulfillment_Status__c <> 'Superceded' and Fulfillment_Status__c <> 'Cancelled'];
                        if(lstOppNumber != null && lstOppNumber.size()>0){
                            boolean blnUpdate = false;
                            for(OpportunityLineItem item:lstOppNumber){
                                if(mapCodeWithCommitted.containsKey(item.PricebookEntry.ProductCode)){
                                    Decimal committedNumber = decimalNVL(item.Committed_Number__c);
                                    committedNumber += mapCodeWithCommitted.get(item.PricebookEntry.ProductCode);
                                    item.Committed_Number__c = committedNumber;
                                    blnUpdate = true;
                                }
                            }
                            if(blnUpdate) Update lstOppNumber;
                        }
                    }
                }
                /////////////////////////////////////////////////////////////
                List<Opportunity> lstPreviousGiving = new List<Opportunity>();
                Id PrevGivingId = null;
                String PrevStage = null;
                lstPreviousGiving = [Select Id, StageName From Opportunity 
                Where AccountId =: objPledges.AccountId and id <>:objPledges.Id and
                Station__c =: objPledges.Station__c and Campaign_Name__c =: objPledges.Campaign_Name__c
                Order by createddate desc ];
                
                if(lstPreviousGiving != null && lstPreviousGiving.size()>0){
                    Map<String, Decimal> mapCodeWithCommitted = New Map<String, Decimal>();
                    PrevGivingId = lstPreviousGiving[0].Id;
                    PrevStage = lstPreviousGiving[0].StageName;
                    List<OpportunityLineItem> lstPrevItem;
                    lstPrevItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode, Gift_Membership__c
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: PrevGivingId and Fulfillment_Status__c != 'Cancelled'];
                            
                    
                    if(PrevStage != null && PrevStage.trim().toUpperCase() == 'PLEDGED' && blnBenefitApplied == true ){
                        if(lstPrevItem != null && lstPrevItem.size()>0){
                            system.debug('##### Total Benefits to Delete: ' + lstPrevItem.size());
                            for(OpportunityLineItem it:lstPrevItem){
                                it.Fulfillment_Status__c = 'Cancelled';
                            }
                            //delete lstPrevItem;
                            update lstPrevItem;
                        }                    
                    }
                    
                    if(PrevStage != null && PrevStage.trim().toUpperCase() != 'PLEDGED' && blnBenefitApplied == true){
                        if(lstPrevItem != null && lstPrevItem.size()>0){
                            for(OpportunityLineItem it:lstPrevItem){
                                if(it.PricebookEntry.ProductCode != null &&
                                    (it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMBEN') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMCARD') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMGUIDE'))){
                                    
                                    it.Fulfillment_Status__c = 'Superceded';
                                    Decimal PendingCommitted = 0;
                                    PendingCommitted = decimalNVL(it.Committed_Number__c) - decimalNVL(it.Sent_Number__c);
                                    mapCodeWithCommitted.put(it.PricebookEntry.ProductCode, PendingCommitted);
                                }
                                else{
                                    it.Fulfillment_Status__c = 'Cancelled';
                                }
                            }
                            system.debug('##### Total Benefits to Cancel: ' + lstPrevItem.size());
                            update lstPrevItem;
                        }
                    }
                    if(mode != 'edit' && mapCodeWithCommitted != null && mapCodeWithCommitted.size() > 0){
                        List<OpportunityLineItem> lstOppNumber = [Select Id, PricebookEntry.ProductCode, Committed_Number__c, Sent_Number__c, Gift_Membership__c From OpportunityLineItem 
                        Where OpportunityId =: objPledges.Id and Fulfillment_Status__c <> 'Superceded' and Fulfillment_Status__c <> 'Cancelled'];
                        if(lstOppNumber != null && lstOppNumber.size()>0){
                            boolean blnUpdate = false;
                            for(OpportunityLineItem item:lstOppNumber){
                                if(mapCodeWithCommitted.containsKey(item.PricebookEntry.ProductCode)){
                                    Decimal committedNumber = decimalNVL(item.Committed_Number__c);
                                    committedNumber += mapCodeWithCommitted.get(item.PricebookEntry.ProductCode);
                                    item.Committed_Number__c = committedNumber;
                                    blnUpdate = true;
                                }
                            }
                            if(blnUpdate) Update lstOppNumber;
                        }
                    }
                }
            
        }Catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    
    }        

    Static List<OppProduct> lstOppProduct;
    Public Class OppProduct{
        Public boolean selected{get;set;}
        Public String PackageName{get;set;}
        Public String PackageId{get;set;}
        Public String LineId{get;set;}
        Public String ProductCode{get;set;}
        Public String ProductName{get;set;}
        Public String Description{get;set;}
        //Public Decimal Quantity{get;set;}
        Public Integer Quantity{get;set;}
        Public String Name{get;set;}
        Public String Street{get;set;}
        Public String City{get;set;}
        Public String State{get;set;}
        Public String Zip{get;set;}
        Public String Country{get;set;}
        Public String ShippingMethod{get;set;}
        Public String PricebookEntryId{get;set;}
        Public Double UnitPrice{get;set;}
        Public Double TotalPrice{get;set;}
        Public String AddressId{get;set;}
        Public String Product2Id{get;set;}
        Public Boolean blnOtherAddress{get;set;}
        Public Decimal CommittedNo{get;set;}
        Public Boolean IsBenefit{get;set;}
        Public Boolean GiftMembership{get;set;}
        Public String PackageCode{get;set;}
    }    

    Static String NVL(String str){
        if(str == null)
            return '';
        else
            return str.trim();
    }
    
    Static Decimal decimalNVL(decimal val){
        if(val == null)
            return 0;
        else
            return val;
    }    
    Static void addBenefitsWithFFMiles(WGBH_PB5_UPLOAD__c PB5){
        
        sObject sPB5 = (sObject) PB5;
        for(Integer i=1;i<=10;i++){
            Set<String> setBenefitCode = new Set<String>();
            String code = '';
            code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
            if(code != ''){
                setBenefitCode.add(code);
                saveBenefitsWithFFMiles(PB5, setBenefitCode);
            }
        }
        
    }
    Static void saveBenefitsWithFFMiles(WGBH_PB5_UPLOAD__c PB5, Set<String> setBenefitCode){
        
    
        Set<ID> packageIds = new Set<ID>();
        Map<ID, String> mapPackageName = new Map<ID, String>();
        Map<ID, ID> mapPackageID = new Map<ID, ID>();
        
        List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
        Decimal Amount = objPledges.Giving_Amount__c;

        List<Contact> lstContact = [Select name from Contact where id =: objPledges.Oppty_Related_Contact__c];
        String strName = '';
        if(lstContact.size()>0){
            strName = lstContact[0].name;        
        }
        List<Pricebook2> lstPricebook = [Select Id, name from Pricebook2 Where name =:objPledges.Station__c];
        //PricebookEntry 
        if((setBenefitCode != null && setBenefitCode.size()>0) && (lstPricebook != null && lstPricebook.size()>0)){
            system.debug('######### benefits : ' + setBenefitCode);
            system.debug('#########Pricebook Entry ID : ' + lstPricebook[0].Id);
            Set<ID> setPriceBookIds = new Set<ID>();
            List<PricebookEntry> lstProduct = [Select UnitPrice, ProductCode, Product2Id, 
                Product2.no_of_items__c, Product2.Id,
                Pricebook2Id, Name, Id, Product2.Description,
                Product2.RecordType.DeveloperName 
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: lstPricebook[0].Id
                and ProductCode in: setBenefitCode];   

            system.debug('######### Product found : ' + lstProduct);
            if(lstProduct != null && lstProduct.size()>0){
                integer j=1;
                for(PricebookEntry prod:lstProduct){
                    OpportunityLineItem item = new OpportunityLineItem();    
                    item.Quantity = 1;
                    item.Description = Prod.Product2.Description;
                    item.UnitPrice = prod.UnitPrice;
                    item.Name__c = strName;
                    item.Committed_Number__c = prod.Product2.no_of_items__c;
                    item.IsBenefit__c = true;
                    //item.TotalPrice = o.TotalPrice;
                    item.OpportunityId = objPledges.Id;
                    item.PricebookEntryId = prod.Id;                            
                    if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                    //item.Street__c = NVL(PB5.PB5_PaymentBillingStreet1__c);
                    system.debug('############# PB5.PB5_SHIP_TO_STREET_1__c : ' + PB5.PB5_SHIP_TO_STREET_1__c);
                    system.debug('############# PB5.PB5_SHIP_TO_EXTRA_LINE_1__c : ' + PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                    item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_STREET_1__c);
                    item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                    system.debug('############# item.Street__c : ' + item.Street__c);
                    item.City__c = NVL(PB5.PB5_SHIP_TO_CITY__c);
                    item.State__c = NVL(PB5.PB5_SHIP_TO_STATE__c);
                    item.Postal_Code__c = NVL(PB5.PB5_SHIP_TO_ZIP_CODE__c);
                    //item.Country__c = NVL(PB5.PB5_PaymentBillingCountry__c);
                    //////////////////////////////////////////
                    if(NVL(prod.Product2.RecordType.DeveloperName) == 'Package'){
                        packageIds.add(prod.Product2.Id);
                    }
                    else{
                        lstLineItems.add(item);
                    }
                    
                }
                

                /////////////////////////////
                if(packageIds != null && packageIds.size()>0){
                    List<PriceBookEntry> lstItem = [ select id,  Product2ID,Name, ProductCode, Product2.Description, 
                    Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                    from PricebookEntry where Pricebook2Id =: lstPricebook[0].Id and IsActive = true 
                    and Product2ID in(Select Item__c from Package_Item__c Where Package__c In:packageIds)
                    order by Name limit 100];
                    
                    List<Package_Item__c> lstPackageName = [Select Package__r.Name, Item__c from Package_Item__c Where Package__c in:packageIds];
                    if(lstPackageName != null && lstPackageName.size()>0){
                        for(Package_Item__c p:lstPackageName){
                            mapPackageName.put(p.Item__c, p.Package__r.Name);
                            mapPackageID.put(p.Item__c, p.Id);
                        }
                    }
                    if(lstItem != null && lstItem.size()>0){
                        for(PricebookEntry prod:lstItem){
                            OpportunityLineItem item = new OpportunityLineItem();    
                            item.Quantity = 1;
                            item.Description = Prod.Product2.Description;
                            item.UnitPrice = prod.UnitPrice;
                            item.Name__c = strName;
                            item.Committed_Number__c = prod.Product2.no_of_items__c;
                            item.IsBenefit__c = true;
                            //item.TotalPrice = o.TotalPrice;
                            item.OpportunityId = objPledges.Id;
                            item.PricebookEntryId = prod.Id;                            
                            if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                                item.Fulfillment_Status__c = 'Ready to Process';
                            else
                                item.Fulfillment_Status__c = 'Pending';
                            system.debug('############# PB5.PB5_SHIP_TO_STREET_1__c : ' + PB5.PB5_SHIP_TO_STREET_1__c);
                            system.debug('############# PB5.PB5_SHIP_TO_EXTRA_LINE_1__c : ' + PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                            item.Street__c = NVL(PB5.PB5_SHIP_TO_STREET_1__c);
                            item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                            system.debug('############# item.Street__c : ' + item.Street__c);
                            //item.Street__c += ' ' + NVL(PB5.PB5_PaymentBillingStreet3__c);
                            item.City__c = NVL(PB5.PB5_SHIP_TO_CITY__c);
                            item.State__c = NVL(PB5.PB5_SHIP_TO_STATE__c);
                            item.Postal_Code__c = NVL(PB5.PB5_SHIP_TO_ZIP_CODE__c);
                            //item.Country__c = NVL(PB5.PB5_PaymentBillingCountry__c);
                            if(mapPackageName != null && mapPackageName.size()>0 && mapPackageName.containsKey(prod.Product2.Id)){
                                item.Package_Name__c = mapPackageName.get(prod.Product2.Id);
                                item.Package_Code__c = mapPackageID.get(prod.Product2.Id);
                            }
                            lstLineItems.add(item);
                        }
                    }
                }
                /////////////////////////////                
                
            }
            
            if(lstLineItems != null && lstLineItems.size()>0){
                system.debug('###### total line items to add ' + lstLineItems.size());
                insert lstLineItems;
            }        
        }        
    }    
    /*
    Static void addBenefitsWithFFMiles(WGBH_PB5_UPLOAD__c PB5){
        Set<String> setBenefitCode = new Set<String>();
    
        Set<ID> packageIds = new Set<ID>();
        Map<ID, String> mapPackageName = new Map<ID, String>();
        Map<ID, ID> mapPackageID = new Map<ID, ID>();
        
        List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
        sObject sPB5 = (sObject) PB5;
        for(Integer i=1;i<=10;i++){
            String code = '';
            code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
            if(code != ''){
                setBenefitCode.add(code);
            }
        }
        Decimal Amount = objPledges.Giving_Amount__c;

        List<Pricebook2> lstPricebook = [Select Id, name from Pricebook2 Where name =:objPledges.Station__c];
        //PricebookEntry 
        if((setBenefitCode != null && setBenefitCode.size()>0) && (lstPricebook != null && lstPricebook.size()>0)){
            system.debug('######### benefits : ' + setBenefitCode);
            system.debug('#########Pricebook Entry ID : ' + lstPricebook[0].Id);
            Set<ID> setPriceBookIds = new Set<ID>();
            List<PricebookEntry> lstProduct = [Select UnitPrice, ProductCode, Product2Id, 
                Product2.no_of_items__c, Product2.Id,
                Pricebook2Id, Name, Id, Product2.Description,
                Product2.RecordType.DeveloperName 
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: lstPricebook[0].Id
                and ProductCode in: setBenefitCode];   

            system.debug('######### Product found : ' + lstProduct);
            if(lstProduct != null && lstProduct.size()>0){
                integer j=1;
                for(PricebookEntry prod:lstProduct){
                    OpportunityLineItem item = new OpportunityLineItem();    
                    item.Quantity = 1;
                    item.Description = Prod.Product2.Description;
                    item.UnitPrice = prod.UnitPrice;
                    item.Name__c = prod.Name;
                    item.Committed_Number__c = prod.Product2.no_of_items__c;
                    item.IsBenefit__c = true;
                    //item.TotalPrice = o.TotalPrice;
                    item.OpportunityId = objPledges.Id;
                    item.PricebookEntryId = prod.Id;                            
                    if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                    //item.Street__c = NVL(PB5.PB5_PaymentBillingStreet1__c);
                    item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_STREET_1__c);
                    item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                    item.City__c = NVL(PB5.PB5_SHIP_TO_CITY__c);
                    item.State__c = NVL(PB5.PB5_SHIP_TO_STATE__c);
                    item.Postal_Code__c = NVL(PB5.PB5_SHIP_TO_ZIP_CODE__c);
                    //item.Country__c = NVL(PB5.PB5_PaymentBillingCountry__c);
                    //////////////////////////////////////////
                    if(NVL(prod.Product2.RecordType.DeveloperName) == 'Package'){
                        packageIds.add(prod.Product2.Id);
                    }
                    else{
                        lstLineItems.add(item);
                    }
                    
                }
                

                /////////////////////////////
                if(packageIds != null && packageIds.size()>0){
                    List<PriceBookEntry> lstItem = [ select id,  Product2ID,Name, ProductCode, Product2.Description, 
                    Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                    from PricebookEntry where Pricebook2Id =: lstPricebook[0].Id and IsActive = true 
                    and Product2ID in(Select Item__c from Package_Item__c Where Package__c In:packageIds)
                    order by Name limit 100];
                    
                    List<Package_Item__c> lstPackageName = [Select Package__r.Name, Item__c from Package_Item__c Where Package__c in:packageIds];
                    if(lstPackageName != null && lstPackageName.size()>0){
                        for(Package_Item__c p:lstPackageName){
                            mapPackageName.put(p.Item__c, p.Package__r.Name);
                            mapPackageID.put(p.Item__c, p.Id);
                        }
                    }
                    if(lstItem != null && lstItem.size()>0){
                        for(PricebookEntry prod:lstItem){
                            OpportunityLineItem item = new OpportunityLineItem();    
                            item.Quantity = 1;
                            item.Description = Prod.Product2.Description;
                            item.UnitPrice = prod.UnitPrice;
                            item.Name__c = prod.Name;
                            item.Committed_Number__c = prod.Product2.no_of_items__c;
                            item.IsBenefit__c = true;
                            //item.TotalPrice = o.TotalPrice;
                            item.OpportunityId = objPledges.Id;
                            item.PricebookEntryId = prod.Id;                            
                            if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                                item.Fulfillment_Status__c = 'Ready to Process';
                            else
                                item.Fulfillment_Status__c = 'Pending';
                            item.Street__c = NVL(PB5.PB5_SHIP_TO_STREET_1__c);
                            item.Street__c += ' ' + NVL(PB5.PB5_SHIP_TO_EXTRA_LINE_1__c);
                            //item.Street__c += ' ' + NVL(PB5.PB5_PaymentBillingStreet3__c);
                            item.City__c = NVL(PB5.PB5_SHIP_TO_CITY__c);
                            item.State__c = NVL(PB5.PB5_SHIP_TO_STATE__c);
                            item.Postal_Code__c = NVL(PB5.PB5_SHIP_TO_ZIP_CODE__c);
                            //item.Country__c = NVL(PB5.PB5_PaymentBillingCountry__c);
                            if(mapPackageName != null && mapPackageName.size()>0 && mapPackageName.containsKey(prod.Product2.Id)){
                                item.Package_Name__c = mapPackageName.get(prod.Product2.Id);
                                item.Package_Code__c = mapPackageID.get(prod.Product2.Id);
                            }
                            lstLineItems.add(item);
                        }
                    }
                }
                /////////////////////////////                
                
            }
            
            if(lstLineItems != null && lstLineItems.size()>0){
                system.debug('###### total line items to add ' + lstLineItems.size());
                insert lstLineItems;
            }        
        }        
    }   
    */ 
}