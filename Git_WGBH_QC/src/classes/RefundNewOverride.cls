public class RefundNewOverride{

    String GivingRenderId;
    String CCRenderId;
    String AmountRenderId;
    String RefundPrefix;
    public RefundNewOverride(ApexPages.StandardController controller) {
        List<RefundIDSetting__c> lstRendIDs = new List<RefundIDSetting__c>([Select name,FieldAPIName__c,RendaredValue__c From RefundIDSetting__c]);
        if(lstRendIDs != null && lstRendIDs.size() > 0){
            for(RefundIDSetting__c RID: lstRendIDs){
                if(RID.FieldAPIName__c == 'Giving__c') GivingRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'CC_Alias__c') CCRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'Refund_Amount__c') AmountRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'RefundPrefix') RefundPrefix = RID.RendaredValue__c;            
            }        
        }
    }
    List<Opportunity> getGiving(String oppId){
        List<Opportunity> lstOpp =
        [Select Payment_Amount__c, CC_EFT_Alias__c, CC_EFT_Alias__r.name from Opportunity
        Where Id=:oppId];
        
        return lstOpp;
    }
    public PageReference RedirectToStandardPage() {
        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        string GivingId = ApexPages.CurrentPage().getParameters().get(GivingRenderId + '_lkid');
        string GivingName = ApexPages.CurrentPage().getParameters().get(GivingRenderId);
        string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        List<Opportunity> lstGiving = getGiving(GivingId);
        string url = '';
        url = '/' + RefundPrefix + '/e';
        url += '?' + GivingRenderId + '=' + EncodingUtil.urlEncode(GivingName, 'UTF-8');
        url += '&' + GivingRenderId + '_lkid=' + EncodingUtil.urlEncode(GivingId, 'UTF-8');
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Payment_Amount__c != null){
                url += '&' + AmountRenderId + '=' + lstGiving[0].Payment_Amount__c;
            }
            if(lstGiving[0].CC_EFT_Alias__c != null){
                url += '&' + CCRenderId + '_lkid=' + EncodingUtil.urlEncode(lstGiving[0].CC_EFT_Alias__c, 'UTF-8');
                url += '&' + CCRenderId + '=' + EncodingUtil.urlEncode(lstGiving[0].CC_EFT_Alias__r.name, 'UTF-8');
            }
        }
        url += '&retURL=' + retURL;
        url += '&RecordType=' + RecordType;
        url += '&ent=' + ent;        
        url += '&nooverride=1';
        
        PageReference redirect = new PageReference(url);
        redirect.SetRedirect(true);        
        return redirect;
    }
    Static TestMethod void TestRefundNewOverride(){
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign(Name = 'Test');
        c.Station__c = 'WGBH';
        c.Campaign_Name__c = 'Annual';
        Insert c;
        
        List<RecordType> lstGivingRecordType = [Select Id from RecordType Where DeveloperName = 'Annual'];
        
        CC_Alias__c cc = new CC_Alias__c();
        cc.Account__c = a.Id;
        cc.Amount__c = 500;
        cc.Bank_Account_Owner_Name__c = 'test';
        cc.Bank_Name__c = 'test';
        cc.Card_Holder_Name__c = 'test';
        cc.Card_Type__c = 'Mastercard';
        insert cc;
        
        Opportunity opp = New Opportunity();
        opp.AccountID = a.Id;
        opp.Name = 'Test';
        opp.Gift_Kind__c = 'One Payment';
        opp.Gift_Type__c = 'New';
        opp.Giving_Amount__c = 500;
        opp.Payment_Amount__c = 500;
        opp.CloseDate = system.Today().AddDays(15);
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        opp.CC_EFT_Alias__c = cc.Id;
        if(lstGivingRecordType != null && lstGivingRecordType.size()>0){
            opp.RecordTypeId = lstGivingRecordType[0].Id;
        }
        insert opp; 
        /////////////
        String testGivingRenderId = '';
        String testCCRenderId = '';
        String testAmountRenderId = '';
        String testRefundPrefix = '';
        List<RefundIDSetting__c> lstTest = new List<RefundIDSetting__c>([Select name,FieldAPIName__c,RendaredValue__c From RefundIDSetting__c]);
        if(lstTest != null && lstTest.size() > 0){
            for(RefundIDSetting__c RID: lstTest){
                if(RID.FieldAPIName__c == 'Giving__c') testGivingRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'CC_Alias__c') testCCRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'Refund_Amount__c') testAmountRenderId = RID.RendaredValue__c;
                else if(RID.FieldAPIName__c == 'RefundPrefix') testRefundPrefix = RID.RendaredValue__c;            
            }        
        }        
        /////////////
        Refund__c r = new Refund__c();
        List<RecordType> RefundRecordType = [Select DeveloperName from RecordType where DeveloperName='Refund_by_Charge_Card'];
        if(RefundRecordType != null && RefundRecordType.size()>0){
            ApexPages.CurrentPage().getParameters().put('RecordType',RefundRecordType[0].Id);
        }
        ApexPages.CurrentPage().getParameters().put('retURL','/' + opp.Id);
        if(testGivingRenderId != ''){
            ApexPages.CurrentPage().getParameters().put(testGivingRenderId + '_lkid', opp.Id);
            ApexPages.CurrentPage().getParameters().put(testGivingRenderId, opp.Name);
        }
        ApexPages.StandardController controller = new ApexPages.StandardController(r);
        RefundNewOverride clsTest = new RefundNewOverride(controller);
        clsTest.RedirectToStandardPage();
    }   
}