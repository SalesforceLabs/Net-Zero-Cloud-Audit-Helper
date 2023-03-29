@isTest
private with sharing class AuditChatterServiceTest {
    @isTest
    static void postsToChatterIfError() {
        if (!AuditChatterService.isFeedTrackingEnabled('StnryAssetEnrgyUse'))
            return;

        // GIVEN
        ElectricityEmssnFctrSet elecEmissionsFactor = new ElectricityEmssnFctrSet();
        elecEmissionsFactor.Name='elecEmissionsFactor1';
        elecEmissionsFactor.LocationBasedBiomassMixPct = 100;
        elecEmissionsFactor.MarketBasedBiomassMixPct = 100;
        insert elecEmissionsFactor;

        OtherEmssnFctrSet otherEmissionsFactor = new OtherEmssnFctrSet();
        otherEmissionsFactor.Name='otherEmissionsFactor1';
        insert otherEmissionsFactor;

        StnryAssetEnvrSrc source = new StnryAssetEnvrSrc();
        source.Name = 'SOURCE1';
        source.ElectricityEmssnFctrId = elecEmissionsFactor.Id;
        source.OtherEmssnFctrId = otherEmissionsFactor.Id;
        insert source; 

        StnryAssetEnrgyUse eu = new StnryAssetEnrgyUse();
        eu.Name = 'EU 1';
        eu.StnryAssetEnvrSrcId = source.Id;
        eu.FuelConsumptionUnit='ccf';
        eu.FuelType = 'Electricity';
        insert eu;

        // WHEN
        eu.Audit_Approval_Status__c = 'Rejected';
        eu.Audit_Error__c = 'For X reason';
        update eu;

        // THEN
        List<FeedItem> posts = [SELECT Body FROM FeedItem WHERE ParentId = :eu.Id];
        Assert.areEqual(1, posts.size());
        Assert.areEqual('Record rejected by auditor. Reason: For X reason', posts[0].Body);
    }
}