library http_request_f;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:http_request_f/db/local_store.dart';
import '../request_status/exceptions.dart';

enum RequestType {
  //corresponds to http get , post , put , patch and delete requests
  get,
  post,
  put,
  patch,
  delete,
  formData,
}

class HttpRequest {
  Map<String, dynamic> httpHeaders = {
    "Authorization": "",
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  String baseUrl;
  Function onUnauthorized;
  HttpRequest(
      {required this.baseUrl,
      required this.onUnauthorized,
      Map<String, dynamic>? headers}) {
    if (headers != null) {
      httpHeaders.addAll(headers);
    }
  }

  Future<bool> setAuthToken(
      //use this function to save access token . It will automatically be added
      // to headers when performing requests
      {String tokenType = "Bearer",
      required String token}) async {
    try {
      await LocalStore.saveString('accessToken', "$tokenType $token");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getAuthToken() async {
    try {
      String? accessToken = await LocalStore.getStringData('accessToken');
      accessToken = "$accessToken";
      return accessToken;
    } catch (e) {
      return '';
    }
  }

  static Future<Map<String, String>> getHeaders() async {
    final authToken = await getAuthToken();

    return {
      "Authorization": authToken,
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
  }

  Future<dynamic> init({
    required String path,
    required RequestType requestType,
    Map body = const {},
    Encoding? encoding = utf8,
  }) async {
    path = path.replaceAll(RegExp(r'^/+|/+$'), '');
    final url = Uri.parse('$baseUrl/$path');
    print(url);
    print(body);
    final headers = await getHeaders();

    final http.Response response;
    try {
      switch (requestType) {
        case RequestType.get:
          response = await http.get(url, headers: headers);
          break;
        case RequestType.post:
          response = await http.post(url,
              headers: headers, body: jsonEncode(body), encoding: encoding);
          break;
        case RequestType.put:
          response = await http.put(url,
              headers: headers, body: jsonEncode(body), encoding: encoding);
          break;
        case RequestType.patch:
          response = await http.patch(url,
              headers: headers, body: jsonEncode(body), encoding: encoding);
          break;
        case RequestType.delete:
          response = await http.delete(url,
              headers: headers, body: jsonEncode(body), encoding: encoding);
          break;
        case RequestType.formData:
          final request = http.MultipartRequest('POST', url);

          body.forEach((key, value) {
            if (value is File) {
              List<int> fileBytes = value.readAsBytesSync();
              request.files.add(
                http.MultipartFile.fromBytes(
                  key,
                  fileBytes,
                  filename: '$key.jpg',
                  contentType: MediaType('image', 'jpeg'),
                ),
              );
            } else if (value is List<File>) {
              for (int i = 0; i < value.length; i++) {
                List<int> fileBytes = value[i].readAsBytesSync();
                request.files.add(
                  http.MultipartFile.fromBytes(
                    key,
                    fileBytes,
                    filename: '$key$i.jpg',
                    contentType: MediaType('image', 'jpeg'),
                  ),
                );
              }
            } else {
              request.fields[key] = jsonEncode(value);
            }
          });
          print('Request Method: ${request.method}');
          print('Request URL: ${request.url}');
          print('Request Headers: ${request.headers}');
          print('Form Fields: ${request.fields}');
          print('Form Files: ${request.files}');
          print("All request: ${request.toString()}");
          final responseSend = await request.send();
          response = await http.Response.fromStream(responseSend);
          break;

        default:
          response = await http.get(url, headers: headers);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print(response.body);
      }

      if (response.statusCode == 400 || response.statusCode == 422) {
        throw BadRequestException('Bad Request');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        onUnauthorized();
        throw UnauthorizedException('Unauthorized');
      } else if (response.statusCode == 404 ||
          response.statusCode == 301 ||
          response.statusCode == 302 ||
          response.statusCode == 307) {
        throw NotFoundException('Not Found');
      } else if (response.statusCode == 405) {
        throw BadMethodException('Bad Method');
      } else if (response.statusCode == 500 ||
          response.statusCode == 502 ||
          response.statusCode == 503) {
        throw ServerException('server error');
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException('Request failed with status ${response.statusCode}');
      }
      print(response.body);

      return jsonDecode(response.body);
    } on SocketException catch (e) {
      throw SocketException('Socket Error: ${e.message}');
    } catch (e) {
      throw UnknownApiException('Unknown Error: $e');
    }
  }
}

class RequestError {
  static const badRequest = "BAD_REQUEST";
  static const unauthorized = "UNAUTHORIZED";
  static const socketError = "SOCKET_ERROR";
  static const apiException = "API_EXCEPTION";
  static const unknown = "UNKNOWN";
  static const serverError = "SERVER_ERROR";
  static const badMethod = "BAD_METHOD";
}

class ErrorType {
  static get(Object e) {
    if (e is BadRequestException) {
      return RequestError.badRequest;
    } else if (e is UnauthorizedException) {
      return RequestError.unauthorized;
    } else if (e is ServerException) {
      return RequestError.serverError;
    } else if (e is BadMethodException) {
      return RequestError.badMethod;
    } else if (e is SocketException) {
      return RequestError.socketError;
    } else if (e is ApiException) {
      return RequestError.apiException;
    } else {
      return RequestError.unknown;
    }
  }
}
