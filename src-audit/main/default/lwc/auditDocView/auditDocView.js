import { LightningElement, wire, api } from 'lwc';
import getRecordAttachments from '@salesforce/apex/AttachmentController.getRecordAttachments';

export default class AuditDocView extends LightningElement {
    attachment; // undefined when loading, null when there's no attachment
    _recordId;

    @api
    set recordId(value) {
        this._recordId = value;
        this.attachment = undefined;
    }
    get recordId() {
        return this._recordId;
    }

    @wire(getRecordAttachments, {
        recordId: '$recordId'
    })
    getRecordAttachmentsWire({ data, error }) {
        if (error) {
            console.error('Failed to retrieve attachments: ', error);
            return;
        }
        if (data) {
            this.attachment = data.length === 0 ? null : data[0];
        }
    }

    get isAttachmentLoading() {
        return this.attachment === undefined;
    }

    get headerTitle() {
        return this.attachment ? this.attachment.title : 'Record has no attachment';
    }

    get hasNoAttachment() {
        return this.attachment === null;
    }

    get isPdf() {
        return this.attachment.extension === 'pdf';
    }

    get attachmentUrl() {
        return `/sfc/servlet.shepherd/document/download/${this.attachment.id}`;
    }
}
