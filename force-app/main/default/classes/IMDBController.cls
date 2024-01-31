public with sharing class IMDBController {
    @AuraEnabled(cacheable=true)
    public static string getMovies(string searchText){
    Http http = new Http();
	HttpRequest req = new HttpRequest();
    //req.setEndpoint('https://api.collectapi.com/imdb/imdbSearchByName?query=Inception' + searchText);
    req.setEndpoint('callout:IMDB/imdb/imdbSearchByName?query=Inception' + searchText);
    req.setMethod('GET');
    //req.setHeader('Authorization', 'apikey 2nJvO1pCmf92AGHpClzQlW:2izzuttHBhT9lAEm1904OO');
    HttpResponse res = http.send(req);
    System.debug('Status code:  '+ res.getStatusCode());
    System.debug('Body:  '+ res.getBody());
    if(res.getStatusCode() == 200){
        return res.getBody();
    }
    else {
        return 'Error Code : ' + res.getStatusCode();
    }

   }

   @AuraEnabled(cacheable=true)
    public static string getMovieDetails(string movieId){
    Http http = new Http();
	HttpRequest req = new HttpRequest();
    //req.setEndpoint('https://api.collectapi.com/imdb/imdbSearchById?movieId=tt1375666' + movieId);
    req.setEndpoint('callout:IMDB/imdb/imdbSearchById?movieId=tt1375666' + movieId);
    req.setMethod('GET');
    //req.setHeader('Authorization', 'apikey 2nJvO1pCmf92AGHpClzQlW:2izzuttHBhT9lAEm1904OO');
    HttpResponse res = http.send(req);
    System.debug('Status code:  '+ res.getStatusCode());
    System.debug('Body:  '+ res.getBody());
    if(res.getStatusCode() == 200){
        return res.getBody();
    }
    else {
        return 'Error Code : ' + res.getStatusCode();
    }

   }
}