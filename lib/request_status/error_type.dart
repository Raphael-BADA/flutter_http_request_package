import 'exceptions.dart';

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
