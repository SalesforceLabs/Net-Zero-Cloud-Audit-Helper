import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AuditViewSubHeader extends NavigationMixin(LightningElement) {
    @api iconName;
    @api recordId;
    @api subtitle;
    @api title;
    @api showViewRecordButton;

    handleNavigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });

    }
}
