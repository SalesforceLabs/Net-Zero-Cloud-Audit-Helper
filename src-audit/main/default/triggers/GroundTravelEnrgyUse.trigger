trigger GroundTravelEnrgyUse on GroundTravelEnrgyUse (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'GroundTravelEnrgyUse');
}