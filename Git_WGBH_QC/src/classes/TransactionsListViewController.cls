public class TransactionsListViewController {
	
	public class TransactionData {
		
		public TransactionData(Boolean recurring, Id id, String name, Date giftDate, String activity, String giftType, String campaignType, Decimal pledgeAmount, Decimal paidAmount, 
		                          Date lastPaymentDate, String giftKind, Decimal installmentAmount, String stageName, String paymentMethod, Boolean benefitExists, String pledgeNumber, 
		                          Date scheduleStartDate, String source, Decimal paymentsInSchedule, Decimal balance) {
			this.recurring = this.toCheckImage(recurring);
			this.id = id;
			this.name = name;
			this.giftDate = this.toDateString(giftDate);
			this.giftDateOrg = giftDate;
			this.activity = activity;
			this.giftType = giftType;
			this.campaignType = campaignType;
			this.pledgeAmount = pledgeAmount;
			this.paidAmount = paidAmount;
			this.lastPaymentDate = this.toDateString(lastPaymentDate);
			this.giftKind = giftKind;
			if(recurring) {
			    this.installmentAmount = installmentAmount;
			}
			this.stageName = stageName;
			this.paymentMethod = paymentMethod;
			this.benefitExists = this.toCheckImage(benefitExists);
			this.pledgeNumber = pledgeNumber;
			this.scheduleStartDate = this.toDateString(scheduleStartDate);
			this.source = source;
			this.paymentsInSchedule = paymentsInSchedule;
			if(balance > 0) {
			    this.balance = balance;
			}
		}
		
		public String recurring {get; set;}
		public ID Id {get; set;}
		public String name {get; set;}
		public String giftDate {get; set;}
		public Date giftDateOrg {get; set;}
		public String activity {get; set;}
		public String giftType {get; set;}
		public String campaignType {get; set;}
		public Decimal pledgeAmount {get; set;}
		public Decimal paidAmount {get; set;}
		public String lastPaymentDate {get; set;}
		public String giftKind {get; set;}
		public Decimal installmentAmount {get; set;}
		public String stageName {get; set;}
		public String paymentMethod {get; set;}
		public String benefitExists {get; set;}
		public String pledgeNumber {get; set;}
		public String scheduleStartDate {get; set;}
		public String source {get; set;}
		public Decimal paymentsInSchedule {get; set;}
		public Decimal balance {get; set;}
		
		public String toDateString(Date tempDate) {
	        return (tempDate != null ? Datetime.newInstance(tempDate, Time.newInstance(0,0,0,0)).format('M/d/yyyy') : '');
	    }
	    
		public String toCheckImage(Boolean flag) {
	        return (flag ? '/img/checkbox_checked.gif' : '/img/checkbox_unchecked.gif');
	    }
	}
	
	public List<TransactionData> transactions {
	    get {
             return this.getTransactions();
	    }
        set;
    }
	public String sObjectType {get; set;}
    public String recordId {get; set;}
	
	public TransactionsListViewController() {
	}
	
    public List<TransactionData> getTransactions() {
        
        List<TransactionData> tempTransactions = new List<TransactionData>();
        
        
        return tempTransactions;
    }
    
    public static testMethod void testBatch() {
        Household__c h = new Household__c(
           Name = 'Mr. & Mrs. Joe Dirt', 
           Ta_Account_Id__c = 23456, 
           bulk_load__c = true
        );
        insert h;
        Contact c = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I', 
           bulk_load__c = true
        );
        insert c;
        Account a = new Account(
           Name = 'Blue Ribbon BBQ', 
           TaAccountId__c = 23456, 
           bulk_load__c = true
        );
        insert a;
        Recurring_Donation__c rd1 = new Recurring_Donation__c(
           TaTransactions_Id__c = '23456_01_I_1230987_03',
           Name = 'Test RD 1',
           gift_date__c = Date.today(),
           pledge_amount__c = 200, 
           paid_amount__c = 100, 
           Amount__c = 200,  
           household__c = h.id, 
           contact__c = c.id, 
           Account__c = a.id, 
           bulk_load__c = true
        );
        insert rd1;
        Opportunity o11 = new Opportunity(
           tatransactions_Id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Opporutnity 1',
           StageName = 'Cultivation',
           CloseDate = Date.today() - 5, 
           gift_date__c = Date.today() - 5, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 1, 
           household__c = h.id, 
           Oppty_Related_Contact__c = c.id, 
           AccountId = a.id, 
           bulk_load__c = true
        );
        insert o11;
        
        //Test.SetCurrentPageReference ;
        //System.CurrentPageReference().getParameters().put('id',h.Id);
        //OpportunityClosedLost cOpp1 = new OpportunityClosedLost(sc1);
        //PageReference page1 = Page.TransactionsListViewHousehold;
        //page1.getParameters().put('id', h.id);
        //Test.setCurrentPageReference(page1);
        //ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(h);
        TransactionsListViewController tlvc = new TransactionsListViewController();
        tlvc.recordId = h.id;
        tlvc.sObjectType = 'Household__c';
        List<TransactionData> transactions = tlvc.transactions;
        tlvc.sObjectType = 'Contact';
        transactions = tlvc.transactions;
        tlvc.sObjectType = 'Account';
        transactions = tlvc.transactions;
        
        //Opportunity[] to = [SELECT CloseDate, Amount FROM Opportunity WHERE tatransactions_Id__c IN (:o11.tatransactions_Id__c, :o12.tatransactions_Id__c, :o13.tatransactions_Id__c)];
//todo        System.AssertEquals(to[0].CloseDate, Date.today() - 3);
//todo        System.AssertEquals(to[1].CloseDate, Date.today() - 1);
//todo        System.AssertEquals(to[2].CloseDate, Date.today() - 1);
        
//todo        System.AssertEquals(to[0].Amount, 100);
//todo        System.AssertEquals(to[1].Amount, 100);
//todo        System.AssertEquals(to[2].Amount, 780);
        
        //Recurring_Donation__c trd1 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd1.TaTransactions_Id__c][0];
        //System.AssertEquals(trd1.Contact__c, c.id);
        //Recurring_Donation__c trd2 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd2.TaTransactions_Id__c][0];
        //System.AssertEquals(trd2.Household__c, h.id);        
        //Recurring_Donation__c trd3 = [SELECT Contact__c, Household__c, Organization__c FROM Recurring_Donation__c WHERE TaTransactions_Id__c = :rd3.tatransactions_Id__c][0];
        //System.AssertEquals(trd3.Organization__c, a.id);                               
    }    
}