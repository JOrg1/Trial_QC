<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>PRR Request</fullName>
        <actions>
            <name>Prospect_Research_Request</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Prospect_Research_Reports__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Generates a Prospect Research Request Task when a new PRR record is created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Prospect_Research_Request</fullName>
        <assignedTo>martin_fogarty@wgbh.org.qc</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Prospect Research Request</subject>
    </tasks>
</Workflow>
