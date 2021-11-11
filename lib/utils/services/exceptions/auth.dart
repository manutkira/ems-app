import 'exception_handler.dart';

class AuthException extends IBaseException {
  AuthException({required this.code, this.message = "Authentication error."})
      : super(message);

  final int code;

  String message;

  @override
  String toString() {
    switch (code) {
      case 1:
        {
          return message = "Error parsing data.";
        }
      case 2:
        {
          return message = "Insufficient or malformed data provided.";
        }
      case 401:
        {
          return message =
              "Invalid credentials. Please check your login data again.";
        }

      case 422:
        {
          return message =
              "An error has occurred while trying to add the attendance record. Please check your input.";
        }
      case 404:
        {
          return message = "Not found.";
        }

      default:
        {
          return message;
        }
    }
  }
}
