@RestResource(urlMapping='/proxy/*')
global with sharing class ProxyController {

    @HttpGet
    global static String doGet() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.qrserver.com/v1/read-qr-code');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }
}
