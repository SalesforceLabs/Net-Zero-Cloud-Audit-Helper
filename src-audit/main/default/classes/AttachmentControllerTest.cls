@isTest
private with sharing class AttachmentControllerTest {
    @isTest
    static void getRecordAttachments() {
        // GIVEN
        Account acct = new Account(Name = 'ACME');
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
            Title          = 'MyFile',
            PathOnClient   = 'myfile.jpg',
            VersionData    = Blob.valueOf('Blahblah'),
            IsMajorVersion = true
        );
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.LinkedEntityId = acct.Id;
        contentDocumentLink.ContentDocumentId = documents[0].Id;
        contentDocumentLink.ShareType = 'V';
        contentDocumentLink.Visibility = 'AllUsers';
        insert contentDocumentLink;

        // WHEN
        List<AttachmentController.File> files = AttachmentController.getRecordAttachments(acct.Id);
        Assert.areEqual(1, files.size());
        Assert.areEqual(documents[0].Id, files[0].id);
        Assert.areEqual(documents[0].Title, files[0].title);
        Assert.areEqual('jpg', files[0].extension);
    }
}