<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CCEFTAlias_Set_Country_CAN</fullName>
        <field>Country__c</field>
        <formula>&quot;USA&quot;</formula>
        <name>CCEFTAlias.Set Country USA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CCEFTAlias_Set_Country_CAN2</fullName>
        <field>Country__c</field>
        <formula>&quot;CAN&quot;</formula>
        <name>CCEFTAlias.Set Country CAN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CCEFTAlias%2ESet Country CAN</fullName>
        <actions>
            <name>CCEFTAlias_Set_Country_CAN2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Alias__c.State__c</field>
            <operation>equals</operation>
            <value>AB,BC,MB,NB,NL,NS,NT,NU,ON,PE,QC,SK,YT</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CCEFTAlias%2ESet Country USA</fullName>
        <actions>
            <name>CCEFTAlias_Set_Country_CAN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Alias__c.State__c</field>
            <operation>equals</operation>
            <value>AL,AK,AZ,AR,CA,CO,CT,DE,DC,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC.SD,TN,TX.UT,VA,VT,WA,WV,WI,WY,AS,GU</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
