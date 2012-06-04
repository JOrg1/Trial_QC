@isTest
Private class TestCampainMemberReport
{ 
static testMethod void TestCampainMemberReport() 
{
    Contact c1=new Contact(lastname='testcmr');
    insert c1;
    Classification__c clf1= new Classification__c(Preference__c='Additional Gift Appeals',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Classification__c clf2= new Classification__c(Preference__c='Renewal Appeals',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Classification__c clf3= new Classification__c(Preference__c='Upgrade Appeals',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Classification__c clf4= new Classification__c(Preference__c='Best Customer Engagement',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Classification__c clf5= new Classification__c(Preference__c='Sustainer Type',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Classification__c clf6= new Classification__c(Preference__c='Volunteer Type',Preference_Value__c='test',contact__c=c1.id,Station__c='WGBH',Active__c=true);
    Campaign_Member_Report__c cmr= new Campaign_Member_Report__c(contact__c=c1.id);
    List<Campaign_Member_Report__c> lst= new List<Campaign_Member_Report__c>();
    lst.add(cmr);
    insert clf1;
    insert clf2;
    insert clf3;
    insert clf4;
    insert clf5;
    insert clf6;
    insert cmr;
    
    Account acc1=new Account(name='test1');
    Account acc2=new Account(name='test2');
    Account acc3=new Account(name='test3');
    
    insert acc1;
    insert acc2;
    insert acc3;
    
    Address__c a1=new Address__c(name='test1',Postal_Code__c='02191',Account_Household__c=acc1.id);
    Address__c a2=new Address__c(name='test2',Postal_Code__c='02402',Account_Household__c=acc2.id);
    Address__c a3=new Address__c(name='test3',Postal_Code__c='02744',Account_Household__c=acc3.id);
 
    insert a1;
    insert a2;
    insert a3;
    
    acc1.Preferred_Address__c=a1.id;
    acc2.Preferred_Address__c=a2.id;
    acc3.Preferred_Address__c=a3.id;
    update acc1;
    update acc2;
    update acc3;
    
    Contact c2=new Contact(lastname='test1',accountid=acc1.id);
    Contact c3=new Contact(lastname='test2',accountid=acc2.id);
    Contact c4=new Contact(lastname='test3',accountid=acc3.id);
    
    insert c2;
    insert c3;
    insert c4;
    
    Campaign_Member_Report__c acc_test1= new Campaign_Member_Report__c(contact__c=c2.id);
    Campaign_Member_Report__c acc_test2= new Campaign_Member_Report__c(contact__c=c3.id);
    Campaign_Member_Report__c acc_test3= new Campaign_Member_Report__c(contact__c=c4.id);
    
    insert acc_test1;
    insert acc_test2;
    insert acc_test3;
    
    System.debug('___________________'+acc_test1.contact__r.accountid);
    
    CampainMemberReport t= new CampainMemberReport();
    try {
        lst=t.getclassificationsummary(lst);
    } Catch(Exception ex) {}
    //lst=t.getaccountsummary(lst);
    
          
} 

static testMethod void Testopportunitysummary() 
{
    DateTime mydate = system.today().addDays(-2);
    
    Contact c=new Contact(lastname='testcontact');
    insert c;
    
    Opportunity opp = new Opportunity(Name='testopp',CloseDate=system.today(),stagename='stgtstopp',Gift_Date_Time__c = mydate ,Station__c = 'WGBH',Product__c = 'Membership',Campaign_Name__c = 'ANNUAL' );
    insert opp;
    
    Campaign_Member_Report__c cmr = new Campaign_Member_Report__c(contact__c=c.id);    
    
    List<Campaign_Member_Report__c> lst= new List<Campaign_Member_Report__c>(); 
    lst.add(cmr);  
    insert cmr;
    
    CampainMemberReport t= new CampainMemberReport();
    lst=t.getopportunitysummary(lst);
}

static testMethod void Testbiosummary() 
{
    List<Campaign_Member_Report__c> lst= new List<Campaign_Member_Report__c>(); 
  
    Account acct = new Account(Name='TestAcc');
    insert acct;
    contact c = new contact(AccountId = acct.id,Lastname = 'test',FirstName = 'abc');
    insert c;
    
    Bios__c b1 = new Bios__c(Account__c = acct.id,Interest_Count__c = 3,code__c = 'CLASSICL');
    Bios__c b2 = new Bios__c(Interest_Count__c = 4,code__c = 'BLUES');
    Bios__c b3 = new Bios__c(Interest_Count__c = 2,code__c = 'JAZZ');
    Bios__c b4 = new Bios__c(Interest_Count__c = 6,code__c = 'CELTIC');
    Bios__c b5 = new Bios__c(Interest_Count__c = 3,code__c = 'CAPE');
    Bios__c b6 = new Bios__c(Interest_Count__c = 2,code__c = 'HISTORY');
    Bios__c b7 = new Bios__c(Interest_Count__c = 6,code__c = 'EDUCATN');
    Bios__c b8 = new Bios__c(Interest_Count__c = 6,code__c = 'NEWS');
    Bios__c b9 = new Bios__c(Interest_Count__c = 6,code__c = 'SCIENCE');
    
    insert b1;
    insert b2;
    insert b3;
    insert b4;
    insert b5;
    insert b6;
    insert b7;
    insert b8;
    insert b9;
    
    Campaign_Member_Report__c cmr = new Campaign_Member_Report__c(contact__c = c.id,INT_CLASSICAL__c = 'CLASSICL');  
    lst.add(cmr);
    insert cmr;
    
    CampainMemberReport t= new CampainMemberReport();
    //t.getbiosummary(lst);
}

static testMethod void Testcceftaliassummary() 
{
    Date mydate = system.today().addDays(+1);
    
    Contact c=new Contact(lastname='testcontact');
    insert c;
        
    CC_Alias__c cceft = new CC_Alias__c(Expire_Date__c = '2011',GUID__c = '14512',Last_Four_Digits__c = '8854');
    insert cceft;
    Opportunity opp = new Opportunity(Name='testoppcc',stagename='stgtstoppcc',CloseDate = mydate,Station__c = 'WGBH',Product__c = 'Membership',Campaign_Name__c = 'ANNUAL',CC_EFT_Alias__c = cceft.id);
    insert opp;
        
    Campaign_Member_Report__c cmr = new Campaign_Member_Report__c(contact__c = c.id);    
    insert cmr;
    List<Campaign_Member_Report__c> lst= new List<Campaign_Member_Report__c>(); 
    lst.add(cmr);  
    
    CampainMemberReport t = new CampainMemberReport();
    lst=t.getcceftaliassummary(lst);
}

static testMethod void TestgetCampainMember() 
{
    List<Campaign_Member_Report__c> lst= new List<Campaign_Member_Report__c>();  
    
    CampainMemberReport t= new CampainMemberReport();
    lst=t.getCampainMember(lst);
}


}