import 'package:mobilegaleri/data/api_client.dart';

class GalleryService {
  /// List galleries with optional search and category slug
  static Future<Map<String, dynamic>> list({String? search, String? categorySlug, int perPage = 12, int page = 1}) async {
    final query = <String, String>{
      'per_page': '$perPage',
      'page': '$page',
      if (search != null && search.isNotEmpty) 'search': search,
      if (categorySlug != null && categorySlug.isNotEmpty) 'category': categorySlug,
    };
    return ApiClient.getJson('/api/v1/galleries', query: query);
  }

  /// Get single gallery detail by ID
  static Future<Map<String, dynamic>> detail(int id) async {
    return ApiClient.getJson('/api/v1/galleries/$id');
  }
}
