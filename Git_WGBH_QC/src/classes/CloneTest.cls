@istest
private class CloneTest {

    static testMethod void testClone() {    
        //Create account test data
        Account myAccount = new Account(name='CloneToolTestAccount');
        
        Insert myAccount;
        //Create contact test data
        Contact myContact1 = new Contact(Lastname = 'Lee', AccountId = myAccount.Id);
        Contact myContact2 = new Contact(Lastname = 'Lee', AccountId = myAccount.Id);
        
        Insert myContact1;
        Insert myContact2;

        PageReference pageRef = new PageReference('Page.Clone');
        Test.setCurrentPage(pageRef); 
            
        ApexPages.currentPage().getParameters().put('ID', myAccount.id);
        
        ClonePage clonePage = new ClonePage();

        List<string> selectObjs = new list<string>();
        selectObjs.add('Contact');
        
        clonePage.getItems();
        
        clonePage.objects = selectObjs;
        
        clonePage.chainClone();
        
        Account clonedAccount = [select Id, Name from Account where Name = 'CloneToolTestAccount' order by CreatedDate desc limit 1];                
        System.assert(myAccount.Id <> clonedAccount.Id && myAccount.Name == clonedAccount.Name);
        
        Integer contactCount = [select count() from contact where AccountID=:clonedAccount.id];                
    }
    
    /*
    static testMethod void testSuperClone() {    
        //Create account test data
        Account myAccount = new Account(name='CloneToolTestAccount');
        
        Insert myAccount;
        //Create contact test data
        Contact myContact1 = new Contact (lastname='Lee', AccountId = myAccount.id);
        Contact myContact2 = new Contact (lastname='Lee', AccountId = myAccount.id);
        
        Insert myContact1;
        Insert myContact2;
        
        List<String> contacts = new list<String>();
        contacts.add('Contact');
   
        Clone myClone = new Clone(String.valueof(myAccount.Id), contacts);
        
        Account clonedAccount = [select Id, Name from Account where Name = 'CloneToolTestAccount' order by CreatedDate desc limit 1];                
        System.assert(myAccount.Id <> clonedAccount.Id && myAccount.Name == clonedAccount.Name);       
    }
    */
}