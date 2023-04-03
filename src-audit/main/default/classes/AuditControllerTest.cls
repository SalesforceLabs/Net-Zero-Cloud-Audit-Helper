@isTest
public class AuditControllerTest {
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

        Id recordTypeId = Schema.SObjectType.StnryAssetEnvrSrc.getRecordTypeInfos()[0].getRecordTypeId();
        StnryAssetEnvrSrc source = new StnryAssetEnvrSrc();
        source.RecordTypeId = recordTypeId;
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
}