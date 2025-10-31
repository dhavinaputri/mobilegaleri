import 'dart:async';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<dynamic> getHome() async => Future.error(UnimplementedError());

  Future<dynamic> listGallery({int page = 1, String? category}) async => Future.error(UnimplementedError());
  Future<dynamic> galleryDetail(String id) async => Future.error(UnimplementedError());
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

  Future<dynamic> listNews({int page = 1}) async => Future.error(UnimplementedError());
  Future<dynamic> newsDetailBySlug(String slug) async => Future.error(UnimplementedError());
  Future<dynamic> newsComments(String idOrSlug) async => Future.error(UnimplementedError());
  Future<dynamic> newsCommentPost(String idOrSlug, Map<String, dynamic> body) async => Future.error(UnimplementedError());

  Future<dynamic> listEvents({int page = 1}) async => Future.error(UnimplementedError());
  Future<dynamic> eventDetailBySlug(String slug) async => Future.error(UnimplementedError());

  Future<dynamic> teachers() async => Future.error(UnimplementedError());
  Future<dynamic> contactPost(Map<String, dynamic> body) async => Future.error(UnimplementedError());
  Future<dynamic> submitPhotoQuick(Map<String, dynamic> body) async => Future.error(UnimplementedError());

  Future<dynamic> profileGet() async => Future.error(UnimplementedError());
  Future<dynamic> profileUpdate(Map<String, dynamic> body) async => Future.error(UnimplementedError());

  Future<dynamic> login(String email, String password) async => Future.error(UnimplementedError());
  Future<dynamic> register(Map<String, dynamic> body) async => Future.error(UnimplementedError());
  Future<dynamic> forgotPassword(String email) async => Future.error(UnimplementedError());
  Future<dynamic> resetPassword(String token, String newPassword) async => Future.error(UnimplementedError());
  Future<dynamic> logout() async => Future.error(UnimplementedError());

  Future<dynamic> chatbotAsk(String question) async => Future.error(UnimplementedError());
}
