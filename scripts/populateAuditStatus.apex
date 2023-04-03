List<AirTravelEnrgyUse> eus = [SELECT nzc_ah__Audit_Approval_Status__c FROM AirTravelEnrgyUse];
for (AirTravelEnrgyUse eu : eus) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus;
List<FrgtHaulingEnrgyUse> eus2 = [SELECT nzc_ah__Audit_Approval_Status__c FROM FrgtHaulingEnrgyUse];
for (FrgtHaulingEnrgyUse eu : eus2) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus2;
List<GroundTravelEnrgyUse> eus3 = [SELECT nzc_ah__Audit_Approval_Status__c FROM GroundTravelEnrgyUse];
for (GroundTravelEnrgyUse eu : eus3) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus3;
List<HotelStayEnrgyUse> eus4 = [SELECT nzc_ah__Audit_Approval_Status__c FROM HotelStayEnrgyUse];
for (HotelStayEnrgyUse eu : eus4) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus4;
List<RentalCarEnrgyUse> eus5 = [SELECT nzc_ah__Audit_Approval_Status__c FROM RentalCarEnrgyUse];
for (RentalCarEnrgyUse eu : eus5) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus5;
List<GeneratedWaste> eus6 = [SELECT nzc_ah__Audit_Approval_Status__c FROM GeneratedWaste];
for (GeneratedWaste eu : eus6) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus6;
List<StnryAssetWaterActvty> eus7 = [SELECT nzc_ah__Audit_Approval_Status__c FROM StnryAssetWaterActvty];
for (StnryAssetWaterActvty eu : eus7) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus7;
List<StnryAssetEnrgyUse> eus8 = [SELECT nzc_ah__Audit_Approval_Status__c FROM StnryAssetEnrgyUse];
for (StnryAssetEnrgyUse eu : eus8) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus8;
List<VehicleAssetEnrgyUse> eus9 = [SELECT nzc_ah__Audit_Approval_Status__c FROM VehicleAssetEnrgyUse];
for (VehicleAssetEnrgyUse eu : eus9) {
  eu.nzc_ah__Audit_Approval_Status__c = 'Pending Approval';
}
update eus9;

