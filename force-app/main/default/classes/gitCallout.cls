public with sharing class gitCallout {
  public static List<String> getLogin() {
    String END_POINT = 'https://api.github.com/users/hadley/orgs';

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(END_POINT);
    request.setMethod('GET');
    request.setHeader('Content-Type', 'application/json');

    // Make HTTP callout
    HttpResponse response = http.send(request);

    // Initialize an empty list of gitWrapper objects
    List<gitWrapper> takeAll = new List<gitWrapper>();

    // Check the response
    if (response.getStatusCode() == 200) {
      // Parse the response JSON
      takeAll = gitWrapper.parse(response.getBody());
    } else {
      System.debug(
        'Error' +
        response.getStatus() +
        ' ' +
        response.getStatusCode()
      );
    }

    // Return the takeAll list of gitWrapper objects
    return takeAll;
  }
}
