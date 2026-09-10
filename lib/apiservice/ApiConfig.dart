class ApiConfig {
  static const String baseUrl = "http://192.168.1.8:8080";
  //static const String baseUrl = "http://10.0.2.2:8080";
  //static const String baseUrl="https://subheader-baggage-feminize.ngrok-free.dev";
  static const Map<String, String> jsonHeaders = {
    "Content-Type": "application/json",
  };

  static Uri uri(String path, [Map<String, dynamic>? queryParameters]) {
    final normalizedPath = path.startsWith("/") ? path : "/$path";
    return Uri.parse("$baseUrl$normalizedPath").replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }
}
