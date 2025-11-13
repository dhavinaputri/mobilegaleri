import 'package:flutter/material.dart';
import '../pages/beranda_page.dart';
import '../pages/tentang_page.dart';
import '../pages/berita_page.dart';
import '../pages/galeri_page.dart';
import '../pages/kontak_page.dart';
import '../routes.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _index = 0;

  final _pages = const [
    BerandaPage(),
    GaleriPage(),
    BeritaPage(),
    TentangPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hello, Tamu!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              'Selamat datang di EduSpot',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white.withOpacity(.9)),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF6625AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.of(context).pushNamed(RoutePaths.guestLogin),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(.2),
                child: const Icon(Icons.person_outline_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(.25)),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Cari berita, galeri, program...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.9)),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed(RoutePaths.chatbotAsk),
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.chat_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library), label: 'Galeri'),
          NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: 'Berita'),
          NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'Tentang'),
        ],
      ),
    );
  }
}
