<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_on_CR_Creation</fullName>
        <description>Notify on CR Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sample_Email_Templates/CR_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_on_CR_Status_Update</fullName>
        <description>Notify on CR Status Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sample_Email_Templates/CR_Status_Update_Notification</template>
    </alerts>
    <rules>
        <fullName>CR Creation Notification</fullName>
        <actions>
            <name>Notify_on_CR_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Change_Request__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CR Status Update Notification</fullName>
        <actions>
            <name>Notify_on_CR_Status_Update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISNEW()), ISCHANGED( Decision__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
