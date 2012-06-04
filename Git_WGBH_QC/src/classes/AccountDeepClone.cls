public with sharing class AccountDeepClone {
    ApexPages.StandardController controller;
    
    Map<String, String> sobjectMap = new Map<String, String> {}; // map of all the old ids to the new ids
    Set<String> contactFieldNameSet = Contact.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> opportunityFieldNameSet = Opportunity.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> opportunityLineItemFieldNameSet = OpportunityLineItem.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> givingSummaryFieldNameSet = Giving_Summary__c.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> salutationFieldNameSet = Salutation__c.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> addressFieldNameSet = Address__c.SobjectType.getDescribe().fields.getMap().keySet();
    Set<String> classificationFieldNameSet = Classification__c.SobjectType.getDescribe().fields.getMap().keySet();
    
    public AccountDeepClone(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    public PageReference initialize() {
        if (getParam('newid') == null || getParam('newid') == '')
            return initializeCloneEdit();
        return initializeCloneSave();
    }
    
    String getParam(String param) {
        return ApexPages.currentPage().getParameters().get(param);
    }
    
    String getNewId() {
        return getParam('newid');
    }
    
    void addErrorMessage(String errorMessage) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
    }
    
    PageReference initializeCloneEdit() {
        PageReference saveURL = System.Page.AccountDeepClone;
        saveURL.getParameters().put('id', controller.getId());
        saveURL.getParameters().put('retURL', getParam('retURL'));
        saveURL.setRedirect(true);
        
        PageReference pageReference = new PageReference('/' + controller.getId() + '/e');
        pageReference.getParameters().put('clone', '1');
        pageReference.getParameters().put('nooverride', '1');
        pageReference.getParameters().put('saveURL', saveURL.getURL());
        pageReference.getParameters().put('cancelURL', getParam('retURL'));
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    PageReference initializeCloneSave() {
        // clone all objects, standard
        Sobject[] contactNewList = cloneSobjects('Contact', 'AccountId', contactFieldNameSet);
        Sobject[] opportunityNewList = cloneSobjects('Opportunity', 'AccountId', opportunityFieldNameSet);
        Sobject[] givingSummaryNewList = cloneSobjects('Giving_Summary__c', 'Account__c', givingSummaryFieldNameSet);
        Sobject[] salutationNewList = cloneSobjects('Salutation__c', 'Account__c', salutationFieldNameSet);
        Sobject[] addressNewList = cloneSobjects('Address__c', 'Account_Household__c', addressFieldNameSet);
        Sobject[] classificationNewList = cloneSobjects('Classification__c', 'Account__c', classificationFieldNameSet);
        
        // special handling for opportunity line items
        Sobject[] opportunityLineItemNewList = cloneOpportunityLineItems(opportunityNewList);
        
        // once all objects are cloned, search-replace ids
        update mergeIds(contactNewList, contactFieldNameSet);
        update mergeIds(givingSummaryNewList, givingSummaryFieldNameSet);
        update mergeIds(salutationNewList, salutationFieldNameSet);
        update mergeIds(addressNewList, addressFieldNameSet);
        update mergeIds(classificationNewList, classificationFieldNameSet);
        //update mergeIds(opportunityNewList, opportunityFieldNameSet);
        //update mergeIds(opportunityLineItemNewList, opportunityLineItemFieldNameSet);
        
        PageReference pageReference = new PageReference('/' + getNewId());
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    Sobject[] cloneSobjects(String sobjectType, String foreignKey, Set<String> fieldNameSet) {
        String statement = generateSelectSOQL(fieldNameSet)
            + ' FROM ' + sobjectType
            + ' WHERE ' + foreignKey 
            + ' = \'' + controller.getId() + '\'';
        
        Sobject[] sobjectOldList = Database.query(statement);
        Sobject[] sobjectNewList = sobjectOldList.deepClone(false, false);
        
        for(Integer i = 0; i < sobjectNewList.size(); i++) {
            // Special handling
            if ('Address__c'.equalsIgnoreCase(sobjectType))
                sobjectNewList[i].put('TAAddressId__c', null); // clear unique id
            
            sobjectNewList[i].put(foreignKey, getNewId());
        }
        
        insert sobjectNewList;
        
        for(Integer i = 0; i < sobjectNewList.size(); i++)
            sobjectMap.put(String.valueOf(sobjectOldList[i].get('Id')), String.valueOf(sobjectNewList[i].get('Id')));
        
        return sobjectNewList;
    }
    
    Sobject[] cloneOpportunityLineItems(Sobject[] opportunityNewList) {
        String statement = generateSelectSOQL(opportunityLineItemFieldNameSet)
            + '  FROM OpportunityLineItem ' + 
            + ' WHERE OpportunityId IN :opportunityNewList';
        
        Sobject[] sobjectOldList = Database.query(statement);
        Sobject[] sobjectNewList = sobjectOldList.deepClone(false, false);
        
        for(Integer i = 0; i < sobjectNewList.size(); i++)
            sobjectNewList[i].put('OpportunityId', sobjectMap.get(String.valueOf(sobjectNewList[i].get('OpportunityId'))));
        
        insert sobjectNewList;
        
        for(Integer i = 0; i < sobjectNewList.size(); i++)
            sobjectMap.put(String.valueOf(sobjectOldList[i].get('Id')), String.valueOf(sobjectNewList[i].get('Id')));
        
        return sobjectNewList;
    }
    
    Sobject[] mergeIds(Sobject[] sobjectNewList, Set<String> fieldNameSet) {
        for(Sobject sobjectNew : sobjectNewList) {
            for(String fieldName : fieldNameSet) {
                if (fieldName == null)
                    continue;
                
                Object potential = sobjectNew.get(fieldName);
                
                if (potential == null) 
                    continue;
                if (String.valueOf(potential) == null) 
                    continue;
                if (sobjectMap.get(String.valueOf(potential)) == null)
                    continue;
                sobjectNew.put(fieldName, sobjectMap.get(String.valueOf(potential)));
            }
        }
        
        return sobjectNewList;
    }
    
    String generateSelectSOQL(Set<String> fieldNameSet) {
        String statement = 'SELECT id';
        fieldNameSet.remove('id');
        
        for(String fieldName : fieldNameSet)
            statement += ', ' + fieldName;
        return statement;
    }
    
    public static testmethod void test() {
        // This is a hack class, so I'm not going to write full unit tests.
        Account account1 = [select Id from Account limit 1];
        ApexPages.currentPage().getParameters().put('id', account1.Id);
        AccountDeepClone accountDeepClone1 = new AccountDeepClone(new ApexPages.StandardController(account1));
        accountDeepClone1.initialize();
        
        Account account2 = [select Id from Account where Id != :account1.Id limit 1];
        ApexPages.currentPage().getParameters().put('newid', account2.Id);
        AccountDeepClone accountDeepClone2 = new AccountDeepClone(new ApexPages.StandardController(account2));
        accountDeepClone2.initialize();
    }
}