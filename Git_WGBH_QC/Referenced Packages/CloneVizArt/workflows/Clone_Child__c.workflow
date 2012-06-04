<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_Parent</fullName>
        <field>Parent_Unique_Name__c</field>
        <formula>TEXT( Parent_Object__c )</formula>
        <name>Update Unique Parent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Unique Parent</fullName>
        <actions>
            <name>Update_Unique_Parent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ensures uniqueness of parent object name</description>
        <formula>OR(ISNEW(), ISCHANGED( Parent_Object__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
