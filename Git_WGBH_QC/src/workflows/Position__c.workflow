<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Job_Requisition_Creator</fullName>
        <description>Alert Job Requisition Owner (Hiring Manager)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice</template>
    </alerts>
    <alerts>
        <fullName>Alert_Job_Requisition_Owner_Hiring_Manager_of_Rejection</fullName>
        <description>Alert Job Requisition Owner (Hiring Manager) of Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Approver_email_to_the_creator</fullName>
        <description>Approver email to the creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_COO_Reject</fullName>
        <description>Email Alert: COO Reject</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Email_Budget_Office</fullName>
        <ccEmails>sarah_vershon@wgbh.org</ccEmails>
        <ccEmails>brian_wainwright@wgbh.org</ccEmails>
        <description>Email Budget Office</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice_budget_office</template>
    </alerts>
    <alerts>
        <fullName>Email_HR_Assistant</fullName>
        <description>Email HR Assistant</description>
        <protected>false</protected>
        <recipients>
            <recipient>alyssa_mullen@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sarah.vershon@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice_budget_office</template>
    </alerts>
    <alerts>
        <fullName>Email_to_next_approver</fullName>
        <description>Email to next approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/position_approval</template>
    </alerts>
    <alerts>
        <fullName>Email_to_next_approver1</fullName>
        <description>Email to next approver1</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/position_approval</template>
    </alerts>
    <alerts>
        <fullName>Email_to_record_creater</fullName>
        <description>Email to record creater</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>brian_wainwright@wgbh.org.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice</template>
    </alerts>
    <alerts>
        <fullName>Email_to_record_creater1</fullName>
        <description>Email to record creater1</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Email_to_record_owner</fullName>
        <description>Email to record owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice</template>
    </alerts>
    <alerts>
        <fullName>HR_Rejected</fullName>
        <description>HR Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Notice_of_Approval_HR</fullName>
        <description>Notice of Approval: HR</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>kamlesh@wgbh.com.qc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/final_approval_notice_budget_office</template>
    </alerts>
    <alerts>
        <fullName>Notify_VP_of_HR</fullName>
        <ccEmails>mindy_braithwaite@wgbh.org</ccEmails>
        <description>Notify VP of HR</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>ATS/position_approval</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email_to_record_owner</fullName>
        <description>Rejection Email to record owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Rejection_email_to_the_owner</fullName>
        <description>Rejection email to the owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATS/Final_Rejection_Notice</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approve_reject_field_update</fullName>
        <field>Approve_Reject__c</field>
        <name>Approve/reject field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Open - Approved</literalValue>
        <name>Status Update: Open - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Updatee</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>Status Update: Closed - Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_change</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Field change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Status_field_update</fullName>
        <field>Status__c</field>
        <literalValue>Open - Approved</literalValue>
        <name>Final Status field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JobReq_Status_Pending_Approval</fullName>
        <description>Initial submission for approval updates job req status to Pending Approval</description>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Status Change: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Requisition_Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Open - Approved</literalValue>
        <name>Job Requisition Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_field_update</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>Rejection field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pending_Approval</fullName>
        <description>Set Requisition Status to Pending Approval after submitting for approval</description>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Set Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change</fullName>
        <field>Status__c</field>
        <literalValue>HR Approved</literalValue>
        <name>Status Change: HR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change1</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>Status Change1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change2</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>Status Change2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change3</fullName>
        <field>Status__c</field>
        <literalValue>Open - Approved</literalValue>
        <name>Status Change3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change4</fullName>
        <field>Status__c</field>
        <literalValue>Closed - Not Approved</literalValue>
        <name>Status Change4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_HR_Approved</fullName>
        <description>Update status field to HR Approved</description>
        <field>Status__c</field>
        <literalValue>HR Approved</literalValue>
        <name>Status Change: HR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_Pending_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Status Change: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Open - Rejected</literalValue>
        <name>Status Update: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_COO_Approved</fullName>
        <field>Status__c</field>
        <literalValue>COO Approved</literalValue>
        <name>Status Update: COO Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_HR_Approved</fullName>
        <field>Status__c</field>
        <literalValue>VP HR Approved</literalValue>
        <name>Status Update: VP HR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_field_update</fullName>
        <field>Status__c</field>
        <literalValue>Open - Approved</literalValue>
        <name>Status field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approve%2Freject field update</fullName>
        <actions>
            <name>Approve_reject_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Position__c.Status__c</field>
            <operation>equals</operation>
            <value>New Requisition</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
