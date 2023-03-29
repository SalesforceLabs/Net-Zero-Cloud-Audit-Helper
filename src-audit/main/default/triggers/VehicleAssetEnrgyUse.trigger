trigger VehicleAssetEnrgyUse on VehicleAssetEnrgyUse (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'VehicleAssetEnrgyUse');
}