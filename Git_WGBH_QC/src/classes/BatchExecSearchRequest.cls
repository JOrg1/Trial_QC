global class BatchExecSearchRequest implements Database.Batchable<sObject> {
    global final String Query;   
    global final ID RequestID;
    String ContactField;
    global final boolean isContact;
    global final String CampaignId;    
    Decimal Index;
    global boolean blnFurtherBatchRequired;
    global final String CreatedById;
    global BatchExecSearchRequest (String q,ID ReqID, Boolean isContactId, String campId, String ReqUserId){
        Query = q;
        RequestID = ReqID;
        isContact = isContactId;
        CampaignId = campId;
        CreatedById = ReqUserId;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        DoBatchSearchContact(scope);
    }
    String NVL(String val){
        if(val == null){
            return '';
        }
        else{
            return val.trim();
        }
    }
    
    void DoBatchSearchContact(List<sObject> scope){
        //System.debug('################## Batch result : ' + scope);
        String QueryLimit = System.Label.QuerySize;
        if(scope != null && scope.size()>0){
            //CreatedById = NVL(String.valueOf(scope[0].get('CreatedById')));
            for(sObject s:scope){                
                String rQuery = NVL(String.valueOf(s.get('Query__c')));
                Index = Decimal.valueOf(String.ValueOf((s.get('Index__c'))));
                
                ContactField = NVL(String.valueOf(s.get('FieldName__c')));
                if(rQuery != ''){
                    ///////////////////////
                    String innerQuery;
                    if(isContact == true){
                        innerQuery = 'Select ContactLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and col' + string.valueOf(integer.valueof(Index)) + '__c=true';
                    }
                    else{
                        innerQuery = 'Select LeadLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and col' + string.valueOf(integer.valueof(Index)) + '__c=true';
                    }
                    /////////////
                    String updateQuery = rQuery;
                    //String updateInnerQuery = rQuery + ' Limit ' + QueryLimit;
                    updateQuery += ' And ' + ContactField + ' in(' + innerQuery + ') Limit ' + QueryLimit;
                    system.debug('############## Update Query : ' + updateQuery);
                    //updateQuery
                    /////////////
                    //System.debug('#########  innerQuery ' + innerQuery);
                    /*List<sObject> lstInner = Database.Query(innerQuery);
                    String strIds = '';
                    if(lstInner != null && lstInner.size()>0){
                        List<Search_Result__c> lstSearchResult = (List<Search_Result__c>) lstInner;
                        for(Search_Result__c sid:lstSearchResult){
                            String str = sid.ContactLookup__c;
                            if(str!=null && str != ''){
                                if(strIds == ''){
                                    strIds = '\'' + str + '\'';
                                }
                                else {
                                    strIds += ',\'' + str + '\'';
                                }
                            }
                        }
                    }
                    //System.debug('#########  strIds ' + strIds);
                    ///////////////////////
                    */
                    rQuery += ' And ' + ContactField + ' not in(' + innerQuery + ')';
                    //if(strIds != ''){
                        //rQuery += ' And ' + ContactField + ' not in(Select ContactLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and col' + string.valueOf(integer.valueof(Index)) + '__c=true ) Limit 10';
                        
                        //rQuery += ' And ' + ContactField + ' not in(' + strIds + ')';
                    //}
                    rQuery += ' Limit ' + QueryLimit;
                    System.debug('############ rQuery ' + rQuery);
                    try{
                        List<sObject> result = Database.Query(rQuery);
                        
                        
                        Requested_Search__c objInsert;
                        Requested_Search__c objUpdate = new Requested_Search__c();                                       
                        objUpdate = [Select Id, FieldName__c, Index__c, Query__c, Request__c, Status__c 
                        From Requested_Search__c Where Request__c =: RequestID and Index__c =: Index and Status__c = 'Pending'];                    
                        
                        if(result != null && result.size()>0){
                            SearchResult(result, updateQuery, ContactField);
                            if(result.size()>=Integer.valueOf(QueryLimit)){
                                objInsert = objUpdate.clone(false); 
                                objInsert.Status__c = 'Pending';
                                //List<Search_Request__c> lstNextRequest = [Select Id, IsExecuteNextBatch__c, NextBatchTime__c From Search_Request__c Where ]                                      
                            }
                        }  
                        objUpdate.Status__c = 'Closed';                        
                        Update objUpdate;                      
                        Insert objInsert;
                    }Catch(Exception ex){
                        List<Requested_Search__c> objUpdate = new List<Requested_Search__c>(); 
                        objUpdate = [Select Id, FieldName__c, Index__c, Query__c, Request__c, Status__c 
                        From Requested_Search__c Where Request__c =: RequestID and Index__c =: Index and Status__c = 'Pending'];                    
                        if(objUpdate.size()>0){
                            objUpdate[0].Status__c = 'Error';
                            objUpdate[0].Error_Description__c = ex.getMessage();
                            Update objUpdate;
                        }
                    }                    
                    //System.debug('########## Updated search Query : ' + rQuery);                    
                }
            }
        }
    }

    void UpsertOperation(List<sObject> scope){
        if(scope != null && scope.size() > 0){
            String QueryLimit = System.Label.QuerySize;         
            String rQuery = NVL(String.valueOf(scope[0].get('Query__c')));
            Index = Decimal.valueOf(String.ValueOf((scope[0].get('Index__c'))));
            ContactField = NVL(String.valueOf(scope[0].get('FieldName__c')));
            String QueryId = NVL(String.valueOf(scope[0].get('Id')));
            if(NVL(rQuery) != ''){
                String innerQuery;
                if(isContact == true){
                    innerQuery = 'Select ContactLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and col' + string.valueOf(integer.valueof(Index)) + '__c = false';
                }
                else{
                    innerQuery = 'Select LeadLookup__c From Search_Result__c Where Request__c = \'' + RequestID + '\' and col' + string.valueOf(integer.valueof(Index)) + '__c = false';
                }
                rQuery += ' And ' + ContactField + ' in(' + innerQuery + ') Limit ' + QueryLimit;
                
                List<sObject> lstResult = Database.Query(rQuery);
                
                Requested_Search__c objQuery = [Select Id, FieldName__c, Index__c, Query__c, Request__c, Status__c 
                From Requested_Search__c Where Id =: QueryId and Request__c =: RequestID and Index__c =: Index and Status__c = 'Pending' and Operation__c = 'Update' limit 1]; 
                
                if(lstResult != null && lstResult.size()>0){
                    List<SObject> lstUpsert = new List<Search_Result__c>();
                    for(sObject obj:lstResult){
                        sObject s = new Search_Result__c();
                        String str = String.valueOf(obj.get(ContactField));
                        s.put('External_ID__c', str);                                        
                        if(isContact == true){
                            s.put('Contact__c',true);
                            s.put('Lead__c',false);
                            s.put('ContactLookup__c', str.substring(0,15));
                        }else{
                            s.put('Contact__c',false);
                            s.put('Lead__c',true);
                            s.put('LeadLookup__c', str.substring(0,15));
                        }
                        s.put('Request__c', RequestID);
                        s.put('col' + integer.ValueOf(Index) + '__c',true);
                        lstUpsert.add((Search_Result__c) s);
                    }
                    if(lstUpsert != null && lstUpsert.size()>0){
                        Upsert lstUpsert;
                    }
                    if(lstResult.size() <= Integer.valueOf(QueryLimit)){
                        objQuery.Operation__c = 'None';
                        objQuery.Status__c = 'Close';
                    }
                }
                else{
                    objQuery.Operation__c = 'None';
                    objQuery.Status__c = 'Close';
                }
                Update objQuery;
            }
        }
    }
    
    void SearchResult(List<sObject> scope, String updateQuery, String ContactFieldId){
        //List<Search_Result__c> lstTempSearchResult = (List<Search_Result__c>) lstResult;
        List<Search_Result__c> lstInsert = new List<Search_Result__c>();
        List<Search_Result__c> lstUpdate = new List<Search_Result__c>();
        
        if(scope != null && scope.size()>0){
            for(sObject sobj:scope){                
                String str = String.valueOf(sobj.get(ContactFieldId));
                sObject s = new Search_Result__c();                
                if(isContact == true){
                    s.put('Contact__c',true);
                    s.put('Lead__c',false);
                    s.put('ContactLookup__c', str.substring(0,15));
                }else{
                    s.put('Contact__c',false);
                    s.put('Lead__c',true);
                    s.put('LeadLookup__c', str.substring(0,15));
                }
                s.put('Request__c', RequestID);
                s.put('col' + integer.ValueOf(Index) + '__c',true);
                lstInsert.add((Search_Result__c) s);
            }
        }    
        List<sObject> lstContact = Database.Query(updateQuery);
        String strIds = ''; 
        if(lstContact != null && lstContact.size()>0){
                       
            for(sObject s:lstContact){
                String str = String.valueOf(s.get(ContactFieldId));
                if(str!=null && str != ''){
                    str = str.substring(0,15);
                    //setIds.add(str.substring(0,15));
                    if(strIds == ''){
                        strIds = '\'' + str + '\'';
                    }
                    else{
                        strIds += ', \'' + str + '\'';
                    }
                }
            }
        }
        List<sObject> lstResult;
        
        if(strIds != null && strIds.length()>0){
            String strQuery = 'Select Id, Contact__c, Lead__c, Request__c, LeadLookup__c, ContactLookup__c, col1__c, col2__c, col3__c, col4__c, col5__c, col6__c, col7__c, col8__c, col9__c, col10__c, col11__c, col12__c, col13__c, col14__c, col15__c, col16__c, col18__c, col19__c, col20__c, col21__c, col22__c, col23__c, col24__c, col25__c, Status__c ';
            
            if(isContact == true){
                strQuery += 'FROM Search_Result__c Where ContactLookup__c <> null And ContactLookup__c in(' + strIds + ')';
            }else{
                strQuery += 'FROM Search_Result__c Where LeadLookup__c <> null And LeadLookup__c in(' + strIds + ')';
            }
            lstResult = Database.Query(strQuery);
        }
        
        if(lstResult != null && lstResult.size()>0){
            //List<Search_Result__c> lstTempSearchResult = (List<Search_Result__c>) lstResult;
            for(sObject obj:lstResult){
                obj.put('col' + integer.ValueOf(Index) + '__c',true);
                if(isContact == true){
                    obj.put('Contact__c',true);
                    obj.put('Lead__c',false);
                }else{
                    obj.put('Contact__c',false);
                    obj.put('Lead__c',true);
                }
                obj.put('Request__c', RequestID);
                lstUpdate.add((Search_Result__c)obj);
                
                if(lstUpdate.size()>5000){
                    Update lstUpdate;
                    lstUpdate = new List<Search_Result__c>();
                }
            }
        }
        if(lstInsert != null && lstInsert.size()>0){
            Insert lstInsert;
        }
        if(lstUpdate != null && lstUpdate.size()>0){
            Update lstUpdate;
        }
    }
    
    void SearchResult1(List<sObject> scope){
        //System.debug('################## Batch result : ' + scope);
        if(scope != null && scope.size()>0){
            Set<String> setIds = new Set<String>();
            String strIds = '';            
            for(sObject s:scope){
                String str = String.valueOf(s.get(ContactField));
                if(str!=null && str != ''){
                    str = str.substring(0,15);
                    setIds.add(str.substring(0,15));
                    if(strIds == ''){
                        strIds = '\'' + str + '\'';
                    }
                    else{
                        strIds += ', \'' + str + '\'';
                    }
                }
            }
            
            if(setIds != null && setIds.size()>0){
                String strQuery = 'Select Id, Contact__c, Lead__c, Request__c, LeadLookup__c, ContactLookup__c, col1__c, col2__c, col3__c, col4__c, col5__c, col6__c, col7__c, col8__c, col9__c, col10__c, col11__c, col12__c, col13__c, col14__c, col15__c, col16__c, col18__c, col19__c, col20__c, col21__c, col22__c, col23__c, col24__c, col25__c, Status__c ';
                
                if(isContact == true){
                    strQuery += 'FROM Search_Result__c Where ContactLookup__c <> null And ContactLookup__c in(' + strIds + ')';
                }else{
                    strQuery += 'FROM Search_Result__c Where LeadLookup__c <> null And LeadLookup__c in(' + strIds + ')';
                }
                List<sObject> lstResult = Database.Query(strQuery);
                
                List<Search_Result__c> lstInsert = new List<Search_Result__c>();
                List<Search_Result__c> lstUpdate = new List<Search_Result__c>();
                
                if(lstResult != null && lstResult.size()>0){
                    for(String ids:setIds){
                        Search_Result__c objResult = new Search_Result__c();
                        Boolean blnFound = false;
                        
                        List<Search_Result__c> lstTempSearchResult = (List<Search_Result__c>) lstResult;
                        
                        Integer i=0;
                        
                        for(sObject obj:lstResult){
                            if(ids!=null && ids == lstTempSearchResult[i].ContactLookup__c){
                                obj.put('col' + integer.ValueOf(Index) + '__c',true);
                                if(isContact == true){
                                    obj.put('Contact__c',true);
                                    obj.put('Lead__c',false);
                                }else{
                                    obj.put('Contact__c',false);
                                    obj.put('Lead__c',true);
                                }
                                obj.put('Request__c', RequestID);
                                lstUpdate.add((Search_Result__c)obj);
                                blnFound = true;
                                break;
                            }
                            i++;
                        }
                        if(blnFound == false){
                            sObject s = new Search_Result__c();
                            
                            if(isContact == true){
                                s.put('Contact__c',true);
                                s.put('Lead__c',false);
                                s.put('ContactLookup__c', ids.substring(0,15));
                            }else{
                                s.put('Contact__c',false);
                                s.put('Lead__c',true);
                                s.put('LeadLookup__c', ids.substring(0,15));
                            }
                            s.put('Request__c', RequestID);
                            s.put('col' + integer.ValueOf(Index) + '__c',true);
                            lstInsert.add((Search_Result__c) s);
                        }
                    }
                }
                else{
                    for(String ids:setIds){
                        sObject s = new Search_Result__c();
                        
                        if(isContact == true){
                            s.put('Contact__c',true);
                            s.put('Lead__c',false);
                            s.put('ContactLookup__c', ids.substring(0,15));
                        }else{
                            s.put('Contact__c',false);
                            s.put('Lead__c',true);
                            s.put('LeadLookup__c', ids.substring(0,15));
                        }
                        s.put('Request__c', RequestID);
                        s.put('col' + integer.ValueOf(Index) + '__c',true);
                        lstInsert.add((Search_Result__c) s);
                    }
                }
                if(lstInsert != null && lstInsert.size()>0){
                    Insert lstInsert;
                }
                if(lstUpdate != null && lstUpdate.size()>0){
                    Update lstUpdate;
                }
                
            }
        }
    }    
    global void finish(Database.BatchableContext BC) {
        /////////////////
        /////////////////
        //Requested_Search__c
        
        
        List<Search_Request__c> lstRequest = [Select Id, Template__r.name, IsExecuteNextBatch__c, NextBatchTime__c From Search_Request__c
        Where Id =: RequestID]; 
        
        List<Requested_Search__c> lstPendingRequest = new List<Requested_Search__c>();        
        lstPendingRequest = [Select id From Requested_Search__c Where Status__c = 'Pending' And Request__c =:RequestID];
        
        if(lstPendingRequest.size()==0){
            
            List<Requested_Search__c> lstErrors = new List<Requested_Search__c>();        
            lstErrors = [Select id, Error_Description__c From Requested_Search__c Where Status__c = 'Error' And Request__c =:RequestID];
            
            List<String> toAddresses = new List<String>();
            //toAddresses.add('kamlesh.chauhan@roundcorner.com');
            toAddresses.add('dhaval.panchal@roundcorner.com');
            system.debug('############# Created By ' + CreatedById);
            if(CreatedById != null && CreatedById != ''){
                List<User> lstUser = [Select Email From User Where Id=:CreatedById];
                if(lstUser != null && lstUser.size()>0){
                    toAddresses.add(lstUser[0].Email);
                }
            }
            //CampaignId
            String Body = '';
            Body += '<br/><br/>';
            if(lstRequest != null && lstRequest.size()>0){
                if(lstErrors != null && lstErrors.size()>0){
                    Body += 'Your batch has been completed with errors for Template : ' + lstRequest[0].Template__r.Name;
                }
                else{
                    Body += 'Your batch has been completed successfully for Template : ' + lstRequest[0].Template__r.Name;
                }
                Body += '<br/><br/>';
            }
            String CurrentURL = '';//ApexPages.currentPage().getHeaders().get('Host');
            //Body += 'https://c.cs0.visual.force.com/apex/CampaignMember?id=' + CampaignId + '&mode=batch&RequestID=' + RequestID;
            Body += 'https://c.cs9.visual.force.com/apex/CampaignMember?id=' + CampaignId + '&mode=batch&RequestID=' + RequestID;
            Body += '<br/><br/>';
            system.debug('############ to Address : ' + toAddresses);
            //sendEmail(toAddresses,Body);
            if(lstRequest != null && lstRequest.size()>0){
                lstRequest[0].Status__c = 'Completed';
                lstRequest[0].Finalize__c = true;
                lstRequest[0].NextBatchTime__c = system.now().addMinutes(2);
                //lstNewRequest[0].Sub_Request__c = lstNewRequest[0].Id;                
            }
        }
        else if(lstPendingRequest.size()>0){
            if(lstRequest != null && lstRequest.size()>0){
                lstRequest[0].Status__c = 'Pending';
                lstRequest[0].IsExecuteNextBatch__c = true;
                lstRequest[0].NextBatchTime__c = system.now().addMinutes(2);
                //lstNewRequest[0].Sub_Request__c = lstNewRequest[0].Id;                
            }
        }
        
        if(lstRequest != null && lstRequest.size()>0){
            Update lstRequest;
        }
        System.debug('####Update Completed...');
    }

    void sendEmail(List<String> toAddresses, String strBody){
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        /*
        String DisplayName = System.Label.SenderDisplayName;
        List<OrgWideEmailAddress> lstOrg = [select id, Address, DisplayName from OrgWideEmailAddress Where DisplayName=:DisplayName];
        //setOrgWideEmailAddressId
        if(lstOrg != null && lstOrg.size()>0){
            mail.setOrgWideEmailAddressId(lstOrg[0].Id);
        }else{
            mail.setInReplyTo('wecare@sccc.co.th');
            mail.setReplyTo('wecare@sccc.co.th');
            // Specify the name used as the display name.              
            mail.setSenderDisplayName('wecare');
        }
        */
        mail.setToAddresses(toAddresses);
        //mail.setSubject('Birthday notification on ' + system.today().format());
        mail.setSubject('Campaign Member Status');
        mail.setUseSignature(false);
        mail.setPlainTextBody('Campaign Member Status');
        mail.setHtmlBody(strBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }
    static testMethod void TestBatchExecSearchRequest() {
       
    }
}