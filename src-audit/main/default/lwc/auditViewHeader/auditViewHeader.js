import { LightningElement, api } from 'lwc';
import { getFieldValue } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AuditViewHeader extends LightningElement {
    @api allItemsApproved;
    @api currentItemIndex;
    @api totalItemCount;
    @api cfRecord;

   async handleApprove() {
        const recordInput = {
            fields: {
                Id: this.cfRecord.id,
                AuditApprovalStatus: 'Approved'
            }
        };
        try {
            await updateRecord(recordInput);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Footprint record approved',
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error approving footprint record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    handleBegin() {
        this.currentItemIndex = 0;
        this.dispatchItemSelectEvent();
    }

    handlePrevious() {
        if (!this.hasNoPreviousItem) {
            this.currentItemIndex--;
            this.dispatchItemSelectEvent();
        }
    }

    handleNext() {
        if (!this.hasNoNextItem) {
            this.currentItemIndex++;
            this.dispatchItemSelectEvent();
        }
    }

    handleShowOverview() {
        this.currentItemIndex = null;
        this.dispatchItemSelectEvent();
    }

    dispatchItemSelectEvent() {
        const evt = new CustomEvent('itemselect', {
            detail: { itemIndex: this.currentItemIndex }
        });
        this.dispatchEvent(evt);
    }

    get hasNoSelection() {
        return this.currentItemIndex === null;
    }

    get hasSelection() {
        return (
            this.currentItemIndex !== null &&
            this.currentItemIndex !== undefined
        );
    }

    get hasNoItems() {
        return this.totalItemCount === 0;
    }

    get hasNoNextItem() {
        return this.currentItemIndex === this.totalItemCount - 1;
    }

    get hasNoPreviousItem() {
        return this.currentItemIndex === 0;
    }

    get headerText() {
        if (this.cfRecord) {
            return getFieldValue(
                this.cfRecord,
                `${this.cfRecord.apiName}.Name`
            );
        }
        return 'Footprint Audit';
    }

    get approvalStatus() {
        if (this.cfRecord) {
            return getFieldValue(
                this.cfRecord,
                `${this.cfRecord.apiName}.AuditApprovalStatus`
            );
        }
        return null;
    }

    get isApproved() {
        return this.approvalStatus === 'Approved';
    }

    get isNotApproved() {
        return !this.isApproved;
    }

    get isApproveButtonDisabled() {
        return (this.isApproved || !this.allItemsApproved)
    }

    get progressLabel() {
        return `${this.currentItemIndex + 1} of ${this.totalItemCount} items`;
    }

    get progressValue() {
        return Math.floor(
            ((this.currentItemIndex + 1) / this.totalItemCount) * 100
        );
    }
}
