import { LightningElement } from 'lwc';

export default class ServerComponent extends LightningElement {
    connectedCallback() {
        // Salesforce Apex servisi üzerinden Express sunucusuna proxy yapılıyor
        fetch('https://api.qrserver.com/v1/read-qr-code')
    .then(response => response.json())
    .then(data => {
        console.log('Sunucu Yanıtı:', data);
        // İhtiyaca göre yanıt verilerini işleyin
    })
    .catch(error => console.error('Hata:', error));

    }
}
