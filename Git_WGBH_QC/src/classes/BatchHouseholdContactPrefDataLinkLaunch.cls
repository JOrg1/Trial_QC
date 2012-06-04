global class BatchHouseholdContactPrefDataLinkLaunch implements Schedulable {
  
    global void execute(SchedulableContext SC) {
      Database.executeBatch(new BatchHouseholdContactPrefDataLink()); 
   }
   
   /*  public static testMethod void testBatchHouseholdContactPrefDataLinkLaunch() {
        Test.StartTest();
       
        BatchHouseholdContactPrefDataLinkLaunch batch = new BatchHouseholdContactPrefDataLinkLaunch();
             
        
        Test.StopTest();

    }*/
    
   public static testMethod void testBatchHouseholdContactPrefDataLinkLaunch() {
        Test.StartTest();
        BatchHouseholdContactPrefDataLink batch = new BatchHouseholdContactPrefDataLink();
        batch.query += ' LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
       BatchHouseholdContactPrefDataLinkLaunch temp= new BatchHouseholdContactPrefDataLinkLaunch ();
        temp.execute(null);
        Test.StopTest();

    }
  
}