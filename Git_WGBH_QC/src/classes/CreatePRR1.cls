public class CreatePRR1{

    Public String PRRPrefixValue = '';
    
    public CreatePRR1(ApexPages.StandardController controller) {
        List<ProspectResearchIDSetting__c> lstRendIDs = new List<ProspectResearchIDSetting__c>([Select name,FieldAPIName__c,RendaredValue__c From ProspectResearchIDSetting__c Where FieldAPIName__c = 'PRRPrefix' Limit 1]);
        If(lstRendIDs.Size() >0) {
            PRRPrefixValue = lstRendIDs[0].RendaredValue__c;
        }
    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    public PageReference RedirectToNewCampaignMember() {
        
        String host = ApexPages.currentPage().getHeaders().get('Host');
        PageReference currPage = ApexPages.currentPage();
       
        String currPageURL = currPage.getUrl();
        string URL1 = currPageURL.substring(currPageURL.indexOf('?'),currPageURL.Length());
        
        URL1 = URL1.replace('sfdc.override','sfdc.no.override');
        //URL1 = URL1.replace('&save_new=1','');
        //URL1 = URL1.replace('%26save_new=1','');
        
        String URL;
        URL = '/' + PRRPrefixValue + '/e'+URL1;            
        string retURL = ApexPages.CurrentPage().getParameters().get('saveURL');
        URL += '&retURL='+retURL;        
        //URL += '&nooverride=1';        
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }   
}