@istest
Private class testPopulateseasonalAddress {

    static testMethod void testPopulateseasonalAddress() {


        Date MyDate = System.today();
        integer month = MyDate.Month();
        integer day = MyDate.Day();    
        String StartMonth = String.ValueOf(month);
        String StartDate = String.ValueOf(day);
        String FinalDate = StartMonth+'/'+StartDate;
        
        Account a= new Account(name='test',AccountType__c='Household');
        insert a;
        List<Address__c> lstadd= new List<Address__c>();
        Address__c temp =new Address__c();
        
       
        temp.name='testname';
        temp.PreferredAddress__c=True;
        temp.Account_Household__c=a.id;
        temp.Address_Type__c='Seasonal';
        temp.Seasonal_Start_Date__c = FinalDate;
  
        temp.City__c='temp city';
        temp.State__c='temp state';
        temp.Street_1__c='temp street1';
        temp.Street_2__c='temp street2';
        temp.Postal_Code__c='02772';
        temp.Address_Create_Date__c=MyDate ;
        temp.Address_Status__c='Active';
        temp.Country__c='IND';
        insert temp;
        lstadd.add(temp);
        PopulateseasonalAddress p= new PopulateseasonalAddress();
        PopulateseasonalAddress p1= new PopulateseasonalAddress(lstadd);
    }
}