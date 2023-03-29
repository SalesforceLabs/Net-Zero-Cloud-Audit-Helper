trigger HotelStayEnrgyUse on HotelStayEnrgyUse (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'HotelStayEnrgyUse');
}