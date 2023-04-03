@isTest
private with sharing class AuditChatterServiceTest {
    @isTest
    static void postsToChatterIfError() {
        // GIVEN        
        StnryAssetEnrgyUse oldEu = new StnryAssetEnrgyUse();
        oldEu.Id = TestUtility.getFakeId(StnryAssetEnrgyUse.SObjectType);
        oldEu.Name = 'EU 1';
        
        StnryAssetEnrgyUse newEu = oldEu.clone(true, true, true, true);
        newEu.Audit_Approval_Status__c = 'Rejected';
        newEu.Audit_Error__c = 'For X reason';
        
        // WHEN
        List<FeedItem> posts = AuditChatterService.postToChatterIfError(
            new List<SObject>{ newEu },
            new Map<Id, SObject>{ oldEu.Id => oldEu },
            'StnryAssetEnrgyUse'
        );

        // THEN
        Assert.areEqual(1, posts.size());
        Assert.areEqual('Record rejected by auditor. Reason: For X reason', posts[0].Body);
    }

    @isTest
    static void isFeedTrackingEnabled() {
        Boolean isTrackingEnabled = AuditChatterService.isFeedTrackingEnabled('StnryAssetEnrgyUse');
        Assert.isNotNull(isTrackingEnabled);
    }
}