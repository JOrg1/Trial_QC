Public class SageTransactionProcess {

    Public String strStatus =''; // Set Response status Value
    Public String Response_message =''; // Set Response Message
    Public String Response_Code ='';    // Set Response Error Code if any.
    Public String SageResponse ='';    // Set Sage XML Response.
    Public String REFERENCE ='';    // Set Response REFERENCE Code  if any.
    Public String ORDER_NUMBER = ''; //Set Response ORDER_NUMBER if any.
    Public Boolean isTimeoutError; //Set Timeout Error message if occur.
    Public String ReqURL; //Set Timeout Error message if occur.
    
    Private Static Integer intTimeOut = 30000;
    
    Public Static String Expired_isSUCCESS;

    Public SageTransactionProcess(){        
        this.strStatus ='';
        this.Response_message ='';
        this.Response_Code = '';        
        
        this.SageResponse ='';
        this.REFERENCE ='';
        this.ORDER_NUMBER = '';
        String sysTimeDelay = System.Label.SageTimeoutDelay;
        if(sysTimeDelay != null && sysTimeDelay.length()>0) {
            if(Integer.ValueOf(sysTimeDelay)>0 )
                intTimeOut = Integer.ValueOf(sysTimeDelay) * 1000;
        }
    }

    Public Boolean SagePaymentRequest(String M_ID,String M_KEY,String C_NAME,String C_ADDRESS,String C_CITY,String C_STATE,
                String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_CUSTOMER_NUMBER,String T_AMT,String T_SHIPPING,
                String T_TAX,String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,
                String C_SHIP_CITY,String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VAULT_BANKCARD_SALE?';
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_NAME=' + EncodeValue(C_NAME);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        myurl += '&T_CUSTOMER_NUMBER='+ EncodeValue(T_CUSTOMER_NUMBER);
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);
        
        this.isTimeoutError = false;
        this.ReqURL = myurl;
        String ResXML='';
        ResXML = HTTPSageRequest(myurl);

        Success = false;
         if(this.isTimeoutError == false) {
            this.strStatus ='';
            this.Response_message ='';
            this.Response_Code = '';
            
            this.SageResponse ='';
            this.REFERENCE ='';
            this.ORDER_NUMBER = '';
            Success = CheckTransactionResponse(ResXML);
        } else {
            this.SageResponse = ResXML;
        }

        return Success;
    }

    Public Boolean SageRefundRequest(String M_ID,String M_KEY,String C_NAME,String C_ADDRESS,String C_CITY,String C_STATE,
                String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_CUSTOMER_NUMBER,String T_AMT,String T_SHIPPING,
                String T_TAX,String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,
                String C_SHIP_CITY,String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VAULT_BANKCARD_CREDIT?';                    
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_NAME=' + EncodeValue(C_NAME);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        myurl += '&T_CUSTOMER_NUMBER='+ EncodeValue(T_CUSTOMER_NUMBER);
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);
        
        this.isTimeoutError = false;
        this.ReqURL = myurl;
        
        String ResXML='';
        ResXML = HTTPSageRequest(myurl);
        
        Success = false;
        if(this.isTimeoutError == false) {
            this.strStatus ='';
            this.Response_message ='';
            this.Response_Code = '';
            
            this.SageResponse ='';
            this.REFERENCE ='';
            this.ORDER_NUMBER = '';
            Success = CheckTransactionResponse(ResXML);
        } else {
            this.SageResponse = ResXML;
        }
        
        return Success;
    }

    Private String HTTPSageRequest(String URL)
    {    
        try {
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(URL);
            req.setMethod('GET');
            req.setTimeOut(intTimeOut);
            //HttpResponse res = h.send(req);
            HttpResponse res = new HttpResponse();
            
            try {
                res = h.send(req);
            }catch(System.CalloutException e) {
                this.isTimeoutError = true;
                return e.getMessage();
            }
            
            return res.getBody();        
       }Catch(Exception Ex) {
           return '';
       }
    }

    Private Boolean CheckTransactionResponse(String strXMLResponse)
    {
         System.Debug('@@@SageResponse:' + strXMLResponse);
         this.SageResponse = strXMLResponse;
         Boolean blnRetValue = false;
         If(strXMLResponse == null || strXMLResponse.Length() == 0) {
             return false;
         }
         else if(strXMLResponse.contains('diffgr') == false)
         {
             Response_message = strXMLResponse;
             return false;
         }
         else {
             try {

                 XMLDom dom = new XMLDom(strXMLResponse);
                 XMLDom.Element xmlObj ;
                 


                 if(dom.getElementByTagName('diffgr:diffgram') != null) {
                    xmlObj = dom.getElementByTagName('diffgr:diffgram');
                    if (xmlObj.getElementsByTagName('APPROVAL_INDICATOR').size()>0) {
                        
                        strStatus = xmlObj.getElementsByTagName('APPROVAL_INDICATOR')[0].nodeValue;
                        Response_message = xmlObj.getElementsByTagName('MESSAGE')[0].nodeValue;
                        Response_Code = xmlObj.getElementsByTagName('CODE')[0].nodeValue;
                        try {
                            this.REFERENCE = xmlObj.getElementsByTagName('REFERENCE')[0].nodeValue;
                            this.ORDER_NUMBER = xmlObj.getElementsByTagName('ORDER_NUMBER')[0].nodeValue;
                        }catch(Exception ex) {}
                        
                        system.debug('###Status:' + strStatus + ' -Message:' + Response_message);
                        if(strStatus != null && strStatus.Length()>0 )
                        {
                            blnRetValue = true;
                        }
                    }
                }
                else {
                    Response_message = strXMLResponse;
                    blnRetValue = false;
                }
             }catch(Exception ex){
                 Response_Code = '';
                 Response_message = 'Response Reading Error';
             }
         }
         return blnRetValue;
    }

    Private String BlankIsNull(String Value)
    {
        if(Value == null) 
            return '';
        else
            return Value; 
    }

    Public Static String EncodeValue(String Value)
    {
        IF(Value != null && Value.Length()>0) {
            return EncodingUtil.urlEncode(Value,'UTF-8');
        }
        else {
            return '';
        }
    }
    
    //VIRTUAL_CHECK_PPD_SALE for EFT
    Public Boolean SageVirtualCheckPaymentRequest(String M_ID,String M_KEY,String C_ORIGINATOR_ID,String C_FIRST_NAME,
            String C_MIDDLE_INITIAL,String C_LAST_NAME,String C_SUFFIX,String C_ADDRESS,String C_CITY,String C_STATE,
            String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_AMT,String T_SHIPPING,String T_TAX,
            String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,String C_SHIP_CITY,
            String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        //myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VIRTUAL_CHECK_PPD_SALE?'; 
        //myurl = 'https://www.sagepayments.net/web_services/vterm_extensions/transaction_processing.asmx/VIRTUAL_CHECK_PPD_SALE?';
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultvirtualcheck.asmx/VIRTUAL_CHECK_PPD_SALE?';
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_ORIGINATOR_ID=' + EncodeValue(C_ORIGINATOR_ID);
        myurl += '&C_FIRST_NAME=' + EncodeValue(C_FIRST_NAME);
        myurl += '&C_MIDDLE_INITIAL=' + EncodeValue(C_MIDDLE_INITIAL);
        myurl += '&C_LAST_NAME=' + EncodeValue(C_LAST_NAME);
        myurl += '&C_SUFFIX=' + EncodeValue(C_SUFFIX);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        /*myurl += '&C_RTE=' + EncodeValue(null);
        myurl += '&C_ACCT=' + EncodeValue(null);
        myurl += '&C_ACCT_TYPE=' + EncodeValue(null);*/
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);

        this.isTimeoutError = false;
        this.ReqURL = myurl;
        
        String ResXML='';
        ResXML = HTTPSageRequest(myurl);

        Success = false;
        if(this.isTimeoutError == false) {
            this.strStatus ='';
            this.Response_message ='';
            this.Response_Code = '';
            
            this.SageResponse ='';
            this.REFERENCE ='';
            this.ORDER_NUMBER = '';
            Success = CheckTransactionResponse(ResXML);
        } else {
            this.SageResponse = ResXML;
        }
        return Success;
    }

    //@Future (Callout=true)
    Public Static void UpdateExpireDateAndRePayment(ID TransId) {
        
        List<TRANSACTION_BATCH__c> lstobjTran = New List<TRANSACTION_BATCH__c>([SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Giving_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c 
             , ORDER_NUMBER__c , Sage_Response__c , REFERENCE__c , isCCDateExpired__c,UpdateCCDate__c,needToRePaymentReq__c FROM transaction_batch__c WHERE Id=:TransId]);
        
        If(lstobjTran.Size() >0) {
            TRANSACTION_BATCH__c objTran = lstobjTran[0];
            List<CC_Alias__c> lstobjccAlias = NEw List<CC_Alias__c>([Select id,GUID__c,Expire_Date__c from CC_Alias__c Where GUID__c=: objTran.GUID__c]);
            
            If(lstobjccAlias != null) {
                CC_Alias__c objccAlias = lstobjccAlias[0];
                /*String expiredDate = objccAlias.Expire_Date__c;
                String NewexpiredDate;
                if(expiredDate != null && expiredDate.length()>2) {
                    Integer yy = 2000+ integer.valueof(expiredDate.substring(expiredDate.length()-2, expiredDate.length()));
                    Integer mm = integer.valueof(expiredDate.substring(0, expiredDate.length()-2));
               
                    Date expdate = Date.newInstance(yy,mm,1);          
                    expdate = expdate.addmonths(1);
                    String newMM = '0' + String.valueof(expdate.Month());                    
                    newMM =  newMM.substring(newMM.length()-2,newMM.length());
                    String newYY = String.valueof(expdate.Year());
                    newYY = newYY.substring(newYY.length()-2,newYY.length());
                    NewexpiredDate =  newMM + newYY; */
                    
                String NewexpiredDate;
                Date expdate = System.today();
                expdate = expdate.addmonths(1);
                String newMM = String.ValueOf(expdate.month());
                if(newMM .length() == 1) newMM = '0' + newmm;
                String newYY =  String.ValueOf(expdate.Year());
                newYY = newYY.substring(newYY.length()-2,newYY.length());                
                NewexpiredDate = newMM + newYY;
                
                Boolean Success;
                Success = SageUPDATE_CREDIT_CARD_EXPIRATION_DATERequest(objTran.Merchant_Id__c,objTran.Merchant_Key__c,objTran.GUID__c,NewexpiredDate);
                if(Success == true && Expired_isSUCCESS == 'true') {
                    objccAlias.Expire_Date__c = NewexpiredDate;
                    Update objccAlias;

                    objTran.needToRePaymentReq__c = true;
                    //Update objTran;                       
                }
               /* } */
            }
            objTran.UpdateCCDate__c = true;
            Update objTran;
        }
    }
    
   Public Static Boolean SageUPDATE_CREDIT_CARD_EXPIRATION_DATERequest(String M_ID,String M_KEY,String GUID,String ExpiredDate) {

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVault.asmx/UPDATE_CREDIT_CARD_EXPIRATION_DATE?';
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);       
        myurl += '&GUID=' + EncodeValue(GUID);     
        myurl += '&EXPIRATION_DATE=' + ExpiredDate;

        String ResXML='';
        ResXML = HTTPSageRequestForExpiredDate(myurl);
        
        return  CheckUpdateExpireDateResponse(ResXML);
    }
    public Static Boolean CheckUpdateExpireDateResponse(String strXMLResponse)
    {
         Expired_isSUCCESS = '';        
         Boolean blnRetValue = false;
         If(strXMLResponse == null || strXMLResponse.Length() == 0) {
             return false;
         }
         else if(strXMLResponse.contains('diffgr') == false)
         {
             return false;
         }
         else {
             try {
                 XMLDom dom = new XMLDom(strXMLResponse);
                 XMLDom.Element xmlObj ;
  
                 if(dom.getElementByTagName('diffgr:diffgram') != null) {
                    xmlObj = dom.getElementByTagName('diffgr:diffgram');
                    if (xmlObj.getElementsByTagName('SUCCESS').size()>0) {                        
                        Expired_isSUCCESS = xmlObj.getElementsByTagName('SUCCESS')[0].nodeValue;
                        Return true;
                    }
                }                
             }catch(Exception ex){
             }
         }
         return false;
    }
    
    Public static String HTTPSageRequestForExpiredDate(String URL)
    {    
        try {
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(URL);
            req.setMethod('GET');
            req.setTimeOut(intTimeOut);
           
            HttpResponse res = new HttpResponse();
            
            try {
                res = h.send(req);
            }catch(System.CalloutException e) {                
                return e.getMessage();
            }
            
            return res.getBody();        
       }Catch(Exception Ex) {
           return '';
       }
    }

