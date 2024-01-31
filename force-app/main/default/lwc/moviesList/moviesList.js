import { LightningElement, wire } from 'lwc';
import getMovies from '@salesforce/apex/IMDBController.getMovies';

export default class MoviesList extends LightningElement {
    movies = [];
    searchText = '';
    selectedMovieId = '';
    isLoading = true;

    @wire(getMovies, { searchText: '$searchText' })
    wiredGetMovies(result) {
        console.log('Result Data:', result.data);
        console.log('Result Error:', result.error);
    
        if (result.data) {
            let data = JSON.parse(result.data);
            this.movies = data.success ? data.result : [];
        }
        else if (result.error) {
            console.log('Error occurred while searching movies -' + result.error);
        }
    
        this.selectedMovieId = '';
        this.isLoading = false;
    }


    

    searchClickHandler(event) {
        this.isLoading = true;
        this.searchText = event.target.value;
    }

    get showEnterSearchText() {
        return !this.searchText && this.movies == 0;
    }

    get noMoviesFound() {
        return this.searchText && this.movies == 0 && !this.isLoading;
    }

    viewDetailsClickHandler(event) {
        let movieId = event.target.dataset.movieId;
        this.selectedMovieId = movieId;
        window.scrollTo({ top: 0, behavior: 'smooth' }); // Use smooth scrolling
    
        // Prevent default behavior of the 'mousewheel' event
        event.preventDefault();
    }
    
}