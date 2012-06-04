@IsTest
private class TestRemoveSeasonalAddress {
    public static testmethod void TestRemoveSeasonalAddress (){
        Test.startTest();

       RemoveseasonalAddress RSA = new RemoveseasonalAddress ();
       
      
       Account acc = new Account(Name = 'AccountTest123',BillingStreet = 'baccteststreet',BillingCity = 'bacctestcity',BillingState = 'baccteststate',BillingCountry = 'tb',ShippingStreet = 'saccteststreet',ShippingCity = 'sacctestcity',ShippingState = 'saccteststate',ShippingCountry = 'ts');
       insert acc;
       
        Date MyDate = System.today();
        integer month = MyDate.Month();
        integer day = MyDate.Day();
        integer day1 = day + 15;
        
        String StartMonth = String.ValueOf(month);
        String StartDate = String.ValueOf(day);
        String StartDate1 = String.ValueOf(day1);
        String FinalDate = StartMonth+'/'+StartDate;
        String FinalDate1 = StartMonth+'/'+StartDate1;
      
       
       Address__c adr = new Address__c();
       adr.Name = '123 Test, XYZ, PQR - 124569';
       adr.Account_Household__c = acc.id;
       adr.Address_Type__c = 'Seasonal' ;
       adr.PreferredAddress__c = true;
       adr.Seasonal_End_Date__c = '11/15';
       adr.Street_1__c = 'Test';
       insert adr;
       
       Address__c adrs = new Address__c();
       adrs.Name = '123 Test, XYZ, PQR - 124569';
       adrs.Account_Household__c = acc.id;
       adrs.Address_Type__c = 'Shipping' ;
       adrs.PreferredAddress__c = true;
       adrs.Street_1__c = 'Test';
       adrs.Seasonal_End_Date__c = '11/15';
       insert adrs;
       
       Address__c adrB = new Address__c();
       adrB.Name = '123 Test, XYZ, PQR - 124569';
       adrB.Account_Household__c = acc.id;
       adrB.Address_Type__c = 'Billing' ;
       adrB.PreferredAddress__c = true;
       adrB.Street_1__c = 'Test';
       adrB.Seasonal_End_Date__c = '11/15';
       insert adrB;
       
       Address__c adrH = new Address__c();
       adrH.Name = '123 Test, XYZ, PQR - 124569';
       adrH.Account_Household__c = acc.id;
       adrH.Address_Type__c = 'Home' ;
       adrH.PreferredAddress__c = true;
       adrH.Street_1__c = 'Test';
       adrH.Seasonal_End_Date__c = '11/15';
       insert adrH;
       
       //List<Address__c> lstA = [Select id,Name,Account_Household__r.Id,PreferredAddress__c,Address_Type__c,Account_Household__c,Street_1__c,City__c,State__c,Country__c,Postal_Code__c,Seasonal_End_Date__c from Address__c where Seasonal_End_Date__c >: FinalDate And Account_Household__c = '001K000000898e6'];
      
       //RemoveseasonalAddress RSAList = new RemoveseasonalAddress (lstA);
       
       List<Address__c> lstAdd = new List<Address__c>();
       lstAdd.add(adr);
       RemoveseasonalAddress RSAa = new RemoveseasonalAddress(lstAdd);
       
       List<Address__c> lstA = new List<Address__c>();
       lstA.add(adrs);
       RemoveseasonalAddress RSAS = new RemoveseasonalAddress (lstA);
       
       List<Address__c> lstB = new List<Address__c>();
       lstB.add(adrB);
       RemoveseasonalAddress RSAB = new RemoveseasonalAddress (lstB);
       
       List<Address__c> ListAdrH= new List<Address__c>();
       ListAdrH.add(adrH);
       RemoveseasonalAddress RSAH = new RemoveseasonalAddress (ListAdrH);
       
       Test.stopTest();
    }
}