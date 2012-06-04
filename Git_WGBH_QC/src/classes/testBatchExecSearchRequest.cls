@istest
Private class testBatchExecSearchRequest
{
    Static testMethod void testBatchCampaignMemberSch()
    {
      ID i='a1bQ0000000KsWC';
      String RequestedBy = '';
      List<Search_Request__c> lstRequest = [Select CreatedById From Search_Request__c Where Id='003Q000000OWEP5'];
      if(lstRequest != null && lstRequest.size()>0)
      RequestedBy = lstRequest[0].CreatedById;
       String Query = 'Select Id, FieldName__c, Index__c, Query__c, Request__c, Status__c, Campaign__c, CreatedById From Requested_Search__c ';
      //Query += 'Where Request__c =\'003Q000000OWEP5\' and Status__c = \'Pending\' Order by Index__c Limit 1';
     //Query += 'Where Request__c =\'a1bQ0000000KsWHIA0\' limit 10 ';
     Query += 'Where Status__c=\'pending\' limit 10 ';
        
      BatchExecSearchRequest b =new BatchExecSearchRequest(Query ,i,true,'701Q00000006iKV',RequestedBy);
     // BatchExecSearchRequest b1 =new BatchExecSearchRequest(Query ,i,false,'701Q00000006iKV',RequestedBy);
      List<sObject> scope= database.query(query);
      
      ID  batchprocessid = Database.executeBatch(b, 1);
      b.execute(null,scope);
      b.finish(null);
     
      //b1.SearchResult1(scope);
   
      
      
      
      
      
}
}