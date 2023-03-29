trigger StnryAssetWaterActvty on StnryAssetWaterActvty (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'StnryAssetWaterActvty');
}