global class scheduledExtendCCDate implements Schedulable{

   global void execute(SchedulableContext sc) {
      
      ExtendCCDate_Batch.ExtendCCDate_Batch();      
      
   }
   static testmethod void testscheduledExtendCCDate() {
       scheduledExtendCCDate objscExccdate = new scheduledExtendCCDate();
       objscExccdate.execute(null);
   }
   
   
}