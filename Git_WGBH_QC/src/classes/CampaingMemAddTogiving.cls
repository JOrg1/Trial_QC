public class CampaingMemAddTogiving{

    public CampaingMemAddTogiving(ApexPages.StandardController controller) {       
    
    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    public string CampaignMemId {get;set;}
    public string GivingId {get;set;}
    public PageReference RedirectToNewGiving() {
        
        CampaignMemId = ApexPages.CurrentPage().getParameters().get('cmid');
        GivingId = ApexPages.CurrentPage().getParameters().get('newid');
        CampaignMember cm = new CampaignMember();
        Opportunity opp = new Opportunity();
        opp = [Select ID,StageName from Opportunity where Id =:GivingId];
        if(CampaignMemId !=null && CampaignMemId !=''){
            cm = [Select ID,Giving__c,Moves_Management_Stage__c from CampaignMember where Id =:CampaignMemId];
            cm.Giving__c = GivingId;
            cm.Moves_Management_Stage__c = opp.StageName;
            Update cm;
        }
        
        PageReference P = new PageReference('/'+CampaignMemId);
        P.SetRedirect(true);        
        return P;
    }    
    
     static testMethod void TestCampaingMemAddTogiving() {
        
        
        Account a = new Account(Name = 'Test Account');        
        
        Campaign c = new Campaign(Name='TestCampaign');
        insert c;
        //Campaign cmp = new Campaign(Name='cmp');
        //insert cmp;
        Contact co = new Contact(FirstName='Test Firstname',LastName ='LastName',AccountId= a.Id);
        insert co;
        
        Opportunity op = new Opportunity(Name = 'Test Opprtunity',stagename = 'a',closedate = system.today(),Campaignid = c.id);        
        insert op;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = c.id;
        cm.Giving__c = op.Id;
        cm.ContactId = co.Id;
        //campaign id '701Q000000078kE' 
        insert cm;
        
        ApexPages.CurrentPage().getParameters().put('newid',op.Id);
        ApexPages.CurrentPage().getParameters().put('cmid',cm.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(cm);
        
       
       //ApexPages.currentPage().getParameters().put('id', cm.Id);
        
        CampaingMemAddTogiving clsTest = new CampaingMemAddTogiving(controller);
        clsTest.CampaignMemId = ApexPages.CurrentPage().getParameters().put('cmid',cm.Id);
        clsTest.GivingId = ApexPages.CurrentPage().getParameters().put('newid',op.Id);
        string URL = clsTest.getCurrentURL();
        
        PageReference P = clsTest.RedirectToNewGiving();
        
    } 
}