public class QRCodeService {
    public static String readQRCode(Id contentVersionId, String logoImageUrl) {
        try {
            if (contentVersionId == null || String.valueOf(contentVersionId).length() != 18) {
                // Invalid or null contentVersionId
                return 'Error: Invalid or null ContentVersion Id.';
            }

            List<ContentVersion> contents = [SELECT VersionData FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];

            if (contents != null && !contents.isEmpty()) {
                ContentVersion content = contents[0];

                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://api.qrserver.com/v1/read-qr-code/');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'multipart/form-data');
                request.setHeader('outputformat', 'json');
                request.setBodyAsBlob(content.VersionData);

                Http http = new Http();
                HttpResponse response = http.send(request);

                if (response.getStatusCode() == 200) {
                    return response.getBody();
                } else {
                    return 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
                }
            } else {
                // No ContentVersion record found for the provided Id
                return 'Error: No ContentVersion record found for the provided Id.';
            }
        } catch (Exception e) {
            // Log the exception details
            System.debug('Exception: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }
}
