public class CreateGivingOverride{

    public CreateGivingOverride(ApexPages.StandardController controller) {

    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    public PageReference RedirectToNewGivingsummery() {
        string URL='';
        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new= ApexPages.CurrentPage().getParameters().get('save_new');
                       
        RecordType r = [Select Id from RecordType where DeveloperName ='Major_Gifts'];
        string RecordType = r.Id;
        String ContactId = ApexPages.CurrentPage().getParameters().get('conid');
        String campid= ApexPages.CurrentPage().getParameters().get('cmid');
        String AccountId = ApexPages.CurrentPage().getParameters().get('accid');
        String CampaignId = ApexPages.CurrentPage().getParameters().get('cmpid');
        String MoveManageStage = ApexPages.CurrentPage().getParameters().get('movemanagestage');
        String ExpectedAmount = ApexPages.CurrentPage().getParameters().get('expectamount');
        String Stretchamount = ApexPages.CurrentPage().getParameters().get('stretchamount');
        
        
        URL += '/006/e?retURL=' + retURL + '&RecordType=' + RecordType + '&ent=Opportunity';
        // URL += '&opp4=' + AccountId;
        /*if(AccountId != null && AccountId.length()>=15){
            URL += '&opp4=' + AccountId;
            //URL += '&opp4_lkid=' + AccountId;
            
        }*/
        if(ContactId != null && ContactId.length()>=15){
            List<Contact> lstContact = [Select name, Account.name,AccountId,Account.Id from contact where id=:ContactId];
            if(lstContact != null && lstContact.size()>0){
                URL += '&CF00NA0000005bdAm=' + EncodingUtil.urlEncode(lstContact[0].name,'UTF-8');
                URL += '&CF00NA0000005bdAm_lkid=' + ContactId;
                URL += '&opp4=' + EncodingUtil.urlEncode(lstContact[0].Account.name,'UTF-8');
                URL += '&opp4_lkid=' + lstContact[0].Account.Id; 
            }
        }
        
        if(CampaignId != null){
            List<Campaign> lstCampaign = [Select Id,Name from Campaign where id=:CampaignId];
            if(lstCampaign != null && lstCampaign.size()>0){                
                URL += '&opp17=' + EncodingUtil.urlEncode(lstCampaign[0].Name,'UTF-8');
                URL += '&opp17_lkid=' + CampaignId;              
            }
        }
        
        if(MoveManageStage != '' && MoveManageStage !=null){
            URL += '&opp11='+MoveManageStage;
        }
        if(ExpectedAmount != '' && ExpectedAmount !=null){
            URL += '&00NQ0000000Yw3M='+ExpectedAmount;
        }
        if(Stretchamount != '' && Stretchamount !=null){
            URL += '&00NQ0000000mSLl='+Stretchamount;
        }
        URL += '&nooverride=1';
        URL += '&saveURL=%2Fapex%2FCampaingMemAddTogiving%3Fcmid'+'%3D'+campid;        
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }

    static testMethod void TestCreateGivingOverride() {
        
        Account a = new Account(Name = 'Test Account');
        Contact ct = new Contact(FirstName = 'Test Contact',AccountId=a.Id);
        Campaign c = new Campaign(Name='TestCampaign');
        
        CampaignMember cm = new CampaignMember(CampaignId = c.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', cm.Id);
        
        CreateGivingOverride clsTest = new CreateGivingOverride(controller);
        string URL = clsTest.getCurrentURL();
        
        ApexPages.CurrentPage().getParameters().put('retURL','%2F701%2Fo');
        
        RecordType r = [Select ID from RecordType where DeveloperName = 'Event' limit 1];
        
   
        ApexPages.CurrentPage().getParameters().put('conid',ct.Id);
        ApexPages.CurrentPage().getParameters().put('accid',a.Id);
        ApexPages.CurrentPage().getParameters().put('accid',cm.Id);
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        ApexPages.CurrentPage().getParameters().put('ent','Campaign');
        ApexPages.CurrentPage().getParameters().put('save_new','1');
                
        
        PageReference P = clsTest.RedirectToNewGivingsummery();
        
        RecordType r1 = [Select ID from RecordType where DeveloperName = 'Major_Gifts' limit 1];
        ApexPages.CurrentPage().getParameters().put('RecordType',r1.Id);
        PageReference P1 = clsTest.RedirectToNewGivingsummery();

    }    
}