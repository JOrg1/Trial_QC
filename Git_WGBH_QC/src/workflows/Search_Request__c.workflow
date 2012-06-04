<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RecallSearchRequestBatch</fullName>
        <field>IsExecuteNextBatch__c</field>
        <literalValue>0</literalValue>
        <name>RecallSearchRequestBatch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RecallSearchRequestBatch</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Search_Request__c.IsExecuteNextBatch__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Search_Request__c.NextBatchTime__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
