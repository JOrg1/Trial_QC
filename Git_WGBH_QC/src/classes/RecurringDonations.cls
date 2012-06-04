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
global class RecurringDonations {

	/// <name> RecurringDonations </name>
	/// <summary> Default Constructor </summary> 
	public RecurringDonations(){}


	/// <name> triggerAction </name>
	/// <summary> contains possible actions for a trigger </summary>
	public enum triggerAction {beforeInsert, beforeDelete, afterInsert, afterDelete, afterUndelete}


	/// <name> RecurringDonations </name>
	/// <summary> Overloads the RecurringDonations object constructor to handle RecurringDonation processing </summary>
	/// <param name="recurringDonations"> RecurringDonation objects that are being triggered </param>
	/// <param name="oldRecurringDonations"> RecurringDonation object values before trigger event </param>
	/// <param name="ta"> Trigger action that is occuring </param>
	public RecurringDonations(Recurring_Donation__c[] recurringDonations, Recurring_Donation__c[] oldRecurringDonations, triggerAction ta)
	{
		
	}
	
	/// <name> insertContactOpportunities </name>
	/// <summary> Creates new Opportunities when a RecurringDonation is inserted </summary>
	/// <param name="recurringDonations"> RecurringDonation objects that are being triggered </param>
	public static void insertOpptys( Recurring_Donation__c[] recurringDonations, String donorType )
	{
		
	}
	
	@future public static void oppContactRoles( Set<Id> oppIds ){
		
	}
	

	/// <name> deleteRecDonations </name>
	/// <summary> Validates that a Recurring Donation can be deleted </summary>
	/// <param name="recurringDonations"> RecurringDonation objects that are being triggered </param>
	public static void deleteRecDonations(Recurring_Donation__c[] recurringDonations)
	{
		
	}
	
}