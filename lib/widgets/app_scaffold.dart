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
  bool _isChatOpen = false;

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
        backgroundColor: Colors.white,
        foregroundColor: scheme.onSurface,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hello, Tamu!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Selamat datang di EduSpot',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        flexibleSpace: null,
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
            icon: Icon(Icons.notifications_none_rounded, color: scheme.primary),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.of(context).pushNamed(RoutePaths.guestLogin),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: scheme.primary.withOpacity(.08),
                child: Icon(Icons.person_outline_rounded, color: scheme.primary),
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
                color: scheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.outline.withOpacity(.18)),
              ),
              child: TextField(
                style: TextStyle(color: scheme.onSurface),
                cursorColor: scheme.primary,
                decoration: InputDecoration(
                  hintText: 'Cari berita, galeri, program...',
                  hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
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
            bottom: 188,
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
            bottom: 112,
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
                onPressed: () {
                  setState(() {
                    _isChatOpen = !_isChatOpen;
                  });
                },
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
          if (_isChatOpen)
            Positioned(
              right: 16,
              bottom: 188,
              child: Material(
                elevation: 14,
                borderRadius: BorderRadius.circular(18),
                clipBehavior: Clip.antiAlias,
                child: Container
                (
                  width: 320,
                  height: 420,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: scheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Eduspot',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Asisten SMKN 4 Bogor & pendidikan',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isChatOpen = false;
                                });
                              },
                              icon: const Icon(Icons.close_rounded, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: scheme.surface,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Halo, saya Botspot! Tanya apa saja seputar SMKN 4 Bogor atau pendidikan ya.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: const [
                                    _ChatSuggestionChip(label: 'Jurusan di SMKN 4'),
                                    _ChatSuggestionChip(label: 'Info Ekstrakurikuler'),
                                    _ChatSuggestionChip(label: 'Informasi PPDB'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: scheme.outline.withOpacity(.3)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Ketik pertanyaan Anda...',
                                    border: InputBorder.none,
                                  ),
                                  minLines: 1,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Kirim'),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _ChatSuggestionChip extends StatelessWidget {
  final String label;
  const _ChatSuggestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          // sementara: belum ada logika kirim otomatis
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: scheme.primary.withOpacity(.25)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
