public class PRRClassification{

    public PRRClassification(ApexPages.StandardController controller) {
        PageLoad();
    }
    
    public PRRClassification(){
        PageLoad();
    }
    
    public List<Classification__c> classifications {
        get {
             return this.getAllClassifications();
        }
        set;
    }
    public void PageLoad() {
        //id=ApexPages.CurrentPage().getParameters().get('id');
        List<Prospect_Research_Reports__c> lstPRR = new List<Prospect_Research_Reports__c>();
        
        lstPRR = [SELECT id, Contact__c,Account__c FROM Prospect_Research_Reports__c WHERE ID=:ApexPages.CurrentPage().getParameters().get('id')];
        if(lstPRR[0].Contact__c!=null) {
            sObjectType='Contact';
            recordId=lstPRR[0].Contact__c;
        }
        else if(lstPRR[0].Account__c!=null) {
            sObjectType='Account';
            recordId=lstPRR[0].Account__c;            
        }
        else {
            recordId = null;
        }
        Delid='aaa';
        system.debug('------------------------------------->' + id);
    }
    public TabData[] tabs {get; set;}
    
    public class TabData {
        public String tabName {
            get {
                return (this.classifications != null && this.classifications.size() > 0 ? this.tabName + ' [' + this.classifications.size() + ']' : this.tabName);
            }
            set;
        }
        public List<Classification__c> classifications {get; set;}
        
        public TabData(String tabName, List<Classification__c> classifications) {
            this.tabName = tabName;
            this.classifications = classifications;
            System.debug('creating '+tabName+' tab with '+classifications.size()+' classifications.');
        }
    }
    
    public TabData board {get; set;}
    public TabData committee {get; set;}
    
    
    public String Delid{get;set;} 
    public string id{get;set;}
    
    public String recordId {get; set;}
    public String sObjectType {get; set;}
    

    
    public Classification__c[] getAllClassifications() {
        List<Classification__c> classifications = null;
        
        if(sObjectType == 'Contact') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Contact__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Contact__c = :recordId and c.Account__c!=null];
        }
        else if(sObjectType == 'Account') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null];
        }
        else if(sObjectType == 'Account__c') {
            classifications = [Select c.start_date__c, c.end_date__c, c.comments__c, c.classification_value__c, c.classification_tabname__c, c.classification_code__c, c.active__c, c.Account__c, c.Classification_Code_Value__r.value_description__c, c.Classification_Code_Value__r.code_description__c, c.Classification_Code_Value__c From Classification__c c Where c.Account__c = :recordId and c.Account__c!=null];
        } 
        
        if(classifications != null) {// && classifications.size() > 0) {
            System.debug('found '+classifications.size()+' classifications');
            this.tabs = new TabData[] {
                this.createTab(classifications, 'Board', 'WGBH Boards'), 
                this.createTab(classifications, 'Committees')
            };
            System.debug('created '+this.tabs.size()+' tabs');
            
            Integer tabIndex = 0;
            board = this.tabs[tabIndex ++];
            committee = this.tabs[tabIndex ++];
        }
        else {
            System.debug('found no classifications');
        }
        
        return classifications;
    }
    
    public List<Classification__c> getClassifications(List<Classification__c> classifications, String tabName) {
        List<Classification__c> cList = new List<Classification__c>();
        for(Classification__c c : classifications) {
            if(c.classification_tabname__c == tabName) {
                cList.add(c);
            }
        }
        return cList;
    }
    
    public TabData createTab(List<Classification__c> classifications, String tabName) {
        System.debug('in ct 1');
        return this.createTab(classifications, tabName, null);
    }
    
    public TabData createTab(List<Classification__c> classifications, String tabName, String tabLabel) {
        System.debug('in ct 2');
        return new TabData(tabLabel == null ? tabName : tabLabel, this.getClassifications(classifications, tabName));
    }



    public PageReference Delmet() {
        System.debug('Deleteing classification: '+Delid);
        try {
            Classification__c c= [SELECT Id from Classification__c where id=:DelId];
            delete c;
        }
        catch(Exception e) {
            System.debug('Unable to delete classification: '+Delid+', ex: '+e);
        }
        pagereference pg = ApexPages.currentPage();
        return pg;
    }
    

    Static TestMethod void TestPRRClassification() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cnt = new Contact();
        cnt.firstName = 'Test';
        cnt.lastName = 'test';
        cnt.AccountID = a.Id;
        insert cnt;   
        
        
        Prospect_Research_Reports__c p = new Prospect_Research_Reports__c();
        p.Contact__c = cnt.id;
        insert p;
        
        ApexPages.CurrentPage().getParameters().put('id',p.id);        
        PRRClassification clsTest1 = new PRRClassification();
        

        
        ApexPages.StandardController controller = new ApexPages.StandardController(p);
        PRRClassification clsTest = new PRRClassification(controller);
        
        List<Classification__c> classifications = clsTest.classifications;
        clsTest.getAllClassifications();
        
        clsTest.getClassifications(New List<Classification__c>(),'Test');
        clsTest.createTab(New List<Classification__c>(),'Test');
        clsTest.createTab(New List<Classification__c>(),'Test','Test');
        clsTest.Delmet();

        
    } 
}