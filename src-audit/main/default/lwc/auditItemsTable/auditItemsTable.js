import { LightningElement, api } from 'lwc';
import { footprints } from 'c/footprintInfo';

const TABLE_COLUMNS = [
    { label: 'Name', fieldName: 'name' },
    {
        hideLabel: true,
        label: 'Icon',
        iconName: 'utility:bucket',
        cellAttributes: { iconName: { fieldName: 'icon' } },
        initialWidth: 50,
        hideDefaultActions: true
    },
    { label: 'Type', fieldName: 'type' },
    {
        label: 'Audit Status',
        fieldName: 'status',
        actions: [
            { label: 'All', checked: true, name: 'show_all' },
            { label: 'Approved', checked: false, name: 'show_approved' },
            {
                label: 'Pending Approval',
                checked: false,
                name: 'show_pending_approval'
            },
            { label: 'Rejected', checked: false, name: 'show_rejected' },
        ]
    },
    { label: 'Audit Error', fieldName: 'error' },
    {
        label: 'Action',
        type: 'button',
        typeAttributes: {
            label: 'Audit',
            name: 'audit'
        },
        initialWidth: 100
    }
];
const HEADER_ACTIONS = [ 'show_all', 'show_approved', 'show_pending_approval', 'show_rejected'];

export default class AuditItemsTable extends LightningElement {
    columns = TABLE_COLUMNS;
    activeFilter;
    filteredItems;
    allItems;

    @api
    set objectApiName(value) {
        this._objectApiName = value;
        this.formatAndFilterItems();
    }
    get objectApiName() {
        return this._objectApiName;
    }

    @api
    set records(values) {
        this._records = values;
        this.formatAndFilterItems();
    }
    get records() {
        return this._records;
    }

    @api
    forceRefresh() {
        this.formatAndFilterItems();
    }

    handleHeaderAction(event) {
        // Retrieves the name of the selected filter
        const actionName = event.detail.action.name;
        
        // Only handle custom filter actions
        if (HEADER_ACTIONS.includes(actionName)) {
            // Retrieves the current column definition
            // based on the selected filter
            const colDef = event.detail.columnDefinition;
            const columns = this.columns;
            const activeFilter = this.activeFilter;
            if (actionName !== activeFilter) {
                const idx = columns.findIndex(
                    (column) => column.fieldName === colDef.fieldName
                );
                // Update the column definition with the updated actions data
                const actions = columns[idx].actions;
                actions.forEach((action) => {
                    action.checked = action.name === actionName;
                });
                this.activeFilter = actionName;
                this.filterItems();
                this.columns = JSON.parse(JSON.stringify(columns));
            }
        }
    }

    handleRowAction(event) {
        const data = event.detail;
        if (data.action?.name === 'audit') {
            const itemIndex = this.allItems.findIndex(
                (item) => item.id === data.row.id
            );
            const evt = new CustomEvent('audititem', {
                detail: { itemIndex }
            });
            this.dispatchEvent(evt);
        }
    }

    formatAndFilterItems() {
        if (!this._records || !this._objectApiName) {
            return [];
        }

        const formatter = footprints[this._objectApiName];
        if (!formatter) {
            console.error(
                `Failed to find a formatter for ${this._objectApiName}`
            );
            throw new Error(
                `Failed to find a formatter for ${this._objectApiName}`
            );
        }
        this.allItems = this._records.map((item) => {
            const formattedItem = formatter.items[item.apiName];
            if (!formattedItem) {
                throw new Error(
                    `Failed to format item of type ${item.apiName} and parent ${this._objectApiName}`
                );
            }
            return {
                id: item.id,
                name: item.name,
                type: formattedItem.fullName,
                icon: formattedItem.icon,
                status: item.status,
                error: item.error
            };
        });
        this.filterItems();
    }

    filterItems() {
        if (this.activeFilter === 'show_approved') {
            this.filteredItems = this.allItems.filter(row => row.status === 'Approved');
        } else if (this.activeFilter === 'show_pending_approval') {
            this.filteredItems = this.allItems.filter(row => row.status !== 'Approved');
        } else if (this.activeFilter === 'show_rejected') {
            this.filteredItems = this.allItems.filter(row => row.status !== 'Rejected');
        } else {
            this.filteredItems = this.allItems;
        }
    }
}
