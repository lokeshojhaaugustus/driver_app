class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8080";

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
