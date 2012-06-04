public class CreatePRR {

    Public String AccountRendId = '';
    Public String ContactRendId = '';
    Public String AuthorRendId = '';
    Public String CampaignRendId = '';
    Public String ProspectResearchReportsObjId = '';
    
    public CreatePRR(ApexPages.StandardController controller) {
        List<ProspectResearchIDSetting__c> lstRendIDs = new List<ProspectResearchIDSetting__c>([Select name,FieldAPIName__c,RendaredValue__c From ProspectResearchIDSetting__c]);
        for(ProspectResearchIDSetting__c RID: lstRendIDs){
            if(RID.FieldAPIName__c == 'Account__c') AccountRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'Contact__c') ContactRendId = RID.RendaredValue__c;            
            else if(RID.FieldAPIName__c == 'Author__c') AuthorRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'CPRT__c') CampaignRendId = RID.RendaredValue__c;
            else if(RID.FieldAPIName__c == 'Prospect_Research_Reports__c') ProspectResearchReportsObjId = RID.RendaredValue__c;
        }
    }
    
    public String ContactId{get;set;}
    public String AccountId{get;set;}
    public String CampaignId{get;set;}
    public String MemberId{get;set;}
    
    public PageReference Redirect() {
        string URL='';
        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new= ApexPages.CurrentPage().getParameters().get('save_new');
                       
        ContactId = ApexPages.CurrentPage().getParameters().get('conid');
        AccountId = ApexPages.CurrentPage().getParameters().get('accid');
        CampaignId = ApexPages.CurrentPage().getParameters().get('CampaignId');
        MemberId = ApexPages.CurrentPage().getParameters().get('MemberId');
        
        URL += '/setup/ui/recordtypeselect.jsp?ent=' + ProspectResearchReportsObjId + '&save_new_url=%2Fapex%2FCreatePRR1';
        URL += '?CF' + AuthorRendId +'=' + UserInfo.getName(); 
        URL += '&retURL=' + MemberId;    
        if(ContactId != null && ContactId.length()>=15){
            List<Contact> lstContact = [Select name, Account.name, Account.Id from contact where id=:ContactId];
            if(lstContact != null && lstContact.size()>0){
                URL += '&CF' + ContactRendId +' =' + EncodingUtil.urlEncode(lstContact[0].name, 'UTF-8');
                URL += '&CF' + ContactRendId +'_lkid=' + ContactId; 
                AccountId = lstContact[0].Account.Id;
            }
        }
        if(AccountId != null && AccountId.length()>=15){        
            URL += '&CF' + AccountRendId + '_lkid=' + AccountId;
            List<Account> lstHO = [SELECT id, name, createddate FROM Account WHERE Id =: AccountId];
            if(lstHO != null && lstHO.size()>0){
                URL += '&CF' + AccountRendId + '=' + EncodingUtil.urlEncode(lstHO[0].name, 'UTF-8');
                URL += '&Name=' + getPRRName(lstHO[0].name, lstHO[0].createddate);
            }            
        }
        URL += '&saveURL=%2F' + MemberId; 
        if(CampaignId != null && CampaignId.length()>=15){
            URL += '&CF' + CampaignRendId + '_lkid=' + CampaignId;            
            List<Campaign> lstCPRT = [SELECT id, name, createddate FROM Campaign WHERE Id =: CampaignId];
            if(lstCPRT != null && lstCPRT.size()>0){
                URL += '&CF' + CampaignRendId + '=' + EncodingUtil.urlEncode(lstCPRT[0].name, 'UTF-8');
            }                       
        }
        URL += '&nooverride=1';        
        
        //URL = '/a17/e?CF00NQ0000000mKs9=Kamlesh+Chauhan&CF00NQ0000000mKsE=Kamlesh+Chauhan&CF00NQ0000000mKsE_lkid=003Q000000OVWg4&ent=01IQ00000000h5A&Name=2011%2F09%2F23&nooverride=1&RecordType=012Q00000000PSb&retURL=%2F003Q000000OVWg4';
        system.debug('########### Final URL : ' + URL);
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }
   Public String getPRRName(String HouseHoldName, DateTime dtCreated){
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
    
  
}