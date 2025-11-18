import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Future<String?> Function()? _tokenProvider;

  ApiService({
    required this.baseUrl,
    Future<String?> Function()? tokenProvider,
  }) : _tokenProvider = tokenProvider;

  Map<String, String> _defaultHeaders({bool withAuth = false, String? token}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (withAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  dynamic _decodeBody(http.Response res) {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return body['data'];
      }
      return body;
    }
    throw Exception('Request failed (${res.statusCode}): ${body is Map && body['message'] != null ? body['message'] : res.reasonPhrase}');
  }

  // ---------------------------
  // Home (bisa diisi kombinasi beberapa endpoint jika dibutuhkan)
  // ---------------------------
  Future<dynamic> getHome() async {
    // Untuk sementara, kembalikan kombinasi list news & gallery sebagai contoh.
    final news = await listNews(page: 1);
    final galleries = await listGallery(page: 1);
    return {
      'news': news,
      'galleries': galleries,
    };
  }

  // ---------------------------
  // Gallery
  // ---------------------------
  Future<dynamic> listGallery({int page = 1, String? category}) async {
    final query = <String, dynamic>{
      'page': page,
    };
    if (category != null && category.isNotEmpty) {
      query['category_id'] = category;
    }
    final uri = _uri('/galleries', query);
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  Future<dynamic> galleryDetail(String id) async {
    final uri = _uri('/galleries/$id');
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  // Belum ada backend khusus untuk fitur berikut, tetap stub sementara
  Future<dynamic> galleryDownload(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryComments(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryLike(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryUnlike(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryLikeStatus(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryFavorite(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryUnfavorite(String id) async => Future.error(UnimplementedError());
  Future<dynamic> galleryFavoriteStatus(String id) async => Future.error(UnimplementedError());
  Future<dynamic> favorites() async => Future.error(UnimplementedError());
  Future<dynamic> gallerySubmitGet() async => Future.error(UnimplementedError());
  Future<dynamic> gallerySubmitPost(Map<String, dynamic> body) async => Future.error(UnimplementedError());

  // ---------------------------
  // News
  // ---------------------------
  Future<dynamic> listNews({int page = 1}) async {
    final uri = _uri('/news', {
      'page': page,
    });
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  Future<dynamic> newsDetailBySlug(String slug) async {
    final uri = _uri('/news/$slug');
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  Future<dynamic> newsComments(String idOrSlug) async => Future.error(UnimplementedError());
  Future<dynamic> newsCommentPost(String idOrSlug, Map<String, dynamic> body) async => Future.error(UnimplementedError());

  // ---------------------------
  // Events (belum ada endpoint khusus di backend yang terlihat)
  // ---------------------------
  Future<dynamic> listEvents({int page = 1}) async => Future.error(UnimplementedError());
  Future<dynamic> eventDetailBySlug(String slug) async => Future.error(UnimplementedError());

  // ---------------------------
  // Teachers
  // ---------------------------
  Future<dynamic> teachers() async {
    final uri = _uri('/teachers');
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  Future<dynamic> contactPost(Map<String, dynamic> body) async => Future.error(UnimplementedError());
  Future<dynamic> submitPhotoQuick(Map<String, dynamic> body) async => Future.error(UnimplementedError());

  // ---------------------------
  // School profile
  // ---------------------------
  Future<dynamic> profileGet() async {
    final uri = _uri('/school-profile');
    final res = await http.get(uri, headers: _defaultHeaders());
    return _decodeBody(res);
  }

  Future<dynamic> profileUpdate(Map<String, dynamic> body) async => Future.error(UnimplementedError());

  // ---------------------------
  // Auth (Admin)
  // ---------------------------
  Future<dynamic> login(String email, String password) async {
    final uri = _uri('/admin/login');
    final res = await http.post(
      uri,
      headers: _defaultHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return _decodeBody(res);
  }

  Future<dynamic> register(Map<String, dynamic> body) async => Future.error(UnimplementedError());
  Future<dynamic> forgotPassword(String email) async => Future.error(UnimplementedError());
  Future<dynamic> resetPassword(String token, String newPassword) async => Future.error(UnimplementedError());

  Future<dynamic> logout() async {
    if (_tokenProvider == null) {
      throw Exception('Token provider is not configured');
    }
    final token = await _tokenProvider();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token available');
    }
    final uri = _uri('/admin/logout');
    final res = await http.post(
      uri,
      headers: _defaultHeaders(withAuth: true, token: token),
    );
    return _decodeBody(res);
  }

  // ---------------------------
  // Chatbot (belum ada endpoint backend)
  // ---------------------------
  Future<dynamic> chatbotAsk(String question, {List<Map<String, String>>? context}) async {
    final uri = _uri('/chatbot/ask');
    final res = await http.post(
      uri,
      headers: _defaultHeaders(),
      body: jsonEncode({
        'message': question,
        if (context != null && context.isNotEmpty) 'context': context,
      }),
    );
    final data = _decodeBody(res);
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['answer'];
    }
    throw Exception(data is Map && data['error'] != null ? data['error'] : 'Chatbot error');
  }
}
