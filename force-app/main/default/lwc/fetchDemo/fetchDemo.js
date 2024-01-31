import { LightningElement } from 'lwc';

export default class FetchDemo extends LightningElement {
    imgURL;
    endPoint = 'https://some-random-api.ml/endpoints/animal/dog';

    async getImageHandler() {
       const response = await fetch(this.endPoint, {method:'GET'});
       const resp = await response.json();
       this.imgURL = resp.image;
    }
}