/***Ketan A Benegal-EFT Processing - Code Start*****************************************/
    //public String createEFTGuid(String strRoutingNum, String strAccNum, String strAcctType, String strStation){
    public String createEFTGuid(String M_ID, String M_Key,String strRoutingNum, String strAccNum, String strAcctType){
   
        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVault.asmx/INSERT_VIRTUAL_CHECK_DATA?';                    
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&ROUTING_NUMBER=' + EncodeValue(strRoutingNum);
        myurl += '&ACCOUNT_NUMBER=' + EncodeValue(strAccNum);
        myurl += '&C_ACCT_TYPE=' + EncodeValue(strAcctType);

        /*myurl += 'M_ID=' + EncodeValue('858687144948');
        myurl += '&M_KEY=' + EncodeValue('Q7P7Y6G7N7J6');
        myurl += '&ROUTING_NUMBER=' + EncodeValue('056008849');
        myurl += '&ACCOUNT_NUMBER=' + EncodeValue('12345678901234');
        myurl += '&C_ACCT_TYPE=' + EncodeValue('DDA');
        */
        
        System.debug('request URL:'+ myurl);
        String ResXML='';
        try {            
            ResXML = HTTPSageRequest(myurl);
            system.debug('@@@@@@@@EFTResponce=' + ResXML);
            String GUID;
            GUID = checkCreateGuidResponse(ResXML);
            system.debug('@@@@@@@@EFTGUID=' + GUID);
            Return GUID;
       }Catch(Exception Ex) {
           return '';
       }
    }
    
    
    public String processEFTPayment(Id objId){
        CC_Alias__c lstNewEFT = [SELECT AVSResult__c, Account__c, Amount__c, AuthCode__c, Bank_Account_Owner_Name__c, Bank_Account_Type__c, Bank_Name__c, Name, CVVResult__c, Card_Holder_Name__c, Card_Type__c, Contact__c, Contact__r.FirstName, Contact__r.middle_name__c, Contact__r.LastName, CreatedById, CreatedDate, IsDeleted, Do_Not_Use__c, Expire_Date__c, GUID__c, Last_Four_Digits__c, LastModifiedById, LastModifiedDate, Merchant_Account__r.Merchant_Key__c, Merchant_Account__r.Merchant_ID__c, Merchant_Account__c, OwnerId, Payment_Description__c, Payment_ID__c, PaymentTypeID__c, Id, RecordTypeId, Response__c, ResponseCode__c, ResponseIndicator__c, ResponseMessage__c, SystemModstamp, TransactionID__c, VANReference__c FROM CC_Alias__c  where Id = :objId LIMIT 1];
        Merchant_Accounts__c merchAcc = [SELECT CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, Name, Merchant_ID__c, Merchant_Key__c, OwnerId, Id, Station__c, SystemModstamp FROM Merchant_Accounts__c where Id = :lstNewEFT.Merchant_Account__c];
        String M_ID, M_KEY, ROUTING_NUMBER, ACCOUNT_NUMBER, C_ACCT_TYPE, strOriginatorId;
        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultvirtualcheck.asmx?';                    
        myurl += 'M_ID=' + EncodeValue(merchAcc.Merchant_ID__c);
        myurl += '&M_KEY=' + EncodeValue(merchAcc.Merchant_Key__c);
        myurl += '&C_ORIGINATOR_ID=' + EncodeValue(strOriginatorId);
        myurl += '&C_FIRST_NAME=' + EncodeValue(lstNewEFT.Contact__r.FirstName);
        myurl += '&C_MIDDLE_INITIAL=' + EncodeValue(lstNewEFT.Contact__r.middle_name__c);
        myurl += '&C_LAST_NAME=' + EncodeValue(lstNewEFT.Contact__r.LastName);
        myurl += '&C_SUFFIX=' + EncodeValue(lstNewEFT.Contact__r.suffix__c);
     /*   myurl += '&C_ADDRESS=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_CITY=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_STATE=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_ZIP=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_COUNTRY=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_EMAIL=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&GUID=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&T_AMT=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_TELEPHONE=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);*/
        System.debug('request URL:'+ myurl);
        String ResXML='';
        //ResXML = HTTPSageRequest(myurl);
        return HTTPSageRequest(myurl);
        
    }

    public String checkCreateGuidResponse(String strXMLResponse)
    {
         System.Debug('@@@GuidSageResponse:' + strXMLResponse);
         Boolean blnRetValue = false;
         String strResponseCode;
         If(strXMLResponse == null || strXMLResponse.Length() == 0) {
             return null;
         }
         else if(strXMLResponse.contains('diffgr') == false)
         {
             Response_message = strXMLResponse;
             return null;
         }
         else {
             try {

                 XMLDom dom = new XMLDom(strXMLResponse);
                 XMLDom.Element xmlObj ;
                 


                 if(dom.getElementByTagName('diffgr:diffgram') != null) {
                    xmlObj = dom.getElementByTagName('diffgr:diffgram');
                    if (xmlObj.getElementsByTagName('SUCCESS').size()>0) {
                        
                        strStatus = xmlObj.getElementsByTagName('SUCCESS')[0].nodeValue;
                        Response_message = xmlObj.getElementsByTagName('MESSAGE')[0].nodeValue;
                        Response_Code = xmlObj.getElementsByTagName('GUID')[0].nodeValue;

                        system.debug('###Status:' + strStatus + ' -Message:' + Response_message +' #### Response_Code:'+Response_Code );
                        if(strStatus != null && strStatus.Length()>0 )
                        {
                            blnRetValue = true;
                        }
                    }
                }
                else {
                    Response_message = strXMLResponse;
                    blnRetValue = false;
                }
             }catch(Exception ex){
                 Response_Code = '';
                 Response_message = 'Response Reading Error';
             }
         }
         strResponseCode= Response_Code;
         return strResponseCode;
    }
  

