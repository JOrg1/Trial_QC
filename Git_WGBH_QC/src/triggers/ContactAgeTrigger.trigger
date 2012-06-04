trigger ContactAgeTrigger on Contact (before insert, before update) {
    for(Contact c: trigger.new) {
        Integer Birthdate_Day = 1;
        Integer Birthdate_Month = 1;
        Integer Birthdate_Year = null;
        
        if (c.Birth_Day__c != null)
            Birthdate_Day = c.Birth_Day__c.intValue();  
        if (c.Birth_Month__c != null)
            Birthdate_Month = c.Birth_Month__c.intValue();       
        if (c.Birth_Year__c != '' && c.Birth_Year__c != null)
            Birthdate_Year = Integer.valueOf(c.Birth_Year__c);
        
        if (Birthdate_Year == null) {
            c.age_range__c = null;
        } else {
            Date Todaydate = system.today();            
            Date ToDate = date.newInstance(Todaydate.year(), Todaydate.month(), Todaydate.day());
            Date FromDate =  date.newInstance(Birthdate_year, Birthdate_month, Birthdate_Day);
            
            Integer numberDaysDue = FromDate.daysBetween(ToDate);
            Decimal AgeCount = math.floor(numberDaysDue/365.2425);
            
            if (AgeCount < 12) {
                c.age_range__c = 'None';
            } else if (AgeCount >= 12 && AgeCount <= 17) {
               c.age_range__c = '12-17'; 
            } else if (AgeCount >= 18 && AgeCount <= 24) {
               c.age_range__c = '18-24'; 
            } else if (AgeCount >= 25 && AgeCount <= 29) {
               c.age_range__c = '25-29'; 
            } else if (AgeCount >= 30 && AgeCount <= 34) {
               c.age_range__c = '30-34'; 
            } else if (AgeCount >= 35 && AgeCount <= 39) {
               c.age_range__c = '35-39'; 
            } else if (AgeCount >= 40 && AgeCount <= 44) {
               c.age_range__c = '40-44'; 
            } else if (AgeCount >= 45 && AgeCount <= 49) {
               c.age_range__c = '45-49'; 
            } else if (AgeCount >= 50 && AgeCount <= 54) {
               c.age_range__c = '50-54'; 
            } else if (AgeCount >= 55 && AgeCount <= 59) {
               c.age_range__c = '55-59'; 
            } else if (AgeCount >= 60 && AgeCount <= 64) {
               c.age_range__c = '60-64'; 
            } else if (AgeCount >= 65 && AgeCount <= 74) {
               c.age_range__c = '65-74'; 
            } else if (AgeCount >= 75) {
               c.age_range__c = '75+'; 
            } else {
               c.age_range__c = 'None';
            }
        }     
    }
}