trigger NewEmployee on Job_Application__c (after update) {
//MODIFIED BY BRW 1/18/2010
    Job_Application__c[] newja = Trigger.new;
    Job_Application__c[] oldja = Trigger.old;
   
    if(newja[0].Picklist__c != oldja[0].Picklist__c && newja[0].Picklist__c == 'Hired')
    {
     
        List<position__c> pos = [SELECT id,
                                    name,
                                    Billing_Account_Category__c,
                                    Departments__r.Process_Level__c,
                                    Departments__r.Department_Code__c,
                                    Department_Process_Level__c,
                                    Supervisor_Name__r.Code__c,
                                    WGBH_Accounting_Unit__c,
                                    Position_Title__r.code__c,
                                    Person_who_issues_paychecks_to_thishire__r.code__c,
                                    Building_Location_Code__c,
                                    Billing_Activity_Code__c
                                    FROM Position__C
                                    WHERE id =: newja[0].Position__c];
         
         System.debug('##pos--> '+ pos);  
         System.debug('##newja[0].Candidate__c--> ' + newja[0].Candidate__c);
                                 
        List<Candidate__c> can = [SELECT id,
                                    name,
                                    First_Name__c,
                                    last_Name__c,
                                    Veteran_information__c,
                                    Handicapped__c,
                                    gender__c,
                                    EEO_Diversity__c,
                                    phone__c,
                                    Current_employee_of_WGBH__c,
                                    Previously_employed_at_WGBH__c,
                                    Previous_WGBH_employee_ID__c,
                                    Street_Address1__c,
                                    Street_Address2__c,
                                    City__c,
                                    State_lkp__r.code__c,
                                    Zip_Postal_Code__c,
                                    Country_lkp__r.code__c,
                                    Salary_Hired__c
                                    FROM Candidate__c
                                    WHERE id=: newja[0].Candidate__c]; 
                                    
         System.debug('## can[0].EEO_Diversity__c---> ' + can[0].EEO_Diversity__c);
                                      
        System.debug('##can--> '+ can);
        
        //set the EEOClass                     
            String eeoClass = null;
            
        /**********======Condition to avoid null pointer exception ======== */    
        if(can[0].EEO_Diversity__c != null)
        {
        	System.debug('##in if--> ');
        	
        /********==================================*/
            if (can[0].EEO_Diversity__c == 'Hispanic or Latino')
            {
                eeoClass = 'HI';
            }
            else if (can[0].EEO_Diversity__c == 'American Indian or Alaskan Native (Not Hispanic or Latino)')
            {
                eeoClass = 'AN';
            }
            else if (can[0].EEO_Diversity__c == 'Black or African American (Not Hispanic or Latino)')
            {
                eeoClass = 'B';
            }
            else if (can[0].EEO_Diversity__c == 'Asian (Not Hispanic or Latino)')
            {
                eeoClass = 'AS';
            }
            else if (can[0].EEO_Diversity__c == 'Native Hawaiian or Other Pacific Islander (Not Hispanic or Latino)')
            {
                eeoClass = 'NH';
            }
            else if (can[0].EEO_Diversity__c == 'White (Not Hispanic or Latino)')
            {
                eeoClass = 'WH';
            }
            else
            {
                eeoClass = null;
            }
        /**********======Condition to avoid null pointer exception ======== */
        }
        else
        {
        	System.debug('##in else--> ');
            eeoClass = null;
        }
        /********==================================*/
           
        Lawson_Employee__c emp  =  new Lawson_Employee__c();
        emp.EmpFc__c       = (can[0].Current_employee_of_WGBH__c || can[0].Previously_employed_at_WGBH__c == 'Yes') ? 'C' : 'A';
        System.debug('## 1');
        emp.EmpCompany__c  = '0100';
        emp.EmpEmployee__c = (can[0].Current_employee_of_WGBH__c || can[0].Previously_employed_at_WGBH__c == 'Yes') ? can[0].Previous_WGBH_employee_ID__c : null;
        System.debug('## 2');
        emp.last_name__c   = can[0].last_name__c;
        System.debug('## 3');
        emp.first_name__c  = can[0].first_name__c;
        System.debug('## 4');
        emp.Street_Address1__c = can[0].Street_Address1__c;
        System.debug('## 5');
        emp.Street_Address2__c = can[0].Street_Address2__c;
        System.debug('## 6');
        emp.Street_Address_3__c = null;
        emp.Street_Address_4__c = null;
        emp.City__c = can[0].City__c;
        System.debug('## 7');
        emp.State_Province__c = can[0].State_lkp__r.code__c;
        System.debug('## 8');
        emp.Zip_Postal_Code__c = can[0].Zip_Postal_Code__c;
        System.debug('## 9');
        emp.EmpCountryCode__c  = can[0].Country_lkp__r.code__c;
        System.debug('## 10');
        emp.EmpStatus__c = 'A';
        //DATA ENTERED
        //emp.EmpFicaNbr__c = '';
        emp.EmpProcessLevel__c = pos[0].Departments__r.Process_Level__c;
        emp.EmpDepartment__c = pos[0].Departments__r.Department_Code__c;
        System.debug('## 11');
        emp.EmpHmDistCo__c = (pos[0].Department_Process_Level__c == 'WGBY') ? '0157' : '0100';
        System.debug('## 12');
        emp.Accounting_Unit__c = pos[0].WGBH_Accounting_Unit__c;
        emp.EmpHmAccount__c = '701010';
        emp.EmpHmSubAcct__c = '0000';
        emp.EmpSupervisor__c = pos[0].Supervisor_Name__r.Code__c;
        System.debug('## 13');
        emp.Billing_Activity_Code__c = pos[0].Billing_Activity_Code__c;
        System.debug('## 14');
        emp.EmpUnionCode__c = pos[0].Position_Title__r.code__c.substring(0,1);
        System.debug('## 15');
        emp.EmpUserLevel__c = pos[0].Person_who_issues_paychecks_to_thishire__r.code__c;
        System.debug('## 16');
        emp.EmpDateHired__c =  System.now().format('yyyymmdd');
        emp.EmpAdjHireDate__c = (can[0].Current_employee_of_WGBH__c || can[0].Previously_employed_at_WGBH__c == 'Yes') ? null : System.now().format('yyyymmdd');
        System.debug('## 17');
        emp.EmpJobCode__c = pos[0].Position_Title__r.code__c;
         System.debug('## 18');
        emp.EmpNbrFte__c = null;//TODO SET
        emp.EmpSalaryClass__c = 'H';
        System.debug('## newja[0].Final_Salary__c-->' + newja[0].Final_Salary__c);
        
        if(newja[0].Final_Salary__c != null)
        	emp.EmpPayRate__c = (newja[0].Final_Salary__c/26)/80;
        else
        	emp.EmpPayRate__c = 0;
        	
        System.debug('## 19');
        emp.EmpPayFrequency__c = '2';
        emp.EmpOtPlanCode__c = 'BW';
        emp.PemHmPhoneNbr__c = can[0].Phone__c;
        emp.EEO_Diversity__c = eeoClass;
        emp.Gender__c = (can[0].gender__c == 'Male') ? 'M' : 'F';
        emp.Handicapped__c = (can[0].Handicapped__c == 'Yes') ? 'Y' : 'N';
        emp.Veteran_information__c = (can[0].Veteran_information__c != null && (can[0].Veteran_information__c != 'Decline to identify' || can[0].Veteran_information__c != 'Not a Veteran')) ? 'Y' :'N';
        //DATA ENTERED
        //emp.Birth_Date__c = '';
        emp.Location__c = pos[0].Building_Location_Code__c;
        emp.Billing_Account_Category__c = pos[0].Billing_Account_Category__c;
        emp.PemBenDateA__c = (can[0].Current_employee_of_WGBH__c || can[0].Previously_employed_at_WGBH__c == 'Yes') ? null : System.now().format('yyyymmdd');
        emp.PepPosLevel__c = '1';
        emp.PepEffectDate__c = System.now().format('yyyymmdd');
        emp.EmpWorkSched__c = newja[0].Work_Schedule__c;//TODO SET WORK SCHEDULE
        emp.EmpAnnualHours__c = '2080';
       
       System.debug('##emp--> '+ emp);
       
        try
        {
            insert emp;
        }
        catch(exception e)
        {
            throw e;
        }
       
   
    }
 
 
}