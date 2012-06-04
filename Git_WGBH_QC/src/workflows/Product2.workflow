<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deactivate_a_Premium_or_Premium_Package</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate a Premium or Premium Package</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deactivate a Premium or Premium Package</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Product2.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
