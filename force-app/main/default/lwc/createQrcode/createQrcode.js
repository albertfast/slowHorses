import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const QR_API_URL = 'https://api.qrserver.com/v1/create-qr-code';

export default class CreateQrcode extends LightningElement {
    url = '';
    imgSrc = '';

    createQrcodeWithDelay() {
        // Set a delay of 2 seconds (2000 milliseconds)
        setTimeout(() => {
            this.createQrcode();
        }, 2000);
    }

    createQrcode() {
        const apiUrl = `${QR_API_URL}/?data=${encodeURIComponent(this.url)}&size=100x100`;

        fetch(apiUrl, { method: 'GET' })
            .then((res) => {
                if (!res.ok) {
                    // Handle Error
                    const toast = new ShowToastEvent({
                        title: 'An Error Occurred',
                        message: res.statusText,
                        variant: 'error',
                    });
                    this.dispatchEvent(toast);
                }
                return res.blob();
            })
            .then((blob) => {
                return new Promise((resolve) => {
                    const reader = new FileReader();
                    reader.onloadend = () => {
                        resolve(reader.result);
                    };
                    reader.readAsDataURL(blob);
                });
            })
            .then((image) => {
                this.imgSrc = image;
            })
            .catch((error) => {
                console.error('Error fetching or processing QR code:', error);
                const toast = new ShowToastEvent({
                    title: 'An Error Occurred',
                    message: 'Failed to fetch or process QR code.',
                    variant: 'error',
                });
                this.dispatchEvent(toast);
            });
    }

    onUrlChange(event) {
        this.url = event.target.value;
    }
}
