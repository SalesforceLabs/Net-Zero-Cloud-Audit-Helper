import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getRecords from '@salesforce/apex/AuditController.getRecords';
import { footprints } from 'c/footprintInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AuditView extends LightningElement {
    cfObjectApiName;
    cfRecordId;
    cfRecord;
    itemRecords;
    itemIndex;
    itemRecordId;

    @wire(getRecord, {
        recordId: '$cfRecordId',
        fields: '$fields'
    })
    getCarbonFootprintRecord({ data, error }) {
        if (error) {
            console.error('getCarbonFootprintRecord error ', error);
            return;
        }
        if (data) {
            this.cfRecord = data;
        }
    }

    get fields() {
        return [`${this.cfObjectApiName}.Name`, `${this.cfObjectApiName}.AuditApprovalStatus`];
    }

    async connectedCallback() {
        let searchUrl;
        const isConsoleNavigation = await this.invokeWorkspaceAPI('isConsoleNavigation', {});
        if (isConsoleNavigation) {
            const tabInfo = await this.invokeWorkspaceAPI('getFocusedTabInfo', {});
            const urlString = await this.invokeWorkspaceAPI('getTabURL', { tabId: tabInfo.tabId });
            searchUrl = new URL(urlString).search;
        } else {
            searchUrl = window.location.search;
        }

        if (!searchUrl) {
            throw new Error("Failed to retrieve current page's URL");
        }
        // Parse parameters
        const urlParams = new URLSearchParams(searchUrl);
        if (urlParams.has('ws')) {
            const refUrl = decodeURIComponent(urlParams.get('ws'));
            const refUrlData = refUrl.match(
                /\/lightning\/r\/(\w*)\/(\w*)\/view/
            );
            if (refUrlData.length === 3) {
                this.cfObjectApiName = refUrlData[1];
                this.cfRecordId = refUrlData[2];
            }
        } else {
            this.cfRecordId = urlParams.get('id');
            this.cfObjectApiName = urlParams.get('objectApiName');
        }
        // Load items
        if (this.cfRecordId && this.cfObjectApiName) {
            try {
                const itemRecords = await getRecords({
                    footprintId: this.cfRecordId,
                    footprintApiName: this.cfObjectApiName
                });
                this.itemRecords = itemRecords;
                this.selectItem(null);
            } catch (error) {
                console.error('Failed to retrieve audit items: ', error);
            }
        }
    }

    invokeWorkspaceAPI(methodName, methodArgs) {
        return new Promise((resolve, reject) => {
          const apiEvent = new CustomEvent("internalapievent", {
            bubbles: true,
            composed: true,
            cancelable: false,
            detail: {
              category: "workspaceAPI",
              methodName: methodName,
              methodArgs: methodArgs,
              callback: (err, response) => {
                if (err) {
                    return reject(err);
                } else {
                    return resolve(response);
                }
              }
            }
          });
     
          window.dispatchEvent(apiEvent);
        });
      }

    selectItem(index) {
        this.itemIndex = index;
        this.itemRecordId = index === null ? null : this.itemRecords[index].id;
    }

    handleItemSelect(event) {
        this.selectItem(event.detail.itemIndex);
    }

    handleItemChange(event) {
        const change = event.detail;
        // Force refresh records
        const records = JSON.parse(JSON.stringify(this.itemRecords));
        records[this.itemIndex].status = change.value;
        this.itemRecords = records;
        // Move to next record if available or back to table if this is the last record
        if (this.itemIndex === this.totalItemCount -1) {
            this.selectItem(null);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Task Completed',
                    message: 'You reviewed all items in the audit queue.',
                    variant: 'success'
                })
            );
        } else {
            this.selectItem(this.itemIndex +1);
        }
    }

    get allItemsApproved() {
        return (this.itemRecords) ?
            this.itemRecords.filter(item => item.status !== 'Approved').length === 0 : false;
    }

    get hasNoSelection() {
        return this.itemRecordId === null;
    }

    get hasNoItems() {
        return this.totalItemCount === 0;
    }

    get itemObjectApiName() {
        return this.itemRecords?.[this.itemIndex].apiName;
    }

    get itemObjectLabel() {
        return footprints[this.cfObjectApiName].items[this.itemObjectApiName]
            .fullName;
    }

    get itemName() {
        if (!this.itemRecords) {
            return 'Loading...';
        }
        return `${this.itemRecords[this.itemIndex].name} (${
            this.itemObjectLabel
        })`;
    }

    get isMissingParameters() {
        return this.fRecordId === null || this.fObjectApiName === null;
    }

    get totalItemCount() {
        return this.itemRecords ? this.itemRecords.length : 0;
    }
}