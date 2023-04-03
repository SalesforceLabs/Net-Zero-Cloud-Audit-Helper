@isTest
private with sharing class AuditChatterServiceTest {
    @isTest
    static void postsToChatterIfError_works_with_feedTracking() {
        // GIVEN
        StnryAssetEnrgyUse oldEu = new StnryAssetEnrgyUse();
        oldEu.Name = 'EU 1';

        StnryAssetEnrgyUse newEU = oldEu.clone(true, true, true, true);
        newEU.Audit_Approval_Status__c = 'Rejected';
        newEU.Audit_Error__c = 'For X reason';

        // WHEN
        List<FeedItem> posts = AuditChatterService.postToChatterIfError(
            new List<SObject>{ newEU },
            new Map<Id, SObject>{ oldEu.Id => oldEu },
            'StnryAssetEnrgyUse'
        );

        // THEN
        Assert.areEqual(1, posts.size());
        Assert.areEqual('Record rejected by auditor. Reason: For X reason', posts[0].Body);
    }

    @isTest
    static void isFeedTrackingEnabled_works() {
        Boolean isTrackingEnabled = AuditChatterService.isFeedTrackingEnabled('StnryAssetEnrgyUse');
        Assert.isNotNull(isTrackingEnabled);
    }
}