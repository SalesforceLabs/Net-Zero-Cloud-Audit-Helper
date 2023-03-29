public with sharing class AuditChatterService {
    public static void postToChatterIfError(List<sObject> newRecords, Map<Id, sObject> oldRecordMap, String sObjectType) {
        if (isFeedTrackingEnabled(sObjectType)) {
            {
                Set<sObject> recordsToPostTo = new Set<sObject>();
                for (sObject newRecord : newRecords) {
                    sObject oldRecord = oldRecordMap.get(newRecord.Id);
                    String auditError = (String) newRecord.get('Audit_Error__c');
                    String oldAuditError = (String) oldRecord.get('Audit_Error__c');
                    if (auditError != null && auditError != oldAuditError) {
                        recordsToPostTo.add(newRecord);
                    }
                }
                postToChatter(recordsToPostTo);
            }
        }
        
    }

    @TestVisible
    private static Boolean isFeedTrackingEnabled(String sObjectType) {
        SObjectType itemType = Schema.getGlobalDescribe().get(sObjectType);
        Schema.DescribeSObjectResult describeResult = itemType.getDescribe();
        return describeResult.isFeedEnabled();
    }

    private static void postToChatter(Set<sObject> recordsToPostTo) {
        List<FeedItem> posts = new List<FeedItem>();
        for (sObject recordToPostTo : recordsToPostTo) {
            FeedItem post = new FeedItem();
            post.ParentId = recordToPostTo.Id;
            post.body = 'Record rejected by auditor. Reason: ' + recordToPostTo.get('Audit_Error__c');
            posts.add(post);
        }
        insert as user posts;
    }
}