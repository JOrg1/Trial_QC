<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Pledge_Notification_for_Tribute</fullName>
        <description>Pledge Notification for Tribute</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Planned_Giving/Pledge_Notification_for_Tribute</template>
    </alerts>
    <fieldUpdates>
        <fullName>Delete_Solicited_Pledge_After_3_Months</fullName>
        <field>Remove_Opportunity__c</field>
        <literalValue>1</literalValue>
        <name>Delete Solicited Pledge After 3 Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pledge_Stage_Part_Col_6_Month</fullName>
        <description>Set the stage to &apos;Partially Collected&apos; for the following
One Payment - Stage is Partially Fulfilled and gift date is older than 6 months</description>
        <field>StageName</field>
        <literalValue>Partially Collected</literalValue>
        <name>Update Pledge Stage-Part-Col-6 Month</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pledge_Stage_to_Uncollectible</fullName>
        <field>StageName</field>
        <literalValue>Uncollectible</literalValue>
        <name>Update Pledge Stage to Uncollectible</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Acknowledgement Letter</fullName>
        <actions>
            <name>Create_Acknowledgement_Letter</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Account.WCAI_Major_Donor_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.WGBH_Major_Donor_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.WGBY_Major_Donor_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Automatically creates a task to create the Acknowledgement letter once a Major Gifts Giving record has moved to the Fulfilled Stage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delete Solicited Pledge After 3 Months</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Solicitation/Proposal</value>
        </criteriaItems>
        <description>System shall delete all pledges with stage Solicited and gift date is older than 3 months</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Giving Notification for Tribute</fullName>
        <actions>
            <name>Pledge_Notification_for_Tribute</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Tribute_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Pledge Stage to Partially Collected - 1 Year</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Parent_Giving_Stage__c</field>
            <operation>equals</operation>
            <value>Partially Fulfilled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.gift_kind__c</field>
            <operation>equals</operation>
            <value>Installment</value>
        </criteriaItems>
        <description>One Payment - Stage is Partially Fulfilled and gift date is older than 6 months</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Pledge Stage to Partially Collected - 6 Month</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.gift_kind__c</field>
            <operation>equals</operation>
            <value>One Payment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Partially Fulfilled</value>
        </criteriaItems>
        <description>One Payment - Stage is Partially Fulfilled and gift date is older than 6 months</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Pledge Stage to Uncollectible - 18 Month</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.gift_kind__c</field>
            <operation>equals</operation>
            <value>Sustaining Gift</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Parent_Giving_Stage__c</field>
            <operation>equals</operation>
            <value>Pledged</value>
        </criteriaItems>
        <description>One payment - Stage is pledged and gift date is older than 6 months
Installment - Stage on parent is pledged and gift date is older than 6 months.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Pledge Stage to Uncollectible - 6 Month</fullName>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.gift_kind__c</field>
            <operation>equals</operation>
            <value>One Payment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pledged</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.gift_kind__c</field>
            <operation>equals</operation>
            <value>Installment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Parent_Giving_Stage__c</field>
            <operation>equals</operation>
            <value>Pledged</value>
        </criteriaItems>
        <description>One payment - Stage is pledged and gift date is older than 6 months
Installment - Stage on parent is pledged and gift date is older than 6 months.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Create_Acknowledgement_Letter</fullName>
        <assignedTo>kamlesh@wgbh.com.qc</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Acknowledgement Letter</subject>
    </tasks>
    <tasks>
        <fullName>Prospect_Research_Request</fullName>
        <assignedTo>kamlesh@wgbh.com.qc</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Prospect Research Request</subject>
    </tasks>
</Workflow>
