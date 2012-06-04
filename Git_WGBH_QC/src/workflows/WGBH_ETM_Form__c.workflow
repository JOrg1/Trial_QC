<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ETM_Final_Approval</fullName>
        <description>ETM Final Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/ETM_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>ETM_Rejection</fullName>
        <description>ETM Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>ATS/ETM_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>ETM_Status</fullName>
        <field>Status__c</field>
        <literalValue>HR Director Approved</literalValue>
        <name>ETM Status: HR Director Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ETM_Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ETM Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ETM_Status_HR_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>ETM Status: HR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ETM_Status_Pending_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>ETM Status: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ETM_Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>ETM Status: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_New_ETM</fullName>
        <field>Status__c</field>
        <literalValue>New Memo</literalValue>
        <name>Status Change: New ETM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ETM_Status</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Update ETM Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
