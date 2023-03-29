trigger StationaryAssetEnergyUse on StnryAssetEnrgyUse (after update) {
    AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'StnryAssetEnrgyUse');
}