trigger RentalCarEnrgyUse on RentalCarEnrgyUse (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'RentalCarEnrgyUse');
}