import { api, wire, LightningElement } from 'lwc';
import { getFieldValue } from 'lightning/uiRecordApi';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AuditErrorModal from 'c/auditErrorModal';

export default class ApprovalStatus extends LightningElement {
    @api recordId;
    @api objectApiName;
    record;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: '$fields'
    })
    record;

    get auditApprovalStatus() {
        return getFieldValue(
            this.record.data,
            `${this.objectApiName}.Audit_Approval_Status__c`
        );
    }

    get fields() {
        return [`${this.objectApiName}.Audit_Approval_Status__c`];
    }

    get isApproved() {
        return this.auditApprovalStatus === 'Approved';
    }

    get isPending() {
        return this.auditApprovalStatus === null || this.auditApprovalStatus === 'Pending Approval'
    }

    get isRejected() {
        return this.auditApprovalStatus === 'Rejected';
    }

    get approveIcon() {
        return this.isApproved ? 'utility:priority' : undefined;
    }

    get rejectIcon() {
        return this.isRejected ? 'utility:priority' : undefined;
    }

    async handleRejectClick() {
        const comment = await AuditErrorModal.open({
            size: 'medium',
            description: 'Modal to specify a rejection reason'
        });
        this.updateRecord('Rejected', comment);
    }

    async handleApproveClick() {
        this.updateRecord('Approved');
    }

    async handleRecallApprovalClick() {
        this.updateRecord('Pending Approval');
    }

    async updateRecord(status, comment) {
        const recordInput = {
            fields: {
                Id: this.record.data.id,
                Audit_Error__c: (comment != undefined) ? comment: '',
                Audit_Approval_Status__c: status
            }
        };
        try {
            await updateRecord(recordInput);
            const changeEvent = new CustomEvent('change', {
                detail: {
                    id: this.record.data.id,
                    field: `${this.objectApiName}.Audit_Approval_Status__c`,
                    value: status
                }
            });
            this.dispatchEvent(changeEvent);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: this.getSuccessMessage(status),
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.getErrorMessage(status),
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    getSuccessMessage(status) {
        let message;
        if (status === 'Approved') {
            message = 'Record approved'
        } else if (status == 'Pending Approval') {
            message = 'Approval recalled'
        } else {
            message = 'Record rejected';
        }
        return message;
    }

    getErrorMessage(status) {
        let message;
        if (status === 'Approved') {
            message = 'Error approving item'
        } else if (status == 'Pending Approval') {
            message = 'Error recalling approval'
        } else {
            message = 'Error rejecting item';
        }
        return message;
    }
}
