class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException(this.message, this.prefix, this.url);

  @override
  String toString() {
    return "$prefix: $message, URL: $url";
  }
}

class BadRequestException extends AppException {
  BadRequestException(String message, String url)
      : super(message, "Bad Request", url);
}

class FetchDataException extends AppException {
  FetchDataException(String message, String url)
      : super(message, "Unable to Fetch Data", url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException(String message, String url)
      : super(message, "API Not Responding", url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException(String message, String url)
      : super(message, "Unauthorized", url);
}
