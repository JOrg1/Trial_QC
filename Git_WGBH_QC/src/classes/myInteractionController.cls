public class myInteractionController 
{     public myInteractionController(ApexPages.StandardSetController controller) 
      {    
      
      }    
      Interaction__c interaction;    
      Account account;    
      Contact contact;        
      public Account getAccount() 
       {        
         if(account == null) account = new Account();        
         return account;    
       }    
      public Contact getContact() 
       {        
            if(contact == null) contact = new Contact();       
            return contact;    
       }    
      public Interaction__c getInteraction() 
       {        
             if(interaction == null) interaction = new Interaction__c();       
             return interaction;    
       }        
      public PageReference cancel() 
       {        
              PageReference ContactPage = new PageReference('/' + ApexPages.currentPage().getParameters().get('id')); 
              ContactPage.setRedirect(true);       
              return ContactPage;    
       }        
      public PageReference save() 
       {        
               insert interaction;                
               Interactions__c interactions = new Interactions__c();        
               interactions.Proposals_Pledges__c = ApexPages.currentPage().getParameters().get('id');        
               interactions.Interaction__c = interaction.id;        
               insert interactions;                
               //PageReference ContactPage = new ApexPages.StandardController(contact).view();        
               PageReference ContactPage = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));        
               ContactPage.setRedirect(true);        
               return ContactPage;    
        }
    public static testMethod void testMyInteractionController() {
    	ApexPages.StandardSetController controller = null;
    	myInteractionController nic = new myInteractionController(controller);
    	Contact contact = nic.getContact();
    	System.assert(contact!=null);
    	Account account = nic.getAccount();
    	System.assert(account!=null); 
    	Interaction__c inter = nic.getInteraction();
    	System.assert(inter!=null);    	    	   	
    }        
}