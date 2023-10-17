import 'package:http_request_f/http_request_f.dart';
import 'package:http_request_f/request_status/error_type.dart';

void main() async {
  final HttpRequest httpRequest =
      HttpRequest(baseUrl: "https://jsonplaceholder.typicode.com");

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
  //post Request
  try {
    Map<String, dynamic> body = {
      "title": 'foo',
      "body": 'bar',
      "userId": 1,
    };
    final response = await httpRequest.init(
        path: "posts", requestType: RequestType.post, body: body);
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
  //put and patch Request

  try {
    Map<String, dynamic> body = {
      "title": 'foo',
      "body": 'bar',
      "userId": 1,
    };
    final response = await httpRequest.init(
        path: "posts/1",
        requestType: RequestType.put,
        body: body); // use RequestType.put or RequestType.patch
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
  //delete Request

  try {
    final response = await httpRequest.init(
      path: "posts/1",
      requestType: RequestType.delete,
    );
    print(response);
  } catch (e) {
    print(ErrorType.get(e));
  }
  //set token
  Future<bool> tokenSet = httpRequest.setAuthToken(
      token:
          "your-token"); // the default token type is Bearer and this token is automaticaly added to to headers to perform requests
}
