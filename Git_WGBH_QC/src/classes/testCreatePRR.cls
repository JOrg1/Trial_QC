@istest
private class testCreatePRR {
   
    static testmethod void testCreatePRR ()
    {
        account acc=new account(name='test');
        insert acc;
        
        contact con = new Contact(LastName = 'test');
        insert con;
        
        Campaign cm = new Campaign(Name = 'Test');
        insert cm;
        
        CampaignMember cmp = new CampaignMember();
        
        
        ApexPages.CurrentPage().getParameters().put('conid',con.Id);
        ApexPages.CurrentPage().getParameters().put('accid',acc.Id);
        ApexPages.CurrentPage().getParameters().put('CampaignId',cm.Id);
        ApexPages.CurrentPage().getParameters().put('MemberId',cmp.id);
         
        ApexPages.StandardController stdCon = new ApexPages.StandardController(acc);
        CreatePRR CP = new CreatePRR(stdCon );
        
        CP.ContactId = ApexPages.CurrentPage().getParameters().put('conid',con.Id);
        CP.AccountId = ApexPages.CurrentPage().getParameters().put('accid',acc.Id);
        CP.CampaignId = ApexPages.CurrentPage().getParameters().put('CampaignId',cm.Id);
        CP.MemberId = ApexPages.CurrentPage().getParameters().put('MemberId',cmp.id);
       
        PageReference P = CP.Redirect();
        
        Datetime myDate = system.today();
         
        CP.getPRRName('test',myDate);

    }
}