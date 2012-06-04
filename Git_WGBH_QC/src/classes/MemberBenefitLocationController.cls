/**
 * This controller is for overriding the (New) button on the MemberBenefirLocation
 * Junction Object
 */
public class MemberBenefitLocationController {
    private ApexPages.StandardController controller;
    public MemberBenefitLocationController(ApexPages.StandardController controller) {
        this.controller = controller;
        Initialize();
    }
    public MemberBenefitLocationController() {
        Initialize();
    }
    
    //*************************************************************************
    // Google Map Page Logic starts
    public Member_benefit_Location__c[] memberBenefitLocations {get; set;}
    
    public MemberBenefitLocationController(ApexPages.StandardSetController controller) {
        String categoryWhereClause = ApexPages.currentPage().getParameters().get('includes');
        
        String memberBenefitLocationsQuery = 
            'Select m.Member_Benefit__r.Benefit_Link__c, m.Member_Benefit__r.Name, m.Location__r.Longitude__c, m.Location__r.Latitude__c ' + 
            'From Member_benefit_Location__c m';
        
        if(categoryWhereClause != null) {
            memberBenefitLocationsQuery += ' Where m.Member_Benefit__r.Category__c INCLUDES  ' + categoryWhereClause;
        }
        
        memberBenefitLocations = Database.query(memberBenefitLocationsQuery);

        if(memberBenefitLocations == null || memberBenefitLocations.size() <= 0) {
            //no member benefit location found
            addApexPageError('No member benefit location found. Please try again later.');
        }
    }
    // Google Map Page Logic ends
    //*************************************************************************
    
    //*************************************************************************
    // New MemberBenefitLocation object starts here 
    public Boolean renderLocations {get; set;}
    public Location__c[] locations {get; set;}
    public Member_Benefit__c parentMemberBenefit {get; set;}
    
    public Boolean renderMemberBenefits {get; set;}
    public Member_Benefit__c[] memberBenefits {get; set;}
    public Location__c parentLocation {get; set;}
    
    public List<SelectOption> itemOptions {get; set;}   
    public String[] selectedItems {get; set;}
        
    public void Initialize() {
        renderLocations=false;
        renderMemberBenefits=false;
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();
        selectedItems = new List<String>();
        for(String key : paramMap.keySet()) {
            if(key.endsWith('lkid')) {
                Id relationshipId = paramMap.get(key);
                Member_Benefit__c[] test = [Select Id, Name, Business_Member_Partner__c From Member_Benefit__c Where Id = :relationshipId Limit 1];
                /**
                 * Member_Benefit__c to Location__c
                 * These are all locations for this Account
                 */
                if(test.size()==1) { //ADDING LOCATIONS TO A MEMBER BENEFIT
                    parentMemberBenefit = test[0];
                    renderLocations=true;
                    renderMemberBenefits=false;
                    locations = getRemainingLocations(parentMemberBenefit.Business_Member_Partner__c, relationshipId);
                    
                    if(locations.size() > 0) {
                        itemOptions = new List<SelectOption>();
                        for(Location__c loc : locations) {
                            String optionLabel = loc.Street__c + ', ' +
                                                    loc.City__c + ', ' +
                                                    loc.State__c; 
                            itemOptions.add(
                                new SelectOption(loc.Id, optionLabel)
                                );                      
                        }
                    }
                    else {
                        addApexPageError('No locations found for this account.');
                    }           
                }
                /**
                 * Location__c to Member_Benefit__c
                 * These are all MemberBenefits for this Account
                 */             
                else {
                    parentLocation = [Select Id, Name, Account__c From Location__c Where Id = :relationshipId Limit 1];
                    renderMemberBenefits=true;
                    renderLocations=false;
                    
                    memberBenefits = getRemainingMemberBenefits(parentLocation.Account__c, relationshipId);
                    if(memberBenefits.size() > 0) {
                        itemOptions = new List<SelectOption>();
                        for(Member_Benefit__c mb : memberBenefits) {
                            String optionLabel = mb.name; 
                            itemOptions.add(
                                new SelectOption(mb.Id, optionLabel)
                                );
                        }
                    }
                    else {
                        addApexPageError('No member benefits found for this account.');
                    }   
                }
            }
        }
    }   
    
    public Location__c[] getRemainingLocations(Id accountId, Id memberBenefitId) {
        return [Select l.Name, l.Street__c, l.City__c, l.State__c, l.PostalCode__c, l.Phone__c  
                From Location__c l 
                Where l.Account__c = :accountId and l.id NOT IN 
                    (Select m.Location__c 
                    From Member_benefit_Location__c m 
                    Where m.Member_Benefit__c = :memberBenefitId)
                ];
    }
    
    public Member_Benefit__c[] getRemainingMemberBenefits(Id accountId, Id locationId) {
        return [Select b.Name, b.Benefit_Link__c 
                From Member_Benefit__c b  
                Where b.Business_Member_Partner__c = :accountId and b.id NOT IN 
                    (Select m.Member_Benefit__c 
                    From Member_benefit_Location__c m 
                    Where m.Location__c = :locationId)
                ];
    }
    
