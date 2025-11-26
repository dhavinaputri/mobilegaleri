import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple API client for Eduspot backend
class ApiClient {
  /// Prefer from --dart-define=EDUSPOT_BASE_URL or fallback to production URL
  static final String baseUrl = const String.fromEnvironment(
    'EDUSPOT_BASE_URL',
    defaultValue: 'https://eduspot.up.railway.app',
  );

  static Uri _buildUri(String path, [Map<String, String>? query]) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath').replace(queryParameters: query);
  }

  static Future<Map<String, dynamic>> getJson(String path, {Map<String, String>? query, Map<String, String>? headers}) async {
    final res = await http.get(_buildUri(path, query), headers: {
      'Accept': 'application/json',
      ...?headers,
    });
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final res = await http.post(
      _buildUri(path),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: json.encode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }
}
