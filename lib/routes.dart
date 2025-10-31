import 'package:flutter/material.dart';

import 'pages/beranda_page.dart';
import 'pages/galeri_page.dart';
import 'pages/berita_page.dart';
import 'pages/tentang_page.dart';
import 'pages/kontak_page.dart';
import 'pages/login_guest_page.dart';

// Placeholder pages
import 'pages/placeholders/events_page.dart';
import 'pages/placeholders/event_detail_page.dart';
import 'pages/placeholders/teachers_page.dart';
import 'pages/placeholders/gallery_detail_page.dart';
import 'pages/placeholders/gallery_category_page.dart';
import 'pages/placeholders/news_detail_page.dart';
import 'pages/placeholders/favorites_page.dart';
import 'pages/placeholders/profile_page.dart';
import 'pages/placeholders/submit_photo_page.dart';
import 'pages/placeholders/register_guest_page.dart';
import 'pages/placeholders/forgot_password_page.dart';
import 'pages/placeholders/reset_password_page.dart';
import 'pages/placeholders/chatbot_page.dart';

class RoutePaths {
  static const home = '/';
  static const gallery = '/gallery';
  static const galleryDetail = '/gallery/:id';
  static const galleryCategory = '/gallery/category/:category';
  static const galleryDownload = '/gallery/download/:id';
  static const news = '/news';
  static const newsDetail = '/news/:slug';
  static const events = '/events';
  static const eventDetail = '/events/:slug';
  static const about = '/about';
  static const teachers = '/teachers';
  static const contact = '/contact';
  static const sitemap = '/sitemap.xml';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const gallerySubmit = '/gallery/submit';

  // Auth
  static const guestLogin = '/guest/login';
  static const guestRegister = '/guest/register';
  static const guestForgot = '/guest/forgot-password';
  static const guestReset = '/guest/reset-password'; // expects token param
  static const aliasLogin = '/login';
  static const aliasResetToken = '/reset-password';

  // Chatbot
  static const chatbotAsk = '/chatbot/ask';
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final name = settings.name ?? '/';
  final uri = Uri.parse(name);
  final seg = uri.pathSegments;

  Widget? page;

  // Aliases
  if (name == RoutePaths.aliasLogin) {
    page = const LoginGuestPage();
  }
  // Root/public
  else if (name == RoutePaths.home) {
    page = const BerandaPage();
  } else if (name == RoutePaths.gallery) {
    page = const GaleriPage();
  } else if (name == RoutePaths.news) {
    page = const BeritaPage();
  } else if (name == RoutePaths.about) {
    page = const TentangPage();
  } else if (name == RoutePaths.teachers) {
    page = const TeachersPage();
  } else if (name == RoutePaths.contact) {
    page = const KontakPage();
  } else if (name == RoutePaths.events) {
    page = const EventsPage();
  } else if (name == RoutePaths.favorites) {
    page = const FavoritesPage();
  } else if (name == RoutePaths.profile) {
    page = const ProfilePage();
  } else if (name == RoutePaths.gallerySubmit) {
    page = const SubmitPhotoPage();
  } else if (name == RoutePaths.guestLogin) {
    page = const LoginGuestPage();
  } else if (name == RoutePaths.guestRegister) {
    page = const RegisterGuestPage();
  } else if (name == RoutePaths.guestForgot) {
    page = const ForgotPasswordPage();
  } else if (uri.path == RoutePaths.guestReset) {
    final token = uri.queryParameters['token'];
    page = ResetPasswordPage(token: token ?? '');
  } else if (uri.path == RoutePaths.aliasResetToken) {
    final token = uri.queryParameters['token'];
    page = ResetPasswordPage(token: token ?? '');
  }

  // Dynamic gallery/news/events
  else if (seg.length == 2 && seg[0] == 'gallery') {
    final id = seg[1];
    page = GalleryDetailPage(id: id);
  } else if (seg.length == 3 && seg[0] == 'gallery' && seg[1] == 'category') {
    final category = seg[2];
    page = GalleryCategoryPage(category: category);
  } else if (seg.length == 2 && seg[0] == 'news') {
    final slug = seg[1];
    page = NewsDetailPage(slug: slug);
  } else if (seg.length == 2 && seg[0] == 'events') {
    final slug = seg[1];
    page = EventDetailPage(slug: slug);
  }

  // Chatbot
  else if (name == RoutePaths.chatbotAsk) {
    page = const ChatbotPage();
  }

  if (page == null) return null;

  return MaterialPageRoute(builder: (_) => page!, settings: settings);
}
