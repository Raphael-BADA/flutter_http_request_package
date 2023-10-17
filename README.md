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

"The http_request_f package simplifies HTTP request operations in Dart and Flutter. Our package allows you to perform HTTP requests, automatically handle JSON serialization and deserialization, and conduct various URI operations, all using a single function

## Features

Simplified HTTP Requests: Make HTTP GET, POST, PUT, DELETE, and other requests with a single, straightforward function call.
Streamlined JSON Handling: Our package automates JSON serialization and deserialization, enabling you to work directly with Dart objects.
Effortless URI Manipulation: Easily manage URI operations, including building, modifying, and handling URL parameters.
Customization: Customize requests by adding headers, cookies, and other parameters tailored to your use case.
Easy Response Handling: Obtain HTTP responses and process them effortlessly, whether they contain JSON, text, or other formats.

## Getting started

```dart
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

```

## Additional information
