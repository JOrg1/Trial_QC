public class UploadRecordMatching{

    public static List<sObject> getProperMatching(WGBH_PB5_UPLOAD__c objPB5, String objectName, String MatchingCriteria){
        List<sObject> lstReturn;
        if(MatchingCriteria != null && MatchingCriteria.length()>0){
            List<String> lstMatchingCriteria = new List<String>();
            lstMatchingCriteria = MatchingCriteria.split(';');
            if(lstMatchingCriteria.size()>0){
                for(String s:lstMatchingCriteria){
                    List<sObject> lstTemp = getMatchingRows(objPB5, objectName, s);
                    system.debug('############ Record found for Criteria [ ' + s + ' ] : ' + lstTemp.size());
                    if(lstTemp != null && lstTemp.size() == 1){
                        system.debug('############## one record found ');
                        return lstTemp;
                    }
                    lstReturn = lstTemp;
                }
            }
        }
        return lstReturn;
    }
    public static List<sObject> getMatchingRows(WGBH_PB5_UPLOAD__c objPB5, String objectName, String MatchingCriteria){
        List<sObject> lstReturn = new List<sObject>();
        String matchCondition = '';
        String compare = '';        
        system.debug('##### called for object : ' + objectName);
        sObject sPB5 = (sObject)objPB5;
        system.debug('##############MatchingCriteria : ' + MatchingCriteria);
        if(MatchingCriteria != null && MatchingCriteria.length()>0){        
            List<String> lstMatchingCriteria = new List<String>();
            lstMatchingCriteria = MatchingCriteria.split(';');
            if(lstMatchingCriteria.size()>0){
                for(String s:lstMatchingCriteria){
                    system.debug('######### conditions with ; ---> ' + s);
                    system.debug('######### compare ------> ' + compare);
                    List<String> lstFields = new List<String>();
                    lstFields = s.split(',');
                    if(lstFields != null && lstFields.size()>0){
                        String temp = '';
                        for(String f:lstFields){
                            system.debug('####### conditin with , ---> ' + f);
                            List<String> field = new List<String>();
                            field = f.split('=');
                            system.debug('######## field ' + field);
                            if(field != null && field.size()>0){
                                string compareValue;
                                compareValue = String.valueOf(sPB5.get(field[1]));
                                if (compareValue == null){
                                    compareValue = '';
                                }
                                System.debug('###########Compare value : ' + comparevalue);
                                if(compareValue.trim().length()>0){
                                    //compareValue = '\'' + compareValue + '\'';
                                    compareValue = '\'' + commonApex.setSpecialCharacters(compareValue) + '\'';
                                    
                                    if(Temp.trim().length()==0){
                                        Temp = field[0] + ' = ' + compareValue;
                                    }
                                    else{
                                        Temp += ' AND ' + field[0] + ' = ' + compareValue;
                                    }
                                }
                            }
                        }
                        if(temp.trim().length()>0){
                            if(compare.trim().length()>0){
                                compare += ' OR (' + temp + ')';
                                //compare += ' AND ';
                            }
                            else{
                                compare = '(' + temp + ')';
                            }
                            system.debug('######### compare...... ' + compare);
                        }
                    }
                }
            }
            
            if(compare.trim().length()>0){
                matchCondition = ' Where ' + compare;
                /**** WGBH-72 JIRA 26-Mar-2012 ****/
                /*
                if(objectName.trim().toUpperCase() == 'ACCOUNT'){
                    matchCondition += ' and Non_Giving_Account__c = false ';
                }
                */
                /**** WGBH-72 JIRA 26-Mar-2012 ****/
            }
            /**** WGBH-72 JIRA 26-Mar-2012 ****/
            system.debug('#### QUERY ### ' + 'Select Id, Name From ' + objectName + ' ' + matchCondition);
            String FinalQuery = '';
            if(matchCondition.trim().length()>0)
                if(objectName.trim().toUpperCase() == 'CONTACT'){
                    //lstReturn = Database.query('Select Id, Name, AccountId From ' + objectName + ' ' + matchCondition);
                    FinalQuery = 'Select Id, Name, AccountId From ' + objectName + ' ' + matchCondition;
                    //FinalQuery = commonApex.setSpecialCharacters(FinalQuery);
                    System.debug('============ Final Query ==> ' + FinalQuery);
                    
                    /**** WGBH-72 JIRA 16-Apr-2012 ****/    
                    //lstReturn = Database.query(FinalQuery);
                    List<sObject> lstCon;
                    lstCon = Database.query(FinalQuery);   
                    Map<ID, boolean> mapAcc = new Map<ID, boolean>(); 
                    Set<String> setAccIds = new Set<String>();      
                    if(lstCon != null && lstCon.size()>0){
                        for(sObject Con:lstCon){
                            if(commonApex.NVL(String.valueOf(Con.get('AccountId'))) != ''){
                                setAccIds.add(String.valueOf(Con.get('AccountId')));
                            }
                        }
                    }
                    if(setAccIds != null && setAccIds.size()>0){
                        mapAcc = getNonGivingAccount(setAccIds);
                    }
                    if(mapAcc != null && mapAcc.size()>0){
                        if(lstReturn == null){
                            lstReturn = new List<sObject>();
                        }                    
                        for(sObject Con:lstCon){
                            String accId = commonApex.NVL(String.valueOf(Con.get('AccountId')));
                            System.debug('$$$$$$ Account Id : ' + accId);
                            boolean flagNonGiving = false;
                            if(accId <> '' && mapAcc.containsKey((ID)accId)==true){
                                flagNonGiving = mapAcc.get((ID)accId);
                            }
                            System.debug('$$$$$$$ nonGiving Flag : ' + flagNonGiving);
                            if(flagNonGiving == false){
                                lstReturn.add(Con);
                            }
                        }
                        if(lstReturn == null){
                            lstReturn = new List<sObject>();
                        }
                    }
                    else{
                        lstReturn = lstCon;
                    }
                    /**** WGBH-72 JIRA 16-Apr-2012 ****/
                }
                else{
                    //lstReturn = Database.query('Select Id, Name From ' + objectName + ' ' + matchCondition);
                    FinalQuery = 'Select Id, Name, Non_Giving_Account__c From ' + objectName + ' ' + matchCondition;
                    //FinalQuery = commonApex.setSpecialCharacters(FinalQuery);
                    System.debug('============ Final Query ==> ' + FinalQuery);
                    /**** WGBH-72 JIRA 16-Apr-2012 ****/    
                    List<sObject> lstAcc;
                    lstAcc = Database.query(FinalQuery);                    
                    if(lstAcc != null && lstAcc.size()>0){
                        for(sObject acc:lstAcc){
                            if((boolean)acc.get('Non_Giving_Account__c') == false){
                                lstReturn.add(acc);
                            }
                        }
                    }
                    if(lstReturn == null){
                        lstReturn = new List<sObject>();
                    }
                    /**** WGBH-72 JIRA 16-Apr-2012 ****/
                }
            else{
                lstReturn = new List<sObject>();
            }
                                
        }
        return lstReturn;
    }
    Static Map<ID, boolean> getNonGivingAccount(Set<String> setAccIds){
        List<Account> lstAcc = [Select id, Non_Giving_Account__c from Account where id in:setAccIds];
        Map<ID, boolean> mapAcc = new Map<ID, boolean>();
        if(lstAcc != null && lstAcc.size()>0){
            for(Account acc:lstAcc){
                mapAcc.put(acc.id, acc.Non_Giving_Account__c);
            }
        }
        return mapAcc;
    }
    public static List<sObject> getMatchingRows_old(WGBH_PB5_UPLOAD__c objPB5, String objectName, String MatchingCriteria){
        List<sObject> lstReturn;
        String matchCondition = '';
        String compare = '';        
        system.debug('##### called for object : ' + objectName);
        sObject sPB5 = (sObject)objPB5;
        system.debug('##############MatchingCriteria : ' + MatchingCriteria);
        if(MatchingCriteria != null && MatchingCriteria.length()>0){        
            List<String> lstMatchingCriteria = new List<String>();
            lstMatchingCriteria = MatchingCriteria.split(';');
            if(lstMatchingCriteria.size()>0){
                for(String s:lstMatchingCriteria){
                    List<String> lstFields = new List<String>();
                    lstFields = s.split(',');
                    if(compare.trim().length()>0){
                        compare += ' OR ';
                        //compare += ' AND ';
                    }
                    if(lstFields != null && lstFields.size()>0){
                        String temp = '';
                        for(String f:lstFields){
                            List<String> field = new List<String>();
                            field = f.split('=');
                            if(field != null && field.size()>0){
                                string compareValue = String.valueOf(sPB5.get(field[1]));
                                if (compareValue == null)
                                    compareValue = '';
                                if(compareValue.trim().length()>0){
                                    compareValue = '\'' + compareValue + '\'';
                                    if(Temp.trim().length()==0)
                                        Temp = field[0] + ' = ' + compareValue;
                                    else
                                        Temp += ' AND ' + field[0] + ' = ' + compareValue;
                                }
                            }
                        }
                        if(temp.trim().length()>0)
                            compare += '(' + temp + ')';
                    }
                }
            }
            if(compare.trim().length()>0){
                matchCondition = ' Where ' + compare;
            }
            system.debug('#### QUERY ### ' + 'Select Id, Name From ' + objectName + ' ' + matchCondition);
            if(matchCondition.trim().length()>0)
                lstReturn = Database.query('Select Id, Name From ' + objectName + ' ' + matchCondition);            
            else{
                lstReturn = new List<sObject>();
            }
                                
        }
        return lstReturn;
    }

    private static testMethod void TestUploadRecordMatching() {
        Test.StartTest();
        WGBH_PB5_UPLOAD__c objPB5 = New WGBH_PB5_UPLOAD__c();
        insert objPB5;
        
        UploadRecordMatching clsTest = new UploadRecordMatching();
        UploadRecordMatching.getMatchingRows_old(objPB5, 'WGBH_PB5_UPLOAD__c','Flag_for_Review__c=IS_DUPLICATE__c');
        UploadRecordMatching.getMatchingRows(objPB5, 'WGBH_PB5_UPLOAD__c','Flag_for_Review__c=IS_DUPLICATE__c');
        Test.StopTest();
    }

}