    public PageReference save() {
        PageReference pageReference = null;
        if(selectedItems != null && selectedItems.size() > 0) {
            System.debug('Adding '+selectedItems.size()+' item(s) to member benefit locations.');
            if(renderLocations) {
                for(String item : selectedItems) {
                    Member_benefit_Location__c mbl = new Member_benefit_Location__c();
                    mbl.Location__c = item;
                    mbl.Member_Benefit__c = parentMemberBenefit.Id;
                    mbl.Name = parentMemberBenefit.Name + ' in ' + [Select name from Location__c where id=:item].name;
                    insert mbl;
                }
                pageReference = new PageReference('/'+parentMemberBenefit.Id);
            }
            if(renderMemberBenefits) {
                for(String item : selectedItems) {
                    Member_benefit_Location__c mbl = new Member_benefit_Location__c();
                    mbl.Location__c = parentLocation.Id;
                    mbl.Member_Benefit__c = item;
                    mbl.Name = [Select name from Member_Benefit__c where id=:item].name + ' in ' + parentLocation.Name;
                    insert mbl;
                }
                pageReference = new PageReference('/'+parentLocation.Id);
            }
        }
        else {
            addApexPageError('Please select an item from the list.');
        }
        return pageReference;
    }
    
    // New MemberBenefitLocation object starts here 
    //************************************************************************* 
    private void addApexPageError(String error) 
    {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, error); 
        ApexPages.addMessage(myMsg);   
    }
    
     @isTest
    private static void myTest() {
       
        Account bmp = new Account(Name = 'Whiskeys Smokehouse');
        insert bmp;
       /*
        Account bmp = new Account(
           Name = 'Whiskeys Smokehouse', 
           Logo_Url__c = ''
        );
        insert bmp;
        
        Location__c loc = new Location__c(
           Name = 'Boylston St', 
           Account__c = bmp.id, 
           Street__c = '885 Boylston Street', 
           City__c = 'Boston', 
           State__c = 'MA', 
           PostalCode__c = '02116', 
           Phone__c = '(617) 262-5551', 
           Latitude__c = 42.348442,
           Longitude__c = -71.083608
        );
        insert loc;
        
        Member_Benefit__c mb = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get 15 cent wings at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c =  bmp.id
        );
        insert mb;
        
        Member_Benefit__c mbf = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get $1 Pizza at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c =  bmp.id, 
           featured__c = true, 
           Top_Two_Featured__c = true
        );
        
        insert mbf;
        
        Member_benefit_Location__c mbl1 = new Member_benefit_Location__c(
           Name = '15 cent wings at Boylston St', 
           Location__c = loc.id, 
           Member_Benefit__c = mb.id
        ); 
        insert mbl1;
        
        Member_benefit_Location__c mbl2 = new Member_benefit_Location__c(
           Name = '$1 Pizza at Boylston St', 
           Location__c = loc.id, 
           Member_Benefit__c = mb.id
        ); 
        insert mbl2;    


        ApexPages.CurrentPage().getParameters().put('idsToPrint', '-'+mb.Id+'-');
                
        ApexPages.CurrentPage().getParameters().put('searchTerm', 'Whiskeys Smokehouse');
        
        
        //ApexPages.CurrentPage().getParameters().put('memberBenefitId', mb.Id);
        */
        Member_Benefit__c m = new Member_Benefit__c();
        m.Name = 'test';
        insert m;
        Member_Benefit__c m1 = new Member_Benefit__c();
        m1.Name = 'test';
        insert m1;
        
        Location__c loc = new Location__c(
           Name = 'Boylston St', 
           Account__c = bmp.id, 
           Street__c = '885 Boylston Street', 
           City__c = 'Boston', 
           State__c = 'MA', 
           PostalCode__c = '02116', 
           Phone__c = '(617) 262-5551', 
           Latitude__c = 42.348442,
           Longitude__c = -71.083608
        );
        insert loc;
        
        Member_Benefit__c mb = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get 15 cent wings at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c = bmp.id
        );
        insert mb;    
        
         Member_Benefit__c mb1 = new Member_Benefit__c(
           Name = 'Test', 
           Offer__c = 'Get 15 cent wings at Whiskeys Smokehouse, Boylston Street, Sunday to Thursday 3pm to 2am with a purchase of an alcholic beverage.',  
           Category__c = 'Food & Drink', 
           Benefit_Link__c = 'http://www.whiskeysmokehouseboston.com', 
           Business_Member_Partner__c = bmp.id
        );
        insert mb1;    
            

        ApexPages.CurrentPage().getParameters().put('lkid', mb.Id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(new Member_Benefit__c()); 
        MemberBenefitLocationController clsTest = new MemberBenefitLocationController(StdController);
        //MemberBenefitLocationController clsTest = New MemberBenefitLocationController();        
        
        clsTest.selectedItems.add('Testnew');
        clsTest.selectedItems.add('Testnew1');     
        clsTest.renderLocations =  true;
        clsTest.renderMemberBenefits = true;
        clsTest.Initialize();
        system.debug('##IDS#'+ bmp.Id + '<---->'+ mb.Id);
        clsTest.getRemainingLocations(bmp.Id,mb.Id);
        clsTest.getRemainingMemberBenefits(bmp.Id,mb.Id);
        clsTest.save();
        clsTest.addApexPageError('Error Test');

        /*clsTest.isTest = true;        
        clsTest.showMemberBenefits();
        try{
            clstest.showMemberBenefit();
        }
        Catch(Exception ex) {}
        clsTest.searchMemberBenefits();
        clsTest.printDetail();
        clsTest.printDetails();
        clsTest.callPrintPage(new List<MemberBenefitWrapper>());
        
        ApexPages.currentPage().getParameters().put('idsToPrint',m.Id);
        
        try {
            clsTest.print();
        }
        Catch(Exception ex){}
        
        try {
            clsTest.retrieveMemberBenefit();
        }
        Catch(Exception ex) {}
        
        clsTest.searchTerm = 'Test';
        clsTest.retrieveMemberBenefits();
        clsTest.getCategories();*/
        
    }
}