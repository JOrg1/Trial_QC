global class BatchExecFinalizeSearchRequest implements Database.Batchable<sObject> {

    global final String Query;   
    global final ID RequestID;
    global final Boolean IsContact;
    global final ID CampaignId;
    global BatchExecFinalizeSearchRequest(String q,ID ReqID, Boolean IsCon, ID CampId){
        Query = q;
        RequestID = ReqID;
        IsContact = isCon;
        CampaignId = campId;
        system.debug('######## Query ' + Query);
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
    
    void DoBatchSearchContact(List<sObject> lstResult){
        try{            
            List<Final_Search_Result__c> lstFinal = new List<Final_Search_Result__c>();
            List<CampaignMember> lstMember;
            
            if(lstResult != null && lstResult.size()>0){                
                if(IsContact == true){
                    lstMember = [Select Id, ContactId, Status
                    From CampaignMember Where ContactId != null and CampaignId =: CampaignId];
                }
                else{
                    lstMember = [Select Id, LeadId, Status
                    From CampaignMember Where LeadId != null and CampaignId =: CampaignId];
                }
                for(sObject s:lstResult){
                    if(IsContact == true){
                        Contact c = new Contact();
                        CampaignMember objMember = new CampaignMember();
                        c = (Contact) s;
                        
                        Final_Search_Result__c result = new Final_Search_Result__c();
                        
                        result.Contact__c = c.Id;
                        result.CampaignMemberId__c = null;
                        result.MemberStatus__c = '';
                        result.Request__c = RequestID;
                        result.IsContact__c = true;
                        for(CampaignMember mem:lstMember){
                            if(c.Id == mem.ContactId){
                                result.CampaignMemberId__c = mem.Id;
                                result.MemberStatus__c = mem.Status;
                            }
                        }
                        lstFinal.add(result);
                    }
                    else {
                        Lead c = new Lead();
                        CampaignMember objMember = new CampaignMember();
                        c = (Lead) s;
                        
                        Final_Search_Result__c result = new Final_Search_Result__c();
                        
                        result.Lead__c = c.Id;
                        result.CampaignMemberId__c = null;
                        result.MemberStatus__c = '';
                        result.Request__c = RequestID;
                        result.IsLead__c = true;
                        for(CampaignMember mem:lstMember){
                            if(c.Id == mem.ContactId){
                                result.CampaignMemberId__c = mem.Id;
                                result.MemberStatus__c = mem.Status;
                            }
                        }
                        lstFinal.add(result);
                    }
                }
                if(lstFinal != null && lstFinal.size()>0){
                    insert lstFinal;
                }
            }
        }catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        List<Search_Request__c> lstRequest = [Select CreatedBy.Email, Id, Template__r.name, IsExecuteNextBatch__c, NextBatchTime__c From Search_Request__c
        Where Id =: RequestID]; 
        Search_Result_Report__c reportURL = Search_Result_Report__c.getOrgDefaults();
        
        List<Requested_Search__c> lstPendingRequest = new List<Requested_Search__c>();        
        lstPendingRequest = [Select id From Requested_Search__c Where Status__c = 'Pending' And Request__c =:RequestID];
        
        if(lstPendingRequest.size()==0){
            
            List<Requested_Search__c> lstErrors = new List<Requested_Search__c>();        
            lstErrors = [Select id, Error_Description__c From Requested_Search__c Where Status__c = 'Error' And Request__c =:RequestID];
            
            List<String> toAddresses = new List<String>();
            //toAddresses.add('kamlesh.chauhan@roundcorner.com');
            toAddresses.add('dhaval.panchal@roundcorner.com');
            //system.debug('############# Created By ' + CreatedById);
            if(lstRequest != null && lstRequest.size()>0){
                toAddresses.add(lstRequest[0].CreatedBy.Email);
            }
            /*
            if(CreatedById != null && CreatedById != ''){
                List<User> lstUser = [Select Email From User Where Id=:CreatedById];
                if(lstUser != null && lstUser.size()>0){
                    toAddresses.add(lstUser[0].Email);
                }
            }*/
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
            String reqId = RequestID;
            if(reqId.trim().length()>15){
                reqId = reqId.substring(0,15);
            }
            //Body += 'https://c.cs0.visual.force.com/apex/CampaignMember?id=' + CampaignId + '&mode=batch&RequestID=' + RequestID;
            Body += '<br/>';
            Body += '<br/> To view Result click on below link';
            Body += '<br/>' + reportURL.Report_URL__c + reqId;
            Body += '<br/>';
            Body += '<br/> For Campaign Member click on below link';
            Body += '<br/> https://c.cs9.visual.force.com/apex/CampaignMember?id=' + CampaignId + '&mode=batch&RequestID=' + reqId;
            Body += '<br/><br/>';
            system.debug('############ to Address : ' + toAddresses);
            sendEmail(toAddresses,Body);
            /*
            if(lstRequest != null && lstRequest.size()>0){
                lstRequest[0].Status__c = 'Completed';
                lstRequest[0].Finalize__c = true;
                lstRequest[0].NextBatchTime__c = system.now().addMinutes(2);
                //lstNewRequest[0].Sub_Request__c = lstNewRequest[0].Id;                
            }
            */
        }
        /*
        else if(lstPendingRequest.size()>0){
            if(lstRequest != null && lstRequest.size()>0){
                lstRequest[0].Status__c = 'Pending';
                lstRequest[0].IsExecuteNextBatch__c = true;
                lstRequest[0].NextBatchTime__c = system.now().addMinutes(2);
                //lstNewRequest[0].Sub_Request__c = lstNewRequest[0].Id;                
            }
        }
        */
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
}