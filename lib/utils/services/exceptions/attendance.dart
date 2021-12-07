import 'exception_handler.dart';

class AttendanceException extends IBaseException {
  AttendanceException({required this.code, this.message}) : super(message);

  final int code;

  @override
  String? message = "Attendance error.";

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

      case 404:
        {
          return message = "No record found.";
        }

      case 422:
        {
          return message =
              "An error has occurred while trying to add the attendance record. Please check your input.";
        }

      default:
        {
          return message.toString();
        }
    }
  }
}
