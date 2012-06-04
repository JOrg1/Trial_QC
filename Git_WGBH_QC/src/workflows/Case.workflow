<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Date</fullName>
        <field>contact_date__c</field>
        <formula>today()</formula>
        <name>Contact Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Date_update</fullName>
        <field>contact_date__c</field>
        <name>Contact Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>fullCircle_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>cate_twohill@wgbh.org.qc</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>fullCircle Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact Date update</fullName>
        <actions>
            <name>Contact_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When status changes to closed, then Contact date will be automatically changed to current date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>fullCircle Case Owner</fullName>
        <actions>
            <name>fullCircle_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>fullCircle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Salerno,Yahns,Twohill,haywood,dunbar,ansari,kitzis,atwood,wainwright,eammano</value>
        </criteriaItems>
        <description>When a fullCircle Case is created, the case will be assigned to one specific person at the cleint</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
