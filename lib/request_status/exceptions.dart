class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class SocketException extends ApiException {
  SocketException(String message) : super(message);
}

class UnknownApiException extends ApiException {
  UnknownApiException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}

class BadMethodException extends ApiException {
  BadMethodException(String message) : super(message);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message);
}
