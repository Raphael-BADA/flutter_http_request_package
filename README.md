<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: "The http_request_f package simplifies HTTP request operations in Dart and Flutter. Our package allows you to perform HTTP requests, automatically handle JSON serialization and deserialization, and conduct various URI operations, all using a single function

## Features

TODO: Simplified HTTP Requests: Make HTTP GET, POST, PUT, DELETE, and other requests with a single, straightforward function call.
Streamlined JSON Handling: Our package automates JSON serialization and deserialization, enabling you to work directly with Dart objects.
Effortless URI Manipulation: Easily manage URI operations, including building, modifying, and handling URL parameters.
Customization: Customize requests by adding headers, cookies, and other parameters tailored to your use case.
Easy Response Handling: Obtain HTTP responses and process them effortlessly, whether they contain JSON, text, or other formats.
Supports Dart and Flutter: Our package is designed to work seamlessly with both pure Dart and Flutter, offering great flexibility..

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

```dart
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
}

```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
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

```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
