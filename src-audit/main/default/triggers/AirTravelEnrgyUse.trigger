trigger AirTravelEnrgyUse on AirTravelEnrgyUse (after update) {
    AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'AirTravelEnrgyUse');
}