/***Ketan A Benegal-EFT Processing - Code End*******************************************/
 Static TestMethod void TestSageTransactionProcess() {
        SageTransactionProcess clsTest = new SageTransactionProcess();
        clsTest.SagePaymentRequest('Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test');
        
        clsTest.SageRefundRequest('Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test','Test','Test',
        'Test','Test','Test','Test');
        
        clsTest.SageVirtualCheckPaymentRequest('Test','Test','Test','Test',
            'Test','Test','Test','Test','Test','Test',
            'Test','Test','Test','Test','Test','Test','Test',
            'Test','Test','Test','Test','Test','Test',
            'Test','Test','Test');

        Merchant_Accounts__c m = new Merchant_Accounts__c(Name='test',Station__c = 'AAAA', Merchant_ID__c='123123', Merchant_Key__c='q2123');
        insert m;
            
        clsTest.createEFTGuid('Test','Test','Test','AAAA','Saving');
        
        CC_Alias__c CC = new CC_Alias__c(Merchant_Account__c = m.id);
        insert cc;

        clsTest.processEFTPayment(cc.id);
        clsTest.checkCreateGuidResponse('<TEST>Test</TEST>');
        
        
        
        SageTransactionProcess.SageUPDATE_CREDIT_CARD_EXPIRATION_DATERequest('test','test','test','1011');
        String strXMLResponse = '<DataSet xmlns="https://www.sagepayments.net/web_services/wsVault/wsVault">'
             + '<xs:schema xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata=' 
             + '"urn:schemas-microsoft-com:xml-msdata" id="NewDataSet"><xs:element name="NewDataSet" '
             + 'msdata:IsDataSet="true" msdata:UseCurrentLocale="true"><xs:complexType><xs:choice minOccurs="0" '
             + 'maxOccurs="unbounded"><xs:element name="Table1"><xs:complexType><xs:sequence><xs:element name="SUCCESS"'
             + ' type="xs:boolean" minOccurs="0"/><xs:element name="GUID" type="xs:string" minOccurs="0"/>' 
             + '<xs:element name="MESSAGE" type="xs:string" minOccurs="0"/></xs:sequence></xs:complexType>' 
             + '</xs:element></xs:choice></xs:complexType></xs:element></xs:schema><diffgr:diffgram ' 
             + 'xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">' 
             + '<NewDataSet xmlns=""><Table1 diffgr:id="Table11" msdata:rowOrder="0" diffgr:hasChanges="inserted"><SUCCESS>true</SUCCESS>' 
             + '<GUID>68387517be074c32aec8450284de86c5</GUID><MESSAGE>SUCCESS</MESSAGE></Table1></NewDataSet></diffgr:diffgram></DataSet>';
        SageTransactionProcess.CheckUpdateExpireDateResponse(strXMLResponse); 
        
        List<TRANSACTION_BATCH__c> lstobjTran1 = New List<TRANSACTION_BATCH__c>([SELECT  id from TRANSACTION_BATCH__c limit 1]);
        if(lstobjTran1.size()>0) {
          SageTransactionProcess.UpdateExpireDateAndRePayment(lstobjTran1[0].id);
        }
    }

}