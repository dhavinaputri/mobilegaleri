import 'package:mobilegaleri/data/api_client.dart';

class NewsService {
  /// List news with optional search and categoryId
  static Future<Map<String, dynamic>> list({String? search, int? categoryId, int perPage = 10, int page = 1}) async {
    final query = <String, String>{
      'per_page': '$perPage',
      'page': '$page',
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryId != null) 'category_id': '$categoryId',
    };
    return ApiClient.getJson('/api/v1/news', query: query);
  }

  /// Categories list (id, name, slug)
  static Future<Map<String, dynamic>> categories() async {
    return ApiClient.getJson('/api/v1/news/categories');
  }

  /// News detail by slug
  static Future<Map<String, dynamic>> detail(String slug) async {
    return ApiClient.getJson('/api/v1/news/$slug');
  }
}
