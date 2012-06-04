<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_Premium_Benefit_ready_to_process</fullName>
        <description>Notification - Premium/Benefit ready to process</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Planned_Giving/Notification_Premium_Benefit_ready_to_process</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Premium_Benefit_Ready_to_Process</fullName>
        <field>Fulfillment_Status__c</field>
        <literalValue>Ready to Process</literalValue>
        <name>Update Premium/Benefit-Ready to Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Premium%2FBenefit ready to process</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Fulfillment_Status__c</field>
            <operation>equals</operation>
            <value>Suspended</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Resume_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
