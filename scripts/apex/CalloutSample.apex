String END_POINT = 'https://th-apex-http-callout.herokuapp.com/animals';

Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint(END_POINT);
request.setMethod('GET');
request.setHeader('Content-Type', 'application/json');

// make http callout
HttpResponse response = http.send(request);

//check the response
if (response.getStatusCode() == 200) {
  // parse the response JSON
  AnimalResponse animalresponse = AnimalResponse.parse(response.getBody());
  system.debug('ANIMALS ---- ' + animalresponse.animals);
} else {
  system.debug('Error' + response.getStatus() + ' ' + response.getStatusCode());
}
