public with sharing class AttachmentController {
    private static Set<String> SUPPORTED_FILE_TYPES = new Set<String>{
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'bmp'
    };

    @AuraEnabled(cacheable=true scope='global')
    public static List<File> getRecordAttachments(String recordId) {
        // Get record doc IDs
        List<ContentDocumentLink> docLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        Set<Id> docIDs = new Set<Id>();
        for (ContentDocumentLink docLink : docLinks) {
            docIDs.add(docLink.ContentDocumentId);
        }

        // Filter docs by supported types
        List<ContentVersion> filteredDocs = [
            SELECT ContentDocumentId, FileExtension, Title
            FROM ContentVersion
            WHERE
                ContentDocumentId IN :docIDs
                AND FileExtension IN :SUPPORTED_FILE_TYPES
                AND IsLatest = TRUE
        ];
        List<File> files = new List<File>();
        for (ContentVersion docVersion : filteredDocs) {
            files.add(
                new File(
                    docVersion.ContentDocumentId,
                    docVersion.Title,
                    docVersion.FileExtension
                )
            );
        }
        return files;
    }

    public class File {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String extension;

        public File(Id id, String title, String extension) {
            this.id = id;
            this.title = title;
            this.extension = extension;
        }
    }
}
