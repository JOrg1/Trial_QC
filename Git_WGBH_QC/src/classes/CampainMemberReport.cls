public class CampainMemberReport {
    
    Public List<Campaign_Member_Report__c> getclassificationsummary(List<Campaign_Member_Report__c> lstCampainMember)
    {
        Set<Id> sContactIDs = new Set<Id>();
        for(Campaign_Member_Report__c cmr : lstCampainMember)
        {
            if(sContactIDs.Contains(cmr.Contact__c) == false)
                sContactIDs.Add(cmr.Contact__c);
        }
        List<Classification__c> lstclassification = new List<Classification__c>();
        
        if(Test.IsRunningTest()) {
            lstclassification = [select Preference__c,Preference_Value__c,contact__c  from Classification__c where Station__c='WGBH' and Active__c=true And contact__c In:sContactIDs limit 50];
        }
        else {
            lstclassification = [select Preference__c,Preference_Value__c,contact__c  from Classification__c where Station__c='WGBH' and Active__c=true And contact__c In:sContactIDs];
        }  
      
        for(Campaign_Member_Report__c cmr : lstCampainMember)
        {
            String campaignid = cmr.Campaign__c;
            Sobject tempsobject;
            tempsobject=cmr;
            for(Classification__c temp :lstclassification )
            {
                 if(temp.contact__c==cmr.contact__c)
              {  
                if(temp.Preference__c=='Additional Gift Appeals')
                {
                    tempsobject.put('BC_ADDGIFT_CODE__c',String.valueof(temp.Preference__c));
                    tempsobject.put('BC_ADDGIFT_VALUE__c',String.valueof(temp.Preference_Value__c));
                }
                if(temp.Preference__c=='Renewal Appeals')
                {
                    tempsobject.put('BC_RENEW_CODE__c',String.valueof(temp.Preference__c));
                    tempsobject.put('BC_RENEW_VALUE__c',String.valueof(temp.Preference_Value__c));
                }
                if(temp.Preference__c=='Upgrade Appeals')
                {
                    tempsobject.put('BC_UPGRADE_CODE__c',String.valueof(temp.Preference__c));
                    tempsobject.put('BC_UPGRADE_VALUE__c',String.valueof(temp.Preference_Value__c));
                }
                if(temp.Preference__c=='Best Customer Engagement')
                {
                    tempsobject.put('BC_ENGAGE_CODE__c',String.valueof(temp.Preference__c));
                    tempsobject.put('BC_ENGAGE_VALUE__c',String.valueof(temp.Preference_Value__c));
                    if(temp.Preference_value__c=='Teacher')
                    tempsobject.put('Teacher__c',String.valueof(temp.Preference_Value__c));
                    
                }
                if(temp.Preference__c=='Sustainer Type') 
                    tempsobject.put('SUSTAINER__c',String.valueof(temp.Preference__c));
                if(temp.Preference__c=='Volunteer Type') 
                    tempsobject.put('VOLUNTEER__c',String.valueof(temp.Preference__c));        
            }
           cmr=(Campaign_Member_Report__c)tempsobject;
           }
        }  
        
      
        
        return lstCampainMember; 
    }

    Public List<Campaign_Member_Report__c> getaccountsummary(List<Campaign_Member_Report__c> lstCampainMember)
    {
        String [] postalid1= new String[]{'02188','02189','02190','02191','02714','02538','02719','02738','02739','02346','2745','02746','02740','02744','02558','02770','02748','1772','02571','02790','02791','02747','02743','01899','05501','05544','02021','2025','02043','02045','02050','02040','02041','02044','02047','02051','02059','02060','02065','02185','02783','02061','02066','02067','02072','02184','02020','02018','01775','02269'};
        String [] postalid1_2= new String[] {'02301',   '02302',    '02303',    '02304',    '02305',    '02306',    '02307',    '02308',    '02309',    '02310',    '02311',    '02312',    '02313',    '02314',    '02315',    '02316',    '02317',    '02318',    '02319',    '02320',    '02321',    '02322',    '02323',    '02324',    '02325',    '02326',    '02327',    '02328',    '02329',    '02330',    '02331',    '02332',    '02333',    '02334',    '02335',    '02336',    '02337',    '02338',    '02339',    '02340',    '02341',    '02342',    '02343',    '02344',    '02345',    '02346',    '02347',    '02348',    '02349',    '02350',    '02351',    '02352',    '02353',    '02354',    '02355',    '02356',    '02357',    '02358',    '02359',    '02360',    '02361',    '02362',    '02363',    '02364',    '02365',    '02366',    '02367',    '02368',    '02369',    '02370',    '02371',    '02372',    '02373',    '02374',    '02375',    '02376',    '02377',    '02378',    '02379',    '02380', '02381','02382'};  
        String [] postalid1_3=new String []{'01803',    '01804',    '01805',    '01806',    '01807',    '01808',    '01809',    '01810',    '01811',    '01812',    '01813',    '01814',    '01815',    '01816',    '01817',    '01818',    '01819',    '01820',    '01821',    '01822',    '01823',    '01824',    '01825',    '01826',    '01827',    '01828',    '01829',    '01830',    '01831',    '01832',    '01833',    '01834',    '01835',    '01836',    '01837',    '01838',    '01839',    '01840',    '01841',    '01842',    '01843',    '01844',    '01845',    '01846',    '01847',    '01848',    '01849',    '01850',    '01851',    '01852',    '01853',    '01854',    '01855',    '01856',    '01857',    '01858',    '01859',    '01860',    '01861',    '01862',    '01863',    '01864',    '01865',    '01866',    '01867',    '01868',    '01869',    '01870',    '01871',    '01872',    '01873',    '01874',    '01875',    '01876',    '01877',    '01878',    '01879',    '01880',    '01881',    '01882',    '01883',    '01884',    '01885',    '01886',    '01887',    '01888',    '01889'};
        String [] postalid1_4=new String []{'01901',    '01902',    '01903',    '01904',    '01905',    '01906',    '01907',    '01908',    '01909',    '01910',    '01911',    '01912',    '01913',    '01914',    '01915',    '01916',    '01917',    '01918',    '01919',    '01920',    '01921',    '01922',    '01923',    '01924',    '01925',    '01926',    '01927',    '01928',    '01929',    '01930',    '01931',    '01932',    '01933',    '01934',    '01935',    '01936',    '01937',    '01938',    '01939',    '01940',    '01941',    '01942',    '01943',    '01944',    '01945',    '01946',    '01947',    '01948',    '01949',    '01950',    '01951',    '01952',    '01953',    '01954',    '01955',    '01956',    '01957',    '01958',    '01959',    '01960',    '01961',    '01962',    '01963',    '01964',    '01965',    '01966',    '01967',    '01968',    '01969',    '01970',    '01971',    '01972',    '01973',    '01974',    '01975',    '01976',    '01977',    '01978',    '01979',    '01980',    '01981',    '01982'};

        List<Account> lstaccount= new List<Account>([Select id,Mailing_PostalCode__c from account where (Mailing_PostalCode__c in:postalid1 or Mailing_PostalCode__c in:postalid1_2 or Mailing_PostalCode__c in:postalid1_3 or Mailing_PostalCode__c in:postalid1_4) AND Mailing_PostalCode__c!='02347' limit 10000]);
        
        for(Campaign_Member_Report__c cmr : lstCampainMember)
        {
            String campaignid = cmr.Campaign__c;
            Sobject tempsobject;
            tempsobject=cmr;
            String accountid=cmr.Account_Id__c;
            for(Account temp :lstaccount)
            {   
                if(temp.id==accountid)
                {
                    tempsobject.put('GEO_INSIDE495__c',temp.Mailing_PostalCode__c);
                }
            }
            cmr=(Campaign_Member_Report__c)tempsobject;
        }
        
        
        
        
        String [] postalid2= new String[ ]{'01801','02026','02176','02186','02173','02187','02195','02297','01890','02027','02462','01460','02162','01760','01770','01772','01773','01776','01778','01784','02181','02192','02193','02194','02030'};
        String [] postalid2_2= new String[] {'01701',   '01702',    '01703',    '01704',    '01705',    '01706',    '01707',    '01708',    '01709',    '01710',    '01711',    '01712',    '01713',    '01714',    '01715',    '01716',    '01717',    '01718',    '01719',    '01720',    '01721',    '01722',    '01723',    '01724',    '01725',    '01726',    '01727',    '01728',    '01729',    '01730',    '01731',    '01732',    '01733',    '01734',    '01735',    '01736',    '01737',    '01738',    '01739',    '01740',    '01741',    '01742',    '01743',    '01744',    '01745',    '01746',    '01747',    '01748',    '01749',    '01750',    '01751',    '01752',    '01753',    '01754'};
        String [] postalid2_3= new String[] {'01760',   '01761',    '01762',    '01763',    '01764',    '01765',    '01766',    '01767',    '01768',    '01769',    '01770',    '01771',    '01772',    '01773',    '01774',    '01775',    '01776',    '01777',    '01778'};
        String [] postalid2_4= new String[] {'02480',   '02481',    '02482',    '02483',    '02484',    '02485',    '02486',    '02487',    '02488',    '02489',    '02490',    '02491',    '02492',    '02493',    '02494',    '02495',    '02496',    '02497',    '02498',    '02499'};
        String [] postalid2_5= new String[] {'02100',   '02101',    '02102',    '02103',    '02104',    '02105',    '02106',    '02107',    '02108',    '02109',    '02110',    '02111',    '02112',    '02113',    '02114',    '02115',    '02116',    '02117',    '02118',    '02119',    '02120',    '02121',    '02122',    '02123',    '02124',    '02125',    '02126',    '02127',    '02128',    '02129',    '02130',    '02131',    '02132',    '02133',    '02134',    '02135',    '02136',    '02137',    '02138',    '02139',    '02140',    '02141',    '02142',    '02143',    '02144',    '02145',    '02146',    '02147',    '02148',    '02149',    '02150',    '02151',    '02152',    '02153',    '02154',    '02155',    '02156',    '02157',    '02158',    '02159',    '02160',    '02161',    '02162',    '02163',    '02164',    '02165',    '02166',    '02167',    '02168',    '02169',    '02170',    '02171',    '02172',    '02173',    '02174',    '02175',    '02176',    '02177',    '02178',    '02179'};
        String [] postalid2_6= new String[] {'02196',   '02197',    '02198',    '02199',    '02200',    '02201',    '02202',    '02203',    '02204',    '02205',    '02206',    '02207',    '02208',    '02209',    '02210',    '02211',    '02212',    '02213',    '02214',    '02215',    '02216',    '02217',    '02218',    '02219',    '02220',    '02221',    '02222',    '02223',    '02224',    '02225',    '02226',    '02227',    '02228',    '02229',    '02230',    '02231',    '02232',    '02233',    '02234',    '02235',    '02236',    '02237',    '02238',    '02239',    '02240',    '02241',    '02242',    '02243',    '02244',    '02245',    '02246',    '02247',    '02248',    '02249',    '02250',    '02251',    '02252',    '02253',    '02254',    '02255',    '02256',    '02257',    '02258',    '02259',    '02260',    '02261',    '02262',    '02263',    '02264',    '02265',    '02266',    '02267',    '02268',    '02269',    '02270',    '02271',    '02272',    '02273',    '02274',    '02275',    '02276',    '02277',    '02278',    '02279',    '02280',    '02281',    '02282',    '02283',    '02284',    '02285',    '02286',    '02287',    '02288',    '02289',    '02290',    '02291',    '02292',    '02293',    '02294',    '02295'};
        String [] postalid2_7= new String[] {'02400',   '02401',    '02402',    '02403',    '02404',    '02405',    '02406',    '02407',    '02408',    '02409',    '02410',    '02411',    '02412',    '02413',    '02414',    '02415',    '02416',    '02417',    '02418',    '02419',    '02420',    '02421',    '02422',    '02423',    '02424',    '02425',    '02426',    '02427',    '02428',    '02429',    '02430',    '02431',    '02432',    '02433',    '02434',    '02435',    '02436',    '02437',    '02438',    '02439',    '02440',    '02441',    '02442',    '02443',    '02444',    '02445',    '02446',    '02447',    '02448',    '02449',    '02450',    '02451',    '02452',    '02453',    '02454',    '02455',    '02456',    '02457',    '02458',    '02459',    '02460',    '02461',    '02462',    '02463',    '02464',    '02465',    '02466',    '02467',    '02468',    '02469',    '02470',    '02471',    '02472',    '02473',    '02474',    '02475',    '02476',    '02477',    '02478',    '02479'};
        List<Account> lstaccount2= new List<Account>([Select id,Mailing_PostalCode__c from account where (Mailing_PostalCode__c in:postalid2 or Mailing_PostalCode__c in:postalid2_2 or Mailing_PostalCode__c in:postalid2_3 or Mailing_PostalCode__c in:postalid2_4 or Mailing_PostalCode__c in:postalid2_5 or Mailing_PostalCode__c in:postalid2_6 or Mailing_PostalCode__c in:postalid2_7) and Mailing_PostalCode__c!='02462' and Mailing_PostalCode__c!='01747' limit 5000]);
        
        for(Campaign_Member_Report__c cmr : lstCampainMember)
        {
            String campaignid = cmr.Campaign__c;
            Sobject tempsobject;
            tempsobject=cmr;
            String accountid=cmr.Account_Id__c;
            for(Account temp :lstaccount2)
            {   
                if(temp.id==accountid)
                {
                    tempsobject.put('GEO_INSIDE128__c',temp.Mailing_PostalCode__c);
                }
            }
            cmr=(Campaign_Member_Report__c)tempsobject;
        }
        
        
        
        
        
        
        
        
        String [ ] postalid3=new String[]{'02745','02746','02740','02744','02558','02770','02748','01772','02571','02790','02791','02747','02743','02714','02538','02719','02738','02739','02346'};
        List<Account> lstaccount3= new List<Account>([Select id,Mailing_PostalCode__c from account where Mailing_PostalCode__c in:postalid3]);
        
        for(Campaign_Member_Report__c cmr : lstCampainMember)
        {
            String campaignid = cmr.Campaign__c;
            Sobject tempsobject;
            tempsobject=cmr;
            String accountid=cmr.Account_Id__c;
            for(Account temp :lstaccount3)
            {   
                if(temp.id==accountid)
                {
                    tempsobject.put('GEO_CAPECOD__c',temp.Mailing_PostalCode__c);
                }
            }
            cmr=(Campaign_Member_Report__c)tempsobject;
        }     
  return lstCampainMember;  
    }
    
    
    
    
    
    Public List<Campaign_Member_Report__c> getCampainMember(List<Campaign_Member_Report__c> lstCampMemRpt)
    {
        set<Id> SCampianIds = new Set<Id>();
        Set<Id> SAccountIds = new Set<Id>();
        String RTId;
        
        Map<String,String> mapStr = new Map<String, String>();

        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
        
            SCampianIds.add(cmr.Campaign_Member_Id__c);           
            
        }
        
        //List<CampaignMember> lstCampMem =  [select Id,Contact.Account.SFDC_ACCOUNT_ID__c,Campaign_Member_Report__c from CampaignMember where Id IN :SCampianIds];
       /* for(CampaignMember cm : lstCampMem){
            
             for(Campaign_Member_Report__c cmr : lstCampMemRpt){
        
                  if(cm.Campaign_Member_Report__c == cmr.Campaign_Member_Id__c){
                  
                     // cm.Campaign_Member_Report__r.Account_Id__c = cm.Contact.Account.SFDC_ACCOUNT_ID__c;
                      break;
                  }
                   //Street2
             }
        }*/
        
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
           SAccountIds.add(cmr.Contact__r.Account.Id); 
            mapStr.put(cmr.Id,cmr.Contact__r.Account.Id);
        }
        
        List<RecordType> lstRecordType = [select Id,DeveloperName from RecordType where SObjectType = 'Giving_Summary__c' AND DeveloperName= 'Annual_Giving'];
        if(lstRecordType.size() > 0){
            RTId = lstRecordType[0].Id;
        }
       
        
       List<Giving_Summary__c> lstGivingSummery = [ Select Id,current_mem_yr_renew_amt__c,Station__c,Account__c,Most_Recent_Giving_Amount__c ,expiration_date__c,Total_Member_Yr_Amount__c,total_amt__c,Member_Yr_Status__c,Most_Recent_Giving_Date__c  from Giving_Summary__c where Account__c IN :SAccountIds AND RecordTypeId =: RTId AND Station__c = 'WGBH' AND History__c = false order by Account__c , LastModifiedDate Desc]; 

       
       for(Campaign_Member_Report__c cmr : lstCampMemRpt){ 
       
           string strAccId = mapStr.get(cmr.Id);
           if(strAccId != null){
               for(Giving_Summary__c GS : lstGivingSummery){
                if(GS.Account__c == strAccId){
                
                ////// FOR ASK1__c ///////
                
                Integer ask1for;
                if(GS.current_mem_yr_renew_amt__c != null){
                ask1for = (GS.current_mem_yr_renew_amt__c >= 0 && GS.current_mem_yr_renew_amt__c <= 39.99 ? 50:
                                  (GS.current_mem_yr_renew_amt__c >= 40 && GS.current_mem_yr_renew_amt__c <= 49.99 ? 60 : 
                                  (GS.current_mem_yr_renew_amt__c >= 50 && GS.current_mem_yr_renew_amt__c <= 50.99 ? 75 : 
                                  (GS.current_mem_yr_renew_amt__c >= 51 && GS.current_mem_yr_renew_amt__c <= 99.99 ? 100 : 
                                  (GS.current_mem_yr_renew_amt__c >= 100 && GS.current_mem_yr_renew_amt__c <= 149.99 ? 150 : 
                                  (GS.current_mem_yr_renew_amt__c >= 150 && GS.current_mem_yr_renew_amt__c <= 179.99 ? 200 : 
                                  (GS.current_mem_yr_renew_amt__c >= 180 && GS.current_mem_yr_renew_amt__c <= 249.99 ? 250 : 
                                  (GS.current_mem_yr_renew_amt__c >= 250 && GS.current_mem_yr_renew_amt__c <= 299.99 ? 300 : 
                                  (GS.current_mem_yr_renew_amt__c >= 300 && GS.current_mem_yr_renew_amt__c <= 364.99 ? 365 :
                                  (GS.current_mem_yr_renew_amt__c >= 365 && GS.current_mem_yr_renew_amt__c <= 499.99 ? 500 : 
                                  MATH.ROUND((GS.current_mem_yr_renew_amt__c * 1.25)/5) )))))))))) * 5;
                   
                 cmr.ASK1__c =  ask1for;
                 //System.debug('cmr.ASK1 Id' + cmr.Id);
                 //System.debug('cmr.ASK1__c' + cmr.ASK1__c);
                 ////// FOR ASK2__c ///////
                 Integer ask2For;
                 ask2For =  MATH.ROUND(GS.current_mem_yr_renew_amt__c >= 0 && GS.current_mem_yr_renew_amt__c <= 39.99 ? GS.current_mem_yr_renew_amt__c:
                                  (GS.current_mem_yr_renew_amt__c >= 40 && GS.current_mem_yr_renew_amt__c <= 49.99 ? 50 : 
                                  (GS.current_mem_yr_renew_amt__c >= 50 && GS.current_mem_yr_renew_amt__c <= 50.99 ? 60 : 
                                   GS.current_mem_yr_renew_amt__c )));
                 cmr.ASK2__c =  ask2for;
                 //System.debug('cmr.ASK2 Id' + cmr.Id);
                 //System.debug('cmr.ASK2__c' + cmr.ASK2__c);
                 ////// FOR ASK3__c ///////
                 Integer ask3For;
                 ask3For = MATH.ROUND(GS.current_mem_yr_renew_amt__c >= 0 && GS.current_mem_yr_renew_amt__c <= 39.99 ? 0: 
                                  (GS.current_mem_yr_renew_amt__c >= 40 && GS.current_mem_yr_renew_amt__c <= 49.99 ? GS.current_mem_yr_renew_amt__c : 
                                  (GS.current_mem_yr_renew_amt__c >= 50 && GS.current_mem_yr_renew_amt__c <= 50.99 ? 50 : 
                                  (GS.current_mem_yr_renew_amt__c >= 51 ? 60:
                                  ((GS.current_mem_yr_renew_amt__c * .75)/5) ))))* 5;
                 cmr.ASK3__c =  ask3for;}
                 //System.debug('cmr.ASK3 Id' + cmr.Id);
                 //System.debug('cmr.ASK3__c' + cmr.ASK3__c);
                 ////// FOR ExpirationDate__c ///////
                 if(GS.expiration_date__c != null){
                     Integer GSMonth = GS.expiration_date__c.Month();
                     Integer GSYear = GS.expiration_date__c.Year();
                 String ExpDate =String.ValueOf(GSMonth)+'/'+String.ValueOf(GSYear);
                 cmr.CALLING_EXPIRE__c = ExpDate;
                 cmr.ExpirationDate__c = GS.expiration_date__c;}
                 ////// FOR CUME_GIVING__c ///////
                 cmr.CUME_GIVING__c = GS.total_amt__c;
                 System.debug('cmr.Cume Giving Id' + cmr.Id);
                 System.debug('cmr.CUME_GIVING__c' + cmr.CUME_GIVING__c);
                 ////// FOR LAST_CONTRIBUTION__c ////////
                 Date Today = system.today();
                 if((GS.Member_Yr_Status__c == 'Active' || GS.Member_Yr_Status__c == 'Grace')&& GS.Most_Recent_Giving_Date__c >= System.Today().adddays(-21)){
                     cmr.LAST_CONTRIBUTION__c = GS.Most_Recent_Giving_Amount__c; 
                 }
                 //System.debug('cmr.Last Contribution Id' + cmr.Id);
                 //System.debug('cmr.LAST_CONTRIBUTION__c' + cmr.LAST_CONTRIBUTION__c);
                 ///// FOR CURRENT_GLA__c ///////////
                 
                 cmr.CURRENT_GLA__c = GS.Total_Member_Yr_Amount__c;
                 //System.debug('cmr.CURRENT_GLA__c Id' + cmr.Id);
                 //System.debug('cmr.CURRENT_GLA__c' + cmr.CURRENT_GLA__c);
                 break;
                 }
              }
            }
            }
           List<RecordType> lstRecordType1 = [select Id,DeveloperName from RecordType where SObjectType = 'Giving_Summary__c' AND DeveloperName= 'Auction_Giving'];
                if(lstRecordType1.size() > 0){
                    RTId = lstRecordType1[0].Id;
                    }
             List<Giving_Summary__c> lstGivingSummery1 = [ Select Id,current_mem_yr_renew_amt__c,Station__c,Most_Recent_Giving_Date__c, Account__c,Most_Recent_Giving_Amount__c ,expiration_date__c,Total_Member_Yr_Amount__c  from Giving_Summary__c where Account__c IN :SAccountIds AND RecordTypeId =: RTId AND Station__c = 'WGBH' AND History__c = false order by Account__c , LastModifiedDate Desc]; 
             
              for(Campaign_Member_Report__c cmr : lstCampMemRpt){ 
       
               string strAccId = mapStr.get(cmr.Id);
               if(strAccId != null){
                   for(Giving_Summary__c GS : lstGivingSummery1){
                    if(GS.Account__c == strAccId){
                        
                        Date Today = system.today();
                         if(GS.Most_Recent_Giving_Date__c >=System.Today().adddays(-1095)){
                             cmr.AUCTION_BIDDER__c = GS.Most_Recent_Giving_Amount__c; 
                         }
                         //System.debug('cmr.AUCTION_BIDDER__c Id' + cmr.Id);
                         //System.debug('cmr.AUCTION_BIDDER__c' + cmr.AUCTION_BIDDER__c);
                        break;
                        }
                    }
                }
            }
       
        System.debug('lstCampMemRpt' + lstCampMemRpt);
        return lstCampMemRpt; 
        
    }
    
    
    
    
    public List<Campaign_Member_Report__c> getopportunitysummary(List<Campaign_Member_Report__c> lstCampMemRpt){

        set<Id> SCampianIds = new Set<Id>();
        set<Id> SContactIds = new Set<Id>();
        system.debug('*****Size'+lstCampMemRpt.size());
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
            if(SCampianIds.Contains(cmr.Campaign__c) ==false) {
                SCampianIds.add(cmr.Campaign__c); 
            }
            system.debug('*****cmr.Campaign_Member_Id__c'+cmr.Campaign__c);
            if(SContactIds.Contains(cmr.Contact__c) ==false) {
                SContactIds.add(cmr.Contact__c);
            }
            system.debug('*****cmr.Contact__c'+cmr.Contact__c);
        } 
        Date Mydate = System.Today();
        Date newdate = Mydate.addDays(-365);
        
        List<Opportunity> lstopp = new List<Opportunity>([Select id,Oppty_Related_Contact__c,campaignid,LastModifiedDate,Giving_Segment__c,Gift_Date_Time__c,gift_kind__c,gift_type__c,installment_amount__c,payment_method__c,Giving_Amount__c,Station__c,payment_amount__c from Opportunity where Recurring_Donation_Opportunity__c = NULL And Product__c = 'Membership' And Campaign_Name__c = 'ANNUAL' And Campaignid IN : SCampianIds And Oppty_Related_Contact__c IN : SContactIds  Order by Campaignid,LastModifiedDate Desc]); 
        system.debug('@@@@lstopp'+lstopp.size());
        List<Opportunity> lstopp2 = new List<Opportunity>([Select id,Oppty_Related_Contact__c,campaignid,program__c from Opportunity where  Gift_Date_Time__c >=: newdate And  Station__c = 'WGBH' And Product__c = 'Membership' And Campaign_Name__c = 'ANNUAL' And Campaignid IN:SCampianIds And Oppty_Related_Contact__c IN:SContactIds]);
        system.debug('@@@@lstopp2'+lstopp2.size());
        
        string Cmpid;
        string CmpMemConId;
        Sobject ObjScmr;
        Integer I;
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
        
            if(cmr.id != null)
            {
                system.debug('####cmr.id'+cmr.id);
                for(Opportunity op : lstopp2)
                {
                    if(cmr.Campaign__c  == op.CampaignId)
                    {
                         system.debug('****************'+cmr.campaign__c + '=====' + op.campaignid);
                         cmr.PROGRAM_DESCRIPTION__c = op.program__c;
                    }
                }
            
            
            
                ObjScmr = cmr;
                I=1;
                for(Opportunity o : lstopp)
                {
                    if(cmr.Campaign__c  == o.CampaignId && i<=10)
                    {
                        system.debug('***+++');
                        ObjScmr.put('GIFT_ACTIVITY' + I +'__c' , o.Giving_Segment__c);
                        ObjScmr.put('GIFT_DATE'+ I +'__c', o.Gift_Date_Time__c);  
                        ObjScmr.put('GIFT_KIND' + I +'__c', o.gift_kind__c);
                        ObjScmr.put('GIFT_TYPE' + I +'__c', o.gift_type__c);
                        ObjScmr.put('INS_FREQ' + I +'__c', o.installment_amount__c);
                        ObjScmr.put('PAYMENT_METHOD' + I +'__c', o.payment_method__c);
                        ObjScmr.put('PLEDGE_AMT' + I +'__c', o.Giving_Amount__c);
                        ObjScmr.put('PLEDGE_PAID' + I +'__c', o.payment_amount__c);
                        ObjScmr.put('STATION' + I +'__c', o.Station__c);
                        I = I + 1;    
                    }else{break;}
                    
                }
                cmr = (Campaign_Member_Report__c ) ObjScmr;
            }           
        } 
        
        return lstCampMemRpt;
    }
    
    
    //Function For get CC & EFT ALIAS
    public List<Campaign_Member_Report__c> getcceftaliassummary(List<Campaign_Member_Report__c> lstCampMemRpt){

        //return lstCampMemRpt;
       
         set<Id> SCampianIds = new Set<Id>();
        set<Id> SContactIds = new Set<Id>();
       
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
            if(SCampianIds.Contains(cmr.Campaign__c) ==false) {
                SCampianIds.add(cmr.Campaign__c); 
            }
           
            if(SContactIds.Contains(cmr.Contact__c) ==false) {
                SContactIds.add(cmr.Contact__c);
            }
           
        } 

       List<opportunity> lstoppcc  = new List<opportunity>([select id,CC_EFT_Alias__r.Expire_Date__c,CC_EFT_Alias__r.GUID__c,CC_EFT_Alias__r.Last_Four_Digits__c,campaignid,Oppty_Related_Contact__c from Opportunity
where Product__c = 'Membership' And Campaign_Name__c = 'Annual' And  Station__c = 'WGBH' And  CC_EFT_Alias__c != null And campaignid IN:SCampianIds And Oppty_Related_Contact__c IN:SContactIds order by campaignid,Oppty_Related_Contact__c,LastModifiedDate DESC]);       


        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
            
            If(cmr.Campaign__c != null && cmr.Contact__c!= null)
            {
                for(Opportunity o : lstoppcc)
                {
                   If(cmr.Campaign__c == o.CampaignId && cmr.Contact__c == o.Oppty_Related_Contact__c)
                   {
                       cmr.CC_EXPIRE__c = o.CC_EFT_Alias__r.Expire_Date__c;
                       cmr.CHARGE_CARD_ALIAS__c = o.CC_EFT_Alias__r.GUID__c;
                       cmr.CHARGE_CARD_NUMBER__c = o.CC_EFT_Alias__r.Last_Four_Digits__c;
                       Break;
                   }
                }
            }
        }    
        return lstCampMemRpt;
    }
    
    
    
    //Function For get Bios
    public List<Campaign_Member_Report__c> getbiosummary(List<Campaign_Member_Report__c> lstCampMemRpt){
        
         set<Id> Saccs = new Set<Id>();
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
        
            //if(cmr.Contact__r.accountid != null) {
                Saccs.add(cmr.Contact__r.accountid); 
            //}
        } 
        
        Integer I;
        Sobject ObjScmr;
        
        List<Bios__c> lstbio2;
		if(Test.IsRunningTest()) {       
        	lstbio2 = new List<Bios__c>([Select  id,code__c,Account__c,interest_code__c,Interest_Count__c from Bios__c where Account__c In: Saccs And Interest_Count__c >=  1 order by Interest_Count__c desc limit 50]);
		} else {
        	lstbio2 = new List<Bios__c>([Select  id,code__c,Account__c,interest_code__c,Interest_Count__c from Bios__c where Account__c In: Saccs And Interest_Count__c >=  1 order by Interest_Count__c desc]);
		}
        //List<Bios__c> lstbio = new List<Bios__c>([Select id from Bios__c where code__c = 'CLASSICL' OR code__c = 'BLUES' OR code__c = 'JAZZ' OR code__c = 'RCELTIC' OR code__c = 'CAINAN' OR code__c = 'HISTORY' OR Code__c = 'EDUCATN' OR Code__c = 'CHILDREN' OR Code__c = 'GRCHILD' OR Code__c = 'CONTAINS KIDS' Or Code__c = 'ANTIQUES' Or Code__c = 'ART' Or Code__c = 'BALLROOM' Or Code__c = 'BASEBALL' Or Code__c = 'BSKTBALL' Or Code__c = 'CARS' Or Code__c = 'DOMESTIC' Or Code__c = 'FASHION' Or Code__c = 'FOOD' Or Code__c = 'GARDEN' Or Code__c = 'HERITAGE' Or Code__c = 'HOBBY']);           
        List<Bios__c> lstbio;
        if(Test.IsRunningTest()) {
        	lstbio = new List<Bios__c>([Select id,code__c,Account__c,interest_code__c,Interest_Count__c from Bios__c where Account__c In: Saccs And  code__c != null order by code__c,LastModifiedDate Desc limit 50]);
        } else {
        	lstbio = new List<Bios__c>([Select id,code__c,Account__c,interest_code__c,Interest_Count__c from Bios__c where Account__c In: Saccs And  code__c != null order by code__c,LastModifiedDate Desc]);
        }
        string accid;
        for(Campaign_Member_Report__c cmr : lstCampMemRpt){
            ObjScmr = cmr;
            I = 1;
            accid = cmr.Account_Id__c;
                        
            //if(accid != null)
                //{
                    for(Bios__c b2 : lstbio2)
                    {
                        if(accid == b2.Account__c && I <= 5)
                        {   
                            ObjScmr.put('INTEREST' + I + '__c',b2.interest_code__c);
                            system.debug('*******'+b2.interest_code__c);
                            I = I + 1;
                        }
                        else{break;}
                    }
                    
                
                    for(Bios__c b : lstbio)
                    {
                        if(accid == b.Account__c)
                        {
                            if(b.code__c == 'CLASSICL')
                            {   
                                if(cmr.INT_CLASSICAL__c == null){
                                    cmr.INT_CLASSICAL__c = b.code__c;
                                    cmr.INT_CLASSICAL_HITS__c = b.Interest_Count__c;
                                }
                            }else if(b.code__c == 'BLUES'){
                                if(cmr.INT_BLUES__c == null){
                                    cmr.INT_BLUES__c = b.code__c;
                                    cmr.INT_BLUES_HITS__c = b.Interest_Count__c;
                                }
                            }else if(b.code__c == 'JAZZ'){
                                if(cmr.INT_JAZZ__c == null){
                                    cmr.INT_JAZZ__c= b.code__c;
                                    cmr.INT_JAZZ_HITS__c= b.Interest_Count__c;
                                }
                            }else if(b.code__c == 'CELTIC'){
                                if(cmr.INT_CELTIC__c == null){
                                    cmr.INT_CELTIC__c = b.code__c;
                                    cmr.INT_CELTIC_HITS__c = b.Interest_Count__c;
                                }
                            }else if(b.code__c == 'CAPE'){
                                if(cmr.INT_CAPE__c == null){
                                    cmr.INT_CAPE__c = b.code__c;
                                    cmr.INT_CAPE_HITS__c = b.Interest_Count__c;
                                }
                            }else if(b.code__c == 'HISTORY'){
                                if(cmr.INT_HISTORY__c == null){
                                    cmr.INT_HISTORY__c = b.code__c;
                                    cmr.INT_HISTORY_HITS__c = b.Interest_Count__c;
                                }
                            }
                            
                            else if(b.Code__c =='EDUCATN' || b.Code__c =='CHILDREN' || b.Code__c =='GRCHILD' || b.Code__c =='CONTAINS KIDS')
                            {
                                if(cmr.INT_KIDS__c == null){
                                    cmr.INT_KIDS__c = b.Code__c;
                                    cmr.INT_KIDS_HITS__c = b.Interest_Count__c;
                                }
                            }
                            
                            else if(b.Code__c =='ANTIQUES' || b.Code__c =='ART' || b.Code__c =='BALLROOM' || b.Code__c =='BASEBALL'|| b.Code__c =='BSKTBALL'|| b.Code__c =='CARS'|| b.Code__c =='DOMESTIC'|| b.Code__c =='FASHION'|| b.Code__c =='FOOD'|| b.Code__c =='GARDEN'|| b.Code__c =='HERITAGE'|| b.Code__c =='HOBBY'|| b.Code__c =='NEWAGE'|| b.Code__c =='OUTDOORS'|| b.Code__c =='PHOTO'|| b.Code__c =='SCIFI'|| b.Code__c =='SPIRIT'|| b.Code__c =='TRAVEL'|| b.Code__c =='WINE'|| b.Code__c =='SELFHELP'|| b.Code__c =='COOKING'|| b.Code__c =='HOWTO'|| b.Code__c =='WOODWORK'|| b.Code__c =='WRITING')
                            {
                                if(cmr.INT_LIFELIVE__c == null){
                                    cmr.INT_LIFELIVE__c = b.Code__c;
                                    cmr.INT_LIFELIVE_HITS__c = b.Interest_Count__c;
                                }
                            }
                            
                            else if(b.Code__c =='MUSIC' || b.Code__c =='DRAMA'|| b.Code__c =='BIGBAND'|| b.Code__c =='BRITCOM'|| b.Code__c =='COMEDY'|| b.Code__c =='COUNTRY'|| b.Code__c =='DANCE'|| b.Code__c =='MOVIE'|| b.Code__c =='MUSICALS'|| b.Code__c =='MYSTERY'|| b.Code__c =='PERFORM'|| b.Code__c =='POETRY'|| b.Code__c =='POLKA'|| b.Code__c =='ROCK'|| b.Code__c =='SINGER'|| b.Code__c =='SWING'|| b.Code__c =='THEATRE')
                            {
                                if(cmr.INT_MUSICDRAMA__c == null){
                                    cmr.INT_MUSICDRAMA__c = b.Code__c;
                                    cmr.INT_MUSICDRAMA_HITS__c = b.Interest_Count__c;
                                }
                            }
                            
                            else if(b.Code__c =='NEWS' ||b.Code__c =='BIOGRAPH' ||b.Code__c =='BOSTON' ||b.Code__c =='BUSINESS' ||b.Code__c =='DOCUMENT' ||b.Code__c =='INVEST' ||b.Code__c =='LAW' ||b.Code__c =='MIDEAST' ||b.Code__c =='MILITARY' ||b.Code__c =='POLITICS' ||b.Code__c =='NUKES' ||b.Code__c =='PRESIDEN' ||b.Code__c =='RACE' ||b.Code__c =='USA' ||b.Code__c =='VETERANS' ||b.Code__c =='WAR')
                            {
                                if(cmr.INT_NEWS__c == null){
                                        cmr.INT_NEWS__c = b.Code__c;
                                        cmr.INT_NEWS_HITS__c = b.Interest_Count__c;
                                    }
                            }
                            
                            else if(b.Code__c =='SCIENCE' ||b.Code__c =='NATURE' ||b.Code__c =='SPACE' ||b.Code__c =='ANIMAL' ||b.Code__c =='BIRDS' ||b.Code__c =='COMPUTER' ||b.Code__c =='ENVIRON' ||b.Code__c =='OCEAN' ||b.Code__c =='PREHIST' ||b.Code__c =='PSYCH' ||b.Code__c =='SEX' ||b.Code__c =='TECH' ||b.Code__c =='HEALTH')
                            {
                                if(cmr.INT_SCIENCE__c == null){
                                        cmr.INT_SCIENCE__c = b.Code__c;
                                        cmr.INT_SCIENCE_HITS__c = b.Interest_Count__c;
                                    }
                            }
                            
                        }
                    }
                //}
         }
        return lstCampMemRpt;
    }    
    
    
   
}