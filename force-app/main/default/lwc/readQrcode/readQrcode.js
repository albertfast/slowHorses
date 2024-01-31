import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const QR_API_URL = 'https://api.qrserver.com/v1/read-qr-code/';


export default class ReadQrcode extends LightningElement {
    file;
    fileName;
    imgSrc;
    result;

    readQrCode() {
        const formData = new FormData();
        formData.append('file', this.file);

        fetch(QR_API_URL, {
            method: 'POST',
            //mode: 'no-cors',
            body: formData,
        })
        .then((res) => {
            if (!res.ok) {
                throw new Error(`An error occurred: ${res.status} - ${res.statusText}`);
            }
            return res.json();
        })
        .then((json) => {
            if (json.errorCode === 'RESOURCE_NOT_FOUND') {
                throw new Error('The requested resource was not found.');
            }
            this.result = JSON.stringify(json, null, 2);
            console.log(json);
        })
        .catch((error) => {
            console.error('Error:', error);

            const toast = new ShowToastEvent({
                title: 'An Error Occurred',
                message: error.message,
                variant: 'error',
            });
            this.dispatchEvent(toast);
        });
    }

    onFileChange(event) {
        const file = event.target.files[0];
        this.file = file;
        this.fileName = file.name;

        const reader = new FileReader();
        reader.onloadend = () => {
            this.imgSrc = reader.result;
        };
        reader.readAsDataURL(file);
    }
}
/* ilk hali
import { LightningElement } from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
const QR_API_URL = "https://api.qrserver.com/v1/read-qr-code";


export default class ReadQrcode extends LightningElement {
    file;
    fileName;
    imgSrc;
    result;

async readQrCode(){
    const formData = new FormData();
    formData.append("file", this.file);
    formData.append("outputformat", "json");

    const res = await fetch(QR_API_URL, {
        method: "POST",
        body: formData
    });

    if (!res.ok) {
        // Handle general errors
        const errorMessage = `An error occurred: ${res.status} - ${res.statusText}`;
        console.error(errorMessage);

        const toast = new ShowToastEvent({
            title: "An Error Occurred",
            message: errorMessage,
            variant: "error"
        });
        this.dispatchEvent(toast);
        return;
    }

    const json = await res.json();

    if (json.errorCode === 'RESOURCE_NOT_FOUND') {
        // Handle specific error for resource not found
        console.error('The requested resource was not found.');

        const toast = new ShowToastEvent({
            title: "Resource Not Found",
            message: "The requested resource was not found.",
            variant: "error"
        });
        this.dispatchEvent(toast);
        return;
    }

    // Process the response as needed
    this.result = JSON.stringify(json, null , 2);
    console.log(res);
}


    onFileChange(event){
        const file = event.target.files[0];
        this.file = file;
        this.fileName = file.name;
        const reader = new FileReader();
        reader.onloadend = () => {
            this.imgSrc = reader.result;
        };
        reader.readAsDataURL(file);
    }
} */

