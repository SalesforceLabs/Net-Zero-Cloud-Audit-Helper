trigger GeneratedWaste on GeneratedWaste (after update) {
  AuditChatterService.postToChatterIfError(Trigger.new, Trigger.oldMap, 'GeneratedWaste');
}