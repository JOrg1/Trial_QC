@isTest
Private class TestOnlineEventDetailWs
{ 
        
     static testMethod void getEventByIdTest() 
    {
       string tag = 'abcd';
       string value = 'xyz';
       OnlineEventDetailWs.OnlineEventDetailWs_Result oedres = new OnlineEventDetailWs.OnlineEventDetailWs_Result();  
       String eventName = 'BRW: Test Campaign';
       Campaign testCampaign = new Campaign(
                           Name = 'BRW: Campaign 1', 
                           StartDate = date.parse('01/22/2005'), 
                           EndDate = date.parse('01/21/2006'), 
                           Subject_title__c = 'BRW: Test Campaign',
                           active__c = true
                           );
        
        insert testCampaign;
        
        String eventId = testCampaign.id;

        Campaign selectedCampaign = [SELECT id,description, Event_logo__c, Subject_title__c, Event_Url__c, Start_time_date__c, End_time_date__c,
                                        Ticket_Url__c, Ticket_information__c, Venue_name__c, street_address__c, city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c, 
                                        State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c, Member_Benefit_Discount_Logo__c 
                                        FROM Campaign where active__c=True AND id = :eventId];
        
        System.assertNotEquals(selectedCampaign, null);
        System.assertEquals(selectedCampaign.id, eventId);
        //OnlineEventDetailWs oedws = new OnlineEventDetailWs();
        OnlineEventDetailWs.getEventById(eventId);   
       // OnlineEventDetailWs.createElement(tag,value);                           
        //OnlineEventDetailWs.OnlineEventDetailWs_Result.createElement('test','test');
    }
    
    static testMethod void getEventByCriteriaTest()
    {
        OnlineEventDetailWs.OnlineEventDetailWs_Result oedres = new OnlineEventDetailWs.OnlineEventDetailWs_Result();
        String subject = 'BRW: Test Campaign 2';
        String city    = 'Boston';
        String genre   = 'Test Genre';
        String topic   = 'Test Topic';
        String startDateAndTime = '2010-01-20 18:00:00';//1/20/2011 6:00 PM';
        String endDateAndTime   = '2010-01-22 09:00:00'; //'1/22/2011 9:00 AM';
        boolean feature=true;
        //The String should use the standard date format “yyyy-MM-dd HH:mm:ss” in the local time zone. 
        Campaign testCampaign = new Campaign(
                           Name = 'BRW: Campaign 2',
                           Start_time_date__c =  Datetime.valueOf(startDateAndTime),
                           End_time_date__c = Datetime.valueOf(endDateAndTime),
                           Subject_title__c = subject,
                           Type = topic,
                           city__c = city,
                           Category__c = genre
                           );
        
        insert testCampaign;
        
        String eventId = testCampaign.id;
        
        String queryString = 'SELECT id, description, type, Category__c, Event_logo__c, Subject_title__c, Event_Url__c,'
                                   + 'Start_time_date__c, End_time_date__c, Ticket_Url__c,'
                                   + 'Ticket_information__c, Venue_name__c, street_address__c,'
                                   + 'city__c,Maximum_Capacity__c, Location_Latitude__c, Location_Longitude__c,'
                                   + 'State_province__c, Zip_postalcode__c, Phone__c, Email__c, name__c,'
                                   + 'Member_Benefit_Discount_Logo__c FROM Campaign  ';
                                   
       if ( subject != null && subject.length() > 0 )
       {
            queryString += ' AND Subject_Title__c = \'' + subject + '\'';
       }
       
       if ( topic != null && topic.length() > 0 )
       {
            queryString += ' AND Type = \'' + topic + '\'';
       }
       
       if ( city != null && city.length() > 0 )
       {
            queryString += ' AND City__c = \'' + city + '\'';
       }
       
       if ( genre != null && genre.length() > 0 )
       {
            queryString += ' AND Category__c = \'' + genre + '\'';
       }
        
       if ( startDateAndTime != null && startDateAndTime.length() > 0 )
       {
           //lastRun.lastRun__c.format('yyyy-MM-dd\'T\'HH:mm:ss')
            //Datetime stDateTime = getConvertDateTime(startDateAndTime);
            queryString += ' AND Start_Time_Date__c = ' + startDateAndTime + '';
       }
        
       if ( endDateAndTime != null && endDateAndTime.length() > 0 )
       {
            //DateTime endDateTime = getConvertDateTime(endDateAndTime);
            queryString += ' AND End_Time_Date__c = ' + endDateAndTime + '';
       }
        
        try 
        {
            List<Campaign> resultSet = Database.query(queryString);
            for(Campaign ca:resultSet)
            {
                System.assertEquals( ca.Subject_title__c, subject );
                System.assertEquals( ca.id, eventId );
                System.assertEquals( ca.type, topic );
                System.assertEquals( ca.Category__c, genre );
            }
        }
        catch (Exception ex)
        {
            System.debug(queryString);
        }
        OnlineEventDetailWs.getEventsByCriteria(subject,city,genre,topic,startDateAndTime,endDateAndTime,feature);
        OnlineEventDetailWs.getEvents();
    }
}