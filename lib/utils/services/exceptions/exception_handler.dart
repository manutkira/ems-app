abstract class IBaseException implements Exception {
  const IBaseException([this.message]);

  final String? message;

  @override
  String toString() {
    String result = 'An error has occurred';
    if (message is String) return '$result: $message';
    return result;
  }
}
