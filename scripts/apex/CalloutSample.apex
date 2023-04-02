String END_POINT = 'https://api.github.com/users/hadley/orgs';

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
  system.debug(response.getBody());
} else {
  system.debug('Error' + response.getStatus() + ' ' + response.getStatusCode());
}
