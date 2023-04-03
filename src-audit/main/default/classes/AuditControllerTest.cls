@isTest
private with sharing class AuditControllerTest {
    @isTest
    static void getRecords() {
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

        StnryAssetCrbnFtprnt footprint = new StnryAssetCrbnFtprnt();
        footprint.Name = 'FT 1';
        insert footprint;

        StnryAssetEnrgyUse eu = new StnryAssetEnrgyUse();
        eu.Name = 'EU 1';
        eu.StnryAssetEnvrSrcId = source.Id;
        eu.FuelConsumptionUnit='ccf';
        eu.FuelType = 'Electricity';
        eu.StnryAssetCrbnFtprntId = footprint.Id;
        eu.Audit_Approval_Status__c = 'Approved';
        insert eu;

        // WHEN
        List<AuditController.RecordForDatatable> records = AuditController.getRecords(footprint.Id, 'StnryAssetCrbnFtprnt');

        // THEN
        Assert.areEqual(1, records.size());
        Assert.areEqual('EU 1', records[0].name);
        Assert.areEqual('StnryAssetEnrgyUse', records[0].apiName);
        Assert.areEqual('Approved', records[0].status);

    }

    @isTest
    static void transformForDatatable() {
        List<SObject> records = new List<SObject>{
            new StnryAssetEnrgyUse(
                Id = TestUtility.getFakeId(StnryAssetEnrgyUse.SObjectType),
                Name = 'testName',
                Audit_Approval_Status__c = 'testStatus',
                Audit_Error__c = 'testError'
            )
        };

        List<AuditController.RecordForDatatable> dtRecords = AuditController.transformForDatatable(records, 'StnryAssetEnrgyUse');

        Assert.areEqual(records.size(), dtRecords.size());
        Assert.areEqual('testName', dtRecords[0].name);
    }
}