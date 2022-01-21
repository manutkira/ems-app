import 'exception_handler.dart';

class UserException extends IBaseException {
  UserException({this.code, this.message = "User error."}) : super(message);

  final int? code;

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
      case 3:
        {
          return message = message;
        }
      case 404:
        {
          return message = "No record found.";
        }

      case 422:
        {
          return message =
              "An error has occurred while trying to add a user record. Invalid input or data already exists.";
        }

      default:
        {
          return message;
        }
    }
  }
}
