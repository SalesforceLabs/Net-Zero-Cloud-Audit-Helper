public with sharing class AuditChatterService {
    public static List<FeedItem> postToChatterIfError(List<sObject> newRecords, Map<Id, sObject> oldRecordMap, String sObjectType) {
        if (Test.isRunningTest() || isFeedTrackingEnabled(sObjectType)) {
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
                return postToChatter(recordsToPostTo);
            }
        }
        return new List<FeedItem>();
    }

    @TestVisible
    private static Boolean isFeedTrackingEnabled(String sObjectType) {
        SObjectType itemType = Schema.getGlobalDescribe().get(sObjectType);
        Schema.DescribeSObjectResult describeResult = itemType.getDescribe();
        return describeResult.isFeedEnabled();
    }

    private static List<FeedItem> postToChatter(Set<sObject> recordsToPostTo) {
        List<FeedItem> posts = new List<FeedItem>();
        for (sObject recordToPostTo : recordsToPostTo) {
            FeedItem post = new FeedItem();
            post.ParentId = recordToPostTo.Id;
            post.body = 'Record rejected by auditor. Reason: ' + recordToPostTo.get('Audit_Error__c');
            posts.add(post);
        }
        if (!Test.isRunningTest()) {
            insert as user posts;
        }
        return posts;
    }
}