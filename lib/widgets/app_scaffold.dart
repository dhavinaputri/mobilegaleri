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
      extendBody: true,
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
      body: Stack(
        children: [
          _pages[_index],
          // Upload FAB (upper) with tab-switch animation
          Positioned(
            right: 16,
            bottom: 216,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: Tween(begin: .95, end: 1.0).animate(anim), child: child),
              ),
              child: FloatingActionButton(
                key: ValueKey('fab_upload_$_index'),
                heroTag: 'fab_upload_global',
                onPressed: () => Navigator.of(context).pushNamed(RoutePaths.gallerySubmit),
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                child: Image.asset(
                  'assets/icons/add.png',
                  width: 24,
                  height: 24,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
          // Chatbot FAB (lower) with tab-switch animation
          Positioned(
            right: 16,
            bottom: 136,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: Tween(begin: .95, end: 1.0).animate(anim), child: child),
              ),
              child: FloatingActionButton(
                key: ValueKey('fab_chatbot_$_index'),
                heroTag: 'fab_chatbot_global',
                onPressed: () => Navigator.of(context).pushNamed(RoutePaths.chatbotAsk),
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                child: Image.asset(
                  'assets/icons/chatbot.png',
                  width: 24,
                  height: 24,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Material(
          elevation: 14,
          shadowColor: Colors.black.withOpacity(.20),
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: scheme.primary,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Beranda',
                      active: _index == 0,
                      onTap: () => setState(() => _index = 0),
                    ),
                    _NavItem(
                      icon: Icons.photo_library_outlined,
                      activeIcon: Icons.photo_library_rounded,
                      label: 'Galeri',
                      active: _index == 1,
                      onTap: () => setState(() => _index = 1),
                    ),
                    _NavItem(
                      icon: Icons.article_outlined,
                      activeIcon: Icons.article_rounded,
                      label: 'Berita',
                      active: _index == 2,
                      onTap: () => setState(() => _index = 2),
                    ),
                    _NavItem(
                      icon: Icons.info_outline_rounded,
                      activeIcon: Icons.info_rounded,
                      label: 'Tentang',
                      active: _index == 3,
                      onTap: () => setState(() => _index = 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white.withOpacity(.85);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: SizedBox(
          height: 56,
          width: 64,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // soft shadow
                Positioned(
                  left: 0,
                  top: 1,
                  child: Icon(active ? activeIcon : icon, color: Colors.black.withOpacity(.28)),
                ),
                Icon(active ? activeIcon : icon, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
