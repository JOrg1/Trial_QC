public with sharing class HouseholdExtension {
    private final Account household;
    public HouseholdExtension(ApexPages.StandardController stdController) {
        this.household = (Account)stdController.getRecord();
    }
    public String getLastTransactionDate() {
        return Households.getHouseholdLastTransactionDate(household.ID);
    }
    public String getHouseholdTransactionTotal() {
        return Households.getHouseholdTransactionAmount(household.ID);
    }
    
    static testMethod void TestHouseholdExtension() {
       Test.startTest();
       //HouseholdExtension houseE = new HouseholdExtension();
     
       Account a = new Account(Name = 'Test Account');
       insert a;
       Contact c = new Contact(LastName = 'Last Names', Account_Household__c = a.Id);   
       insert c;   
              
        Apexpages.StandardController stdController = new Apexpages.StandardController(a); 
        
       
        HouseholdExtension houseE = new HouseholdExtension (StdController);
        
        try{
            houseE.getLastTransactionDate();
            houseE.getHouseholdTransactionTotal();
        } catch (exception e){
        }
       
       Test.StopTest();
    }   
        
}