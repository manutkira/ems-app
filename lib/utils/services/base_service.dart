abstract class BaseService {
  String baseUrl = "https://rest-api-laravel-flutter.herokuapp.com/api";

  Map<String, String>? headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };
}
