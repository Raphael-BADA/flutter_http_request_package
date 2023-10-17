import 'package:http_request_f/http_request_f.dart';
import 'package:http_request_f/request_status/error_type.dart';

final HttpRequest httpRequest =
    HttpRequest(baseUrl: "https://jsonplaceholder.typicode.com");
getData() async {
  //get Request
  try {
    final jsonResponse = await httpRequest.init(
        path: "posts", requestType: RequestType.get); //decoded data
    print(jsonResponse);

    for (var element in jsonResponse) {
      print("element ${element['id']} - ${element['title']}");
    }
  } catch (e) {
    print(ErrorType.get(e));
  }
}

postData() async {
  //post Request
  try {
    Map<String, dynamic> body = {
      "title": 'foo',
      "body": 'bar',
    };
    final response = await httpRequest.init(
        path: "posts", requestType: RequestType.post, body: body);
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
}
//put and patch Request

updateData() async {
  try {
    Map<String, dynamic> body = {
      "title": 'foo',
      "body": 'bar',
    };
    final response = await httpRequest.init(
        path: "posts/1",
        requestType: RequestType.put,
        body: body); // use RequestType.put or RequestType.patch
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
}

//delete Request
deleteData() async {
  try {
    final response = await httpRequest.init(
      path: "posts/1",
      requestType: RequestType.delete,
    );
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
}

//set token
setToken() async {
  Future<bool> tokenSet = httpRequest.setAuthToken(
      token:
          "your-token"); // the default token type is Bearer and this token is automaticaly added to to headers to perform requests

  try {
    Map<String, dynamic> body = {
      "title": 'foo',
      "body": 'bar',
    };
    final response = await httpRequest.init(
        path: "posts", requestType: RequestType.post, body: body);
    print(response);
  } catch (e) {
    print(e);
    print(ErrorType.get(e));
  }
}
