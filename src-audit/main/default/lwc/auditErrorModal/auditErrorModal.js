import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class AuditErrorModal extends LightningModal {
    @api content;

    handleReject() {
        const comment = this.template.querySelector('lightning-textarea').value;
        this.close(comment);
    }
}