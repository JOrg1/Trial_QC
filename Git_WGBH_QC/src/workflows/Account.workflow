<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WCAI_Annual_Major_Donor_Flag</fullName>
        <field>WCAI_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WCAI Annual Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WCAI_Major_Donor_Flag</fullName>
        <field>WCAI_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WCAI Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WGBH_Annual_Major_Donor_Flag</fullName>
        <field>WGBH_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WGBH Annual Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WGBH_Major_Donor_Flag</fullName>
        <field>WGBH_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WGBH Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WGBY_Annual_Major_Donor_Flag</fullName>
        <field>WGBY_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WGBY Annual Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WGBY_Major_Donor_Flag</fullName>
        <field>WGBY_Major_Donor_Flag__c</field>
        <literalValue>1</literalValue>
        <name>WGBY Major Donor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WCAI Active Major Donor</fullName>
        <actions>
            <name>WCAI_Annual_Major_Donor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.WCAI_Major_Gifts_Status__c</field>
            <operation>equals</operation>
            <value>Major Gifts Active</value>
        </criteriaItems>
        <description>This rule sets the WCAI Annual Major Donor (WCAI_Major_Donor__c) flag = TRUE, if the WCAI Major GIfts Status field is set to MAJOR GIFTS ACTIVE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WGBH Active Major Donor</fullName>
        <actions>
            <name>WGBH_Annual_Major_Donor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.WGBH_Major_Gifts_Status__c</field>
            <operation>equals</operation>
            <value>Major Gifts Active</value>
        </criteriaItems>
        <description>This rule sets teh WGBH Ralph Lowell Society Donor (WGBH_Major_Donor__c) flag = TRUE, if the WGBH Major GIfts Status field is set to MAJOR GIFTS ACTIVE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WGBY Active Major Donor</fullName>
        <actions>
            <name>WGBY_Annual_Major_Donor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.WGBY_Major_Gifts_Status__c</field>
            <operation>equals</operation>
            <value>Major Gifts Active</value>
        </criteriaItems>
        <description>This rule sets the WGBY Murrow Society Donor (WGBY_Major_Donor__c) flag = TRUE, if the WGBY Major GIfts Status field is set to MAJOR GIFTS ACTIVE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
