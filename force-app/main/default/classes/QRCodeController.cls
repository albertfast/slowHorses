public with sharing class QRCodeController {
    @AuraEnabled(cacheable=true)
    public static String readQRCode(Id contentVersionId, String logoImageUrl) {
        return QRCodeService.readQRCode(contentVersionId, logoImageUrl);
    }
}



