public with sharing class AuditController {

    @AuraEnabled(cacheable=true)
    public static List<RecordForDatatable> getRecords(Id footprintId, String footprintApiName) {
        List<RecordForDatatable> records = new List<RecordForDatatable>();

        Footprint footprint = FootprintInfo.footprints.get(footprintApiName);
        if (footprint == null) {
            throw new AuditException('Failed to load footprint info for object '+ footprintApiName);
        }
        for (String childApiName : footprint.items.keySet()) {
            Footprint.Item item = footprint.items.get(childApiName);
            List<sObject> recordsToTransform = Database.query('SELECT Name, Audit_Approval_Status__c, Audit_Error__c FROM ' + childApiName + ' WHERE ' + item.parentRelationshipName + '= :footPrintId WITH SECURITY_ENFORCED');
            records.addAll(transformForDatatable(recordsToTransform, childApiName));
        }

        return records;
    }

    private static List<RecordForDatatable> transformForDatatable(List<sObject> sobjects, String apiName) {
        List<RecordForDatatable> records = new List<RecordForDatatable>();
        for (sObject sobj : sobjects) {
            RecordForDatatable record = new RecordForDatatable();
            record.id = (String)sobj.get('Id');
            record.name = (String)sobj.get('Name');
            record.apiName = apiName;
            record.status = (String)sobj.get('Audit_Approval_Status__c');
            record.error = (String)sobj.get('Audit_Error__c');
            records.add(record);
        }
        return records;
    }

    public class RecordForDatatable {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String apiName;
        @AuraEnabled public String status;
        @AuraEnabled public String error;
    }

    public class AuditException extends Exception {}
}
