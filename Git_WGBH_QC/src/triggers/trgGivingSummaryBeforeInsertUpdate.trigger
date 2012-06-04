trigger trgGivingSummaryBeforeInsertUpdate on Giving_Summary__c (Before Insert, Before Update) {
    Set<ID> AccIDs = new Set<ID>();
    Set<ID> NoMajorDonnerAccID = new Set<ID>();
    List<RecordType> lstRc = [Select id from RecordType where DeveloperName=:'Annual_Giving'];
    String recordTypeId = '';
    if(lstRc.size()>0){
        recordTypeId = lstRc[0].Id;
    }
    integer i = 0;
    for(Giving_Summary__c g: Trigger.new) {
        system.debug('####### Giving sumary after update : History : ' + g.history__c + ' Summary ---> ' + g.name);
        
        /**===============Jira Tkt No.78 ==============*/
             system.debug('## g.expiration_date__c ==>' +g.expiration_date__c);
        /**============================================*/
        
        if(g.expiration_date__c!=null) {
            //g.Grace_Date__c = date.newInstance(g.expiration_date__c.month()<12?g.expiration_date__c.year():g.expiration_date__c.year()+1,g.expiration_date__c.month()+1,1);
            //g.Grace_Date__c = date.newInstance(g.expiration_date__c.month()<12?g.expiration_date__c.year():g.expiration_date__c.year()+1,g.expiration_date__c.month()<12?g.expiration_date__c.month()+1:1,1);
            g.Grace_Date__c = g.expiration_date__c.addMonths(1).addDays(1-g.expiration_date__c.day());
        }
        
        /**===============Jira Tkt No.78 ==============*/
             system.debug('##g.Grace_Date__c ==>' +g.Grace_Date__c);
        /**============================================*/
        
        if(g.Grace_Date__c!=null) {
            Date LapsedDate = g.Grace_Date__c.addMonths(1);
            if(g.Lapsed_Period__c!=null) {
                LapsedDate = g.Grace_Date__c.addMonths(g.Lapsed_Period__c.intValue());
            }
            g.Lapsed_Date__c = LapsedDate;
        }
        
         /**===============Jira Tkt No.78 ==============*/
             system.debug('## g.Lapsed_Date__c ==>' + g.Lapsed_Date__c);
        /**============================================*/
        
        if(g.Grace_Date__c!=null) {
            if(g.Grace_Date__c<=system.today()) g.Member_Yr_Status__c = 'Grace';
        }
        if(g.Lapsed_Date__c!=null) {
            if(g.Lapsed_Date__c<=system.today()) g.Member_Yr_Status__c = 'Lapsed';            
        }
            
        
        if(Trigger.IsUpdate) {
            if(Trigger.old[i].IsGrace__c==false && g.IsGrace__c==true) g.Member_Yr_Status__c = 'Grace';
        }
        
        /**===============Jira Tkt No.78 ==============*/
             system.debug('## g.Member_Yr_Status__c ==>' + g.Member_Yr_Status__c);
        /**============================================*/
        
        if(g.Member_Yr_Status__c!='Grace') g.IsGrace__c = false;
        /**** WGBH-70 (JIRA) 21-Mar-2012 ****/
        //if(g.Giving_Level__c!='Major Donor' && NoMajorDonnerAccID.contains(g.Account__c)==false) {
        //    NoMajorDonnerAccID.add(g.Account__c);
        //}
        /**** WGBH-70 (JIRA) 21-Mar-2012 ****/
        
        if(g.Shopper_Count__c == 3) g.Shopper__c = true;
        
        if(g.recordTypeId == recordTypeId && g.Giving_Level__c=='Major Donor' && AccIDs.contains(g.Account__c)==false) {
            AccIDs.add(g.Account__c);
        }
        i++;
    }
    
    Map<ID,Account> mapAcc = New Map<ID,Account>([Select ID,WCAI_Major_Donor_Flag__c,WGBH_Major_Donor_flag__c,WGBY_Major_Donor_Flag__c from Account where ID In: AccIDs]);

    for(Giving_Summary__c g1: Trigger.new) {
        if(mapAcc.containsKey(g1.Account__c)) {
            Account a = mapAcc.get(g1.Account__c);
            
            if(g1.Station__c == 'WCAI') {
                a.WCAI_Major_Donor_Flag__c = true;
            }
            if(g1.Station__c == 'WGBH') {
                a.WGBH_Major_Donor_Flag__c = true;
            }
            if(g1.Station__c == 'WGBY') {
                a.WGBY_Major_Donor_Flag__c = true;
            }                        
        }
    }
    /**** WGBH-70 (JIRA) 21-Mar-2012 ****/
    /*
    Map<ID,Account> mapAccNoMajorDonor = New Map<ID,Account>([Select ID,WCAI_Major_Donor_Flag__c,WGBH_Major_Donor_flag__c,WGBY_Major_Donor_Flag__c from Account where ID In: NoMajorDonnerAccID]);

    for(Giving_Summary__c g1: Trigger.new) {
        if(mapAccNoMajorDonor.containsKey(g1.Account__c)) {
            Account a = mapAccNoMajorDonor.get(g1.Account__c);
            
            if(g1.Station__c == 'WCAI') {
                a.WCAI_Major_Donor_Flag__c = false;
            }
            if(g1.Station__c == 'WGBH') {
                a.WGBH_Major_Donor_Flag__c = false;
            }
            if(g1.Station__c == 'WGBY') {
                a.WGBY_Major_Donor_Flag__c = false;
            }                        
        }
    }

    List<Account> lstAccNoMajorDonor = mapAccNoMajorDonor.values();
    
    if(lstAccNoMajorDonor.size()>0) update lstAccNoMajorDonor;
    */
    /**** WGBH-70 (JIRA) 21-Mar-2012 ****/
    
    List<Account> lstAcc = mapAcc.values();
    
    if(lstAcc.size()>0) update lstAcc;

}