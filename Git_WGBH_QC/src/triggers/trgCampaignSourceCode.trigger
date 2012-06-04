trigger trgCampaignSourceCode on Campaign (Before Insert, Before Update) {
    CampaignSourceCode clsCampaign = new CampaignSourceCode();
    
    set<ID> sCampId = new set<ID>();
    Set<string> sSourceID= new Set<string>();
    
    for (Campaign c: Trigger.New){
        String SourceCode = '';
        
        String Char1_2_3 = clsCampaign.Char1_2_3(c);
        
        String Char4 = clsCampaign.Char4(c);
        
        String Char5 = clsCampaign.Char5(c);
        
        String Char6 = clsCampaign.Char6(c);
        
        String Char7_8_9_10 = clsCampaign.Char7_8_9_10(c);
        
        String Char11_12 = clsCampaign.Char11_12(c);
        
        String Char13_14_15 = clsCampaign.Char13_14_15(c);
        
        SourceCode = Char1_2_3 + Char4 + Char5 + Char6 + Char7_8_9_10 + Char11_12 + Char13_14_15;
        
        if(Trigger.IsInsert) {
             c.Source_Code__c = SourceCode;
            if(sSourceID.contains(c.Source_Code__c)==false){
                sSourceID.add(c.Source_Code__c);
            }
        } else if(Trigger.isUpdate & SourceCode.length()==15 && SourceCode.Substring(0,12) != trigger.oldMap.get(c.id).Source_Code__c.Substring(0,12)){
            c.Source_Code__c = SourceCode;
            sCampId.add(c.id);
            if(sSourceID.contains(c.Source_Code__c)==false){
                sSourceID.add(c.Source_Code__c);
            }
        }
    }
    System.Debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@sSourceID=' + sSourceID);
    if(sSourceID.Size()==0)
        return;
    //Check duplicate source code.
    List<Campaign> lstCampaign = new List<Campaign>(); 
     if(Trigger.IsInsert) 
        lstCampaign = [select id,name,Source_Code__c from campaign where Source_Code__c IN: sSourceID];
     else 
        lstCampaign = [select id,name,Source_Code__c from campaign where ID NOT IN: sCampId AND Source_Code__c IN: sSourceID];
        
    set<string> sSourceIDExist = new set<string>();
    if(lstCampaign.size()>0){        
        for(Campaign c1: lstCampaign){
            if(sSourceIDExist.contains(c1.Source_Code__c)==false){
                sSourceIDExist.add(c1.Source_Code__c);
            }
        }
    }
    if(sSourceIDExist.Size()>0)
     {
        
        System.Debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@sSourceIDExist=' + sSourceIDExist);
        Integer i=0, j=0;
        Integer N = trigger.new.Size();
        //Set<Integer> sDupCampNo = new Set<Integer>();
        
        set<string> sDupSourceCodes = new set<string>();
        for(Campaign c2 : trigger.new){
            //if(c2.IsActive==true){  
                if(sSourceIDExist.contains(c2.Source_Code__c)==true){          
                    //c2.Source_Code__c.adderror(system.label.Campaignduplicateerror);
                    if(c2.Source_Code__c != null && c2.Source_Code__c.length()==15 && sDupSourceCodes.Contains(c2.Source_Code__c.substring(0,12)) == false) {
                        sDupSourceCodes.Add(c2.Source_Code__c.substring(0,12));
                        //sDupCampNo.Add(i);
                    }
                } else {
                     for(j=0;j<N;j++){               
                        if(i != j && trigger.new[i] == trigger.new[j]){                   
                            //c2.Source_Code__c.adderror(system.label.Campaignduplicateerror);
                            if(c2.Source_Code__c != null && c2.Source_Code__c.length()==15 && sDupSourceCodes.Contains(c2.Source_Code__c.substring(0,12)) == false) {
                                sDupSourceCodes.Add(c2.Source_Code__c.substring(0,12));
                                //sDupCampNo.Add(i);
                            }
                        }
                     }    
                }
                i+=1;
           // }
        }
        System.Debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@sDupSourceCodes=' + sDupSourceCodes);
        if(sDupSourceCodes.Size()>0) {
            List<Campaign> lstCamIncrese = new List<Campaign>();
            if(Trigger.IsInsert)
               lstCamIncrese = [select id,name,Source_Code__c,Source_Code_First12Char__c from campaign where Source_Code_First12Char__c IN: sDupSourceCodes and Source_Code_First12Char__c!=null Order by Source_Code__c DESC];
            else 
               lstCamIncrese = [select id,name,Source_Code__c,Source_Code_First12Char__c from campaign where ID NOT IN: sCampId AND Source_Code_First12Char__c IN: sDupSourceCodes and Source_Code_First12Char__c!=null Order by Source_Code__c DESC];
                      
            //Set<String> sSC12SC3 = new Set<String>();
            Map<String,String> mapSC_SC3 = new Map<String,String>();
            For(Campaign c3: lstCamIncrese ) {
                if(mapSC_SC3.ContainsKey(c3.Source_Code_First12Char__c) == false) { // getting the first max SC.                
                    mapSC_SC3.put(c3.Source_Code_First12Char__c,c3.Source_Code__c.subString(12,15));
                }
            }
            System.Debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1=' + mapSC_SC3);
            if(mapSC_SC3.Size()>0) {                          
                 for(Campaign c4 : Trigger.New){
                     //Campaign c4 = Trigger.New[intC];
                     String strC4SC12 = c4.Source_Code__c.substring(0,12);
                     System.Debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=' + strC4SC12 + '@' + mapSC_SC3);
                     if(mapSC_SC3.containsKey(strC4SC12) == true){
                         string SC3 = mapSC_SC3.get(strC4SC12);
                         SC3 = String.ValueOf(Integer.ValueOf(SC3) + 1);
                         if(SC3 == null || SC3.Length()== 0 || SC3.Length()>3) 
                             break;
                         else if(SC3.Length()== 1) SC3 = '00' + SC3;
                         else if(SC3.Length()== 2) SC3 = '0' + SC3;
                         c4.Source_Code__c = strC4SC12 + SC3 ; // Set Last campaign + 1;                     
                         mapSC_SC3.remove(strC4SC12);
                         mapSC_SC3.put(strC4SC12,SC3);
                         System.Debug('@@@@@=' +mapSC_SC3);
                     }                 
                 }
            }
        }
    }
    //Set Source_Code_First12Char__c field
    for (Campaign c5: Trigger.New){
        if(c5.Source_Code__c != null && c5.Source_Code__c.length()>=12) {
            c5.Source_Code_First12Char__c = c5.Source_Code__c.subString(0,12);
        }
    }

}