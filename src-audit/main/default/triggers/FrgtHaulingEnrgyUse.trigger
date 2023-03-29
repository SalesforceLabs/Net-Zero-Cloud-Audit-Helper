trigger FrgtHaulingEnrgyUse on FrgtHaulingEnrgyUse (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'FrgtHaulingEnrgyUse');
}