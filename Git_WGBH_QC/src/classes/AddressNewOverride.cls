public class AddressNewOverride {

    public string currPageURL{get;set;}
    public string URL1{get;set;}

    public AddressNewOverride(ApexPages.StandardController controller) {

    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    
    public PageReference RedirectToNewAddress() {
        
        String host = ApexPages.currentPage().getHeaders().get('Host');
        PageReference currPage = ApexPages.currentPage();
        
        currPageURL = currPage.getUrl();
        URL1 = currPageURL.substring(currPageURL.indexOf('?'),currPageURL.Length());
        
        URL1 = URL1.replace('sfdc.override','sfdc.no.override');
        URL1 = URL1.replace('&save_new=1','');
        URL1 = URL1.replace('%26save_new=1','');
        
        String URL;
        Schema.DescribeSObjectResult resultkeyPrefix = Address__c.sObjectType.getDescribe();  
              
        URL = '/'+resultkeyPrefix.getKeyPrefix()+'/e'+URL1;             
        
        URL += '&Name=-';        
        URL += '&nooverride=1';        
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }   
}