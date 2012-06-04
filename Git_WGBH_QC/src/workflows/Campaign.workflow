<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Campaign_End_Date</fullName>
        <description>Campaign End Date Has Passed - Change Status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign_Notifications/Lapsed_Campaign</template>
    </alerts>
    <alerts>
        <fullName>Campaign_End_Date_has_Passed_Campaign_is_Still_Active</fullName>
        <description>Campaign End Date has Passed - Campaign is Still Active</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign_Notifications/Lapsed_Campaign</template>
    </alerts>
    <fieldUpdates>
        <fullName>Active_Checkbox</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Active Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign End Date Notification</fullName>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Campaign.End_Time_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.End_Time_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Once a campaign has reached the end date send an email to the campaign owner to change the status to completed or update the end date to a future date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Make Campaign Active</fullName>
        <actions>
            <name>Active_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
