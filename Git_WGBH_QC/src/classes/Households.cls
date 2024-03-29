/*
    Copyright (c) 2009, Salesforce.com Foundation
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Salesforce.com Foundation nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
global class Households {

    /// <name> Households </name>
    /// <summary> Default Constructor </summary>
    public Households(){}

    /// <name> triggerAction </name>
    /// <summary> contains possible actions for a trigger </summary>
    public enum triggerAction {beforeInsert, beforeUpdate, beforeDelete, afterInsert, afterUpdate, afterDelete, afterUndelete}

    /// <name> Households </name>
    /// <summary> Overloads the Households object constructor to handle Household processing </summary>
    /// <param name="households"> Household objects that are being triggered </param>
    /// <param name="oldHouseholds"> Household object values before trigger event </param>
    /// <param name="ta"> Trigger action that is occuring </param>
    public Households(Contact[] contacts, Contact[] oldContacts, triggerAction ta)
    {
        List<Contact> householdInserts = new List<Contact>();
        List<Contact> contactEvaluations = new List<Contact>();
        List<Contact> householdDeletes = new List<Contact>();

        Integer i = 0;
        for(Contact c : contacts) {
            //AFTER INSERT
            if ( ta==triggerAction.afterInsert )
            {
                //If the user has chosen for all Contacts to have households, add them all to the list
                //for Household creation
                if (c.Account_Household__c == null && c.SystemHouseholdProcessor__c == 'All New or Edited Contacts')
                {
                    householdInserts.add(c);
                }
                //If the user has chosen for only Contacts connected to Individual Accounts to have Households
                //add them all to a list for evaluation
                else if (c.Account_Household__c == null && c.SystemHouseholdProcessor__c == 'All Individual Contacts')
                {
                    contactEvaluations.add(c);
                }
            }

            //AFTER UPDATE
            if ( ta==triggerAction.afterUpdate )
            {
                if (c.Account_Household__c == null && c.SystemHouseholdProcessor__c == 'All New or Edited Contacts')
                {
                    householdInserts.add(c);
                } else
                if (c.Account_Household__c == null && c.SystemHouseholdProcessor__c == 'All Individual Contacts')
                {
                    contactEvaluations.add(c);
                }
            }

            //AFTER DELETE
            if ( ta==triggerAction.afterDelete )
            {
                if (c.Account_Household__c != null )
                {
                    householdDeletes.add(c);
                }
            }

            i += 1;
        }

        if (householdInserts.size() > 0)
        {
            insertHousehold(householdInserts);
        }
        if (contactEvaluations.size() > 0)
        {
            evaluateContacts(contactEvaluations);
        }
        if (householdDeletes.size() > 0)
        {
            deleteHousehold(householdDeletes);
        }

    }


    /// <name> insertHousehold </name>
    /// <summary> Creates a new Household record when a Contact does not have one </summary>
    /// <param name="Contact"> List of contacts meeting trigger criteria </param>
    public static void insertHousehold(Contact[] contacts)
    {
        List<Account> householdInserts = new List<Account>();
        for(Contact c : contacts)
        {
            Account h = new Account();
            String hName = c.LastName;
            hName += ' ' + system.label.DefaultHouseholdName;
            h.Name = hName;
            //sync the primary address block
            h.MailingStreet__c = c.MailingStreet;
            h.MailingCity__c = c.MailingCity;
            h.MailingState__c = c.MailingState;
            h.MailingPostalCode__c  = c.MailingPostalCode;
            h.MailingCountry__c = c.MailingCountry;
            h.Household_Phone__c = c.HomePhone;
            h.Household_Email__c = c.Email;
            householdInserts.add(h);
        }
        List<Contact> contactUpdates = new List<Contact>();
        if (householdInserts.size() > 0)
        {
            Database.SaveResult[] lsr = Database.insert(householdInserts, false);
            Integer i = 0;
            for (Contact c : contacts)
            {
                if (lsr[i].isSuccess() == true)
                {
                    //write the new Household Ids to the Contacts
                    Contact clone = c.Clone(true,false);
                    clone.Account_Household__c = lsr[i].getId();
                    contactUpdates.add(clone);
                }
                i += 1;
            }
        }
        if (contactUpdates.size() > 0)
        {
            Database.SaveResult[] lsr = Database.update(contactUpdates, false);
        }
    }
    

    /// <name> insertHousehold </name>
    /// <summary> Determines if a Contact Should have a household created </summary>
    /// <param name="Contact"> List of contacts meeting trigger criteria </param>
    public static void evaluateContacts(Contact[] contacts)
    {
        List<Contact> householdInserts = new List<Contact>();

        List<Id> accountIds = new List<Id>();
        for(Contact c : contacts)
        {
            if (c.accountId != null)
            {
                accountIds.add(c.AccountId);
            }
        }
        //get all the Accounts so we can test to see if they are individuals
        Map<Id,Account> contactAccountMap = new Map<Id,Account>([Select Id, SYSTEMIsIndividual__c, Name from Account where Id in :accountIds]);
        for(Contact c : contacts)
        {
            if (c.AccountId != null)
            {
                Account acc = contactAccountMap.get(c.AccountId);
                //check the system field on Account to see if the account is an individual
                if (acc.SYSTEMIsIndividual__c == true)
                {
                    householdInserts.add(c);
                }
            } else
            if (c.AccountId == null)
            {
                householdInserts.add(c);
            }
        }
        if ( householdInserts.size() > 0)
        {
            //hand any Contacts that need Households over to the insert method
            insertHousehold(householdInserts);
        }
    }


    /// <name> deleteHousehold </name>
    /// <summary> Deletes a Household record when no Contacts are related to it </summary>
    /// <param name="Contact"> List of contacts meeting trigger criteria </param>
    public static void deleteHousehold(Contact[] contacts)
    {
        List<Id> householdDeletes = new List<Id>();
        Map<Id,Integer> householdCountMap = new Map<Id,Integer>();

        //Generate a list of Household Ids
        for(Contact c : contacts)
        {
            if (c.Account_Household__c != null)
            {
                householdCountMap.put(c.Account_Household__c,0);
            }
        }

        //Loop through all Contacts at one of the Household Ids
        for (Contact c : [Select Id, Account_Household__c from Contact where Account_Household__c in :householdCountMap.keyset()])
        {
            Integer lastCount = householdCountMap.get(c.Account_Household__c);
            lastCount += 1;
            householdCountMap.put(c.Account_Household__c,lastCount);
        }

        //Loop through all the contacts to determine if they can be deleted
        for (Contact c : contacts)
        {
            //If there are no other Contacts on the Account
            if ( householdCountMap.get(c.Account_Household__c) < 1 )
            {
                householdDeletes.add(c.Account_Household__c);
            }
        }

        if (householdDeletes.size() > 0)
        {
            Database.DeleteResult[] lsr = Database.delete(householdDeletes, false);           
        }
    }


    /// <name> getHouseholdLastTransaction </name>
    /// <summary>  </summary>
    webservice static String getHouseholdLastTransaction(Id householdId)
    {
        List<Id> contactIds = new List<Id>();
        List<Contact> contacts = [Select Id from Contact where Account_Household__c = :householdId];
        for (contact c : contacts)
        {
            contactIds.add(c.Id);
        }
        Double total = 0;
        List<OpportunityContactRole> ocr = [Select Opportunity.Amount, Opportunity.CloseDate from OpportunityContactRole where ContactId in :contactIds AND Opportunity.isWon = true Order By Opportunity.CloseDate DESC];
        if (ocr.size() > 0)
        {
            Date lastTransaction = ocr[0].Opportunity.CloseDate;
            return String.valueOf(lastTransaction);
        }
        return null;
    }


    /// <name> getHouseholdTransactionTotal </name>
    /// <summary>  </summary>
    webservice static String getHouseholdTransactionTotal(Id householdId)
    {
        List<Id> contactIds = new List<Id>();
        List<Contact> contacts = [Select Id from Contact where Account_Household__c = :householdId];
        for (contact c : contacts)
        {
            contactIds.add(c.Id);
        }
        Double total = 0;
        Set<Id> opps = new Set<Id>();
        
        for( OpportunityContactRole ocr : [Select Opportunity.Amount, OpportunityId From OpportunityContactRole where ContactId in :contactIds AND Opportunity.isWon = true])
        {
            if ( ocr.Opportunity.Amount != null )
            {
                opps.add(ocr.OpportunityId);

            }
        }
        for( Opportunity wonOpps : [Select Amount From Opportunity where Id in :opps])
        {
            total += wonOpps.Amount;
        }
        String totalString = system.label.DefaultHouseholdTransactionCurrency;
        Decimal totalFormat = Decimal.valueOf(total).setScale(2);
        totalString += totalFormat;
        return String.valueOf(totalString);
    }
    
    /// <name> getHouseholdLastTransaction </name>
    /// <summary>  </summary>
    public static String getHouseholdLastTransactionDate(Id householdId)
    {
        List<Id> contactIds = new List<Id>();
        List<Contact> contacts = [Select Id from Contact where Account_Household__c = :householdId];
        for (contact c : contacts)
        {
            contactIds.add(c.Id);
        }
        Double total = 0;
        List<OpportunityContactRole> ocr = [Select Opportunity.Amount, Opportunity.CloseDate from OpportunityContactRole where ContactId in :contactIds AND Opportunity.isWon = true Order By Opportunity.CloseDate DESC];
        if (ocr.size() > 0)
        {
            return ocr[0].Opportunity.CloseDate.month() + '/' + ocr[0].Opportunity.CloseDate.day() + '/' + ocr[0].Opportunity.CloseDate.year();
        }
        return null;
    }
    
     /// <name> getHouseholdTransactionTotal </name>
    /// <summary>  </summary>
    public static String getHouseholdTransactionAmount(Id householdId)
    {
        List<Id> contactIds = new List<Id>();
        List<Contact> contacts = [Select Id from Contact where Account_Household__c = :householdId];
        for (contact c : contacts)
        {
            contactIds.add(c.Id);
        }
        Double total = 0;
        Set<Id> opps = new Set<Id>();
        
        for( OpportunityContactRole ocr : [Select Opportunity.Amount, OpportunityId From OpportunityContactRole where ContactId in :contactIds AND Opportunity.isWon = true])
        {
            if ( ocr.Opportunity.Amount != null )
            {
                opps.add(ocr.OpportunityId);

            }
        }
        for( Opportunity wonOpps : [Select Amount From Opportunity where Id in :opps])
        {
            total += wonOpps.Amount;
        }
        String totalString = system.label.DefaultHouseholdTransactionCurrency;
        Decimal totalFormat = Decimal.valueOf(total).setScale(2);
        totalString += totalFormat;
        return String.valueOf(totalString);
    }

}