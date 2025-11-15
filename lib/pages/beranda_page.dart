import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/dummy_data.dart';
import '../routes.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _IconFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: scheme.primary.withOpacity(.20)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(.3)),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryCategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GalleryCategoryChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.primary.withOpacity(.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: scheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  const _ProgramCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outline.withOpacity(.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded( 
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 16, color: iconColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BerandaPageState extends State<BerandaPage> with SingleTickerProviderStateMixin {
  bool _loading = true;
  late final AnimationController _shimmerCtrl;
  late final PageController _newsCtrl;
  int _newsIndex = 0;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
    _newsCtrl = PageController(viewportFraction: .9);
    // Simulasi loading singkat untuk menampilkan skeleton shimmer
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _newsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final news = DummyData.news.take(6).toList();
    final galleries = DummyData.gallery.take(8).toList();
    const primaryBlue = Color(0xFF1D4ED8);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isDesktop = w >= 1000;
        final isTablet = w >= 700 && w < 1000;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER SUMMARY (avatar/logo + quick pill)
                  Padding(
                    padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 16, isDesktop ? 24 : 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: Image.asset(
                                'assets/images/eduspotlogo.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.school_rounded,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'SMKN 4 Bogor',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Sekolah Vokasi Modern',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(RoutePaths.guestLogin),
                      borderRadius: BorderRadius.circular(14),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.login_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Masuk >', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // HERO SECTION (lebih ringan, fokus sambutan)
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 18, isDesktop ? 24 : 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: isDesktop ? 21 / 7 : 16 / 9,
                        child: Image.asset(
                          'assets/images/smkn4_hero.JPG',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE5EDFF), Color(0xFFD9E3FF)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -40,
                        right: -20,
                        child: Container(
                          width: isDesktop ? 220 : 140,
                          height: isDesktop ? 220 : 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.10),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -10,
                        child: Container(
                          width: isDesktop ? 180 : 120,
                          height: isDesktop ? 180 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0x801D4ED8), Color(0x806625AC)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 28 : 14),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isDesktop ? 520 : 400),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Membangun Masa Depan di SMKN 4 Bogor',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                          fontSize: isDesktop
                                              ? Theme.of(context).textTheme.headlineSmall?.fontSize
                                              : 22,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Selamat datang di ruang digital SMKN 4 Bogor.\nTemukan momen terbaik, kegiatan, dan prestasi siswa melalui galeri dan berita.',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withOpacity(.92),
                                          height: 1.4,
                                          fontSize: isDesktop ? null : 13,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // KATEGORI GALERI (ikon saja, rata kiri-kanan)
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GalleryCategoryChip(
                      icon: Icons.apps_rounded,
                      label: 'Semua',
                      onTap: () => Navigator.of(context).pushNamed(RoutePaths.gallery),
                    ),
                    _GalleryCategoryChip(
                      icon: Icons.event_available_rounded,
                      label: 'Kegiatan',
                      onTap: () => Navigator.of(context).pushNamed('/gallery/category/kegiatan'),
                    ),
                    _GalleryCategoryChip(
                      icon: Icons.apartment_rounded,
                      label: 'Fasilitas Sekolah',
                      onTap: () => Navigator.of(context).pushNamed('/gallery/category/fasilitas'),
                    ),
                    _GalleryCategoryChip(
                      icon: Icons.emoji_events_rounded,
                      label: 'Prestasi',
                      onTap: () => Navigator.of(context).pushNamed('/gallery/category/prestasi'),
                    ),
                  ],
                ),
              ),

              // BERITA TERKINI (CAROUSEL)
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 20, isDesktop ? 24 : 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Berita Terkini',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
                      child: const Text('Lihat semua'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 220,
                child: _loading
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
                        child: _ShimmerLine(
                            controller: _shimmerCtrl, height: 220, radius: 18),
                      )
                    : PageView.builder(
                        controller: _newsCtrl,
                        onPageChanged: (i) => setState(() => _newsIndex = i),
                        itemCount: news.length > 3 ? 3 : news.length,
                        itemBuilder: (context, i) {
                          final n = news[i];
                          return Padding(
                            padding: EdgeInsets.only(
                              left: isDesktop ? 24 : 16,
                              right: isDesktop ? 12 : 8,
                              bottom: 6,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => _NewsInlineDetail(item: n)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.12),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        n.imageUrl ??
                                            'https://images.unsplash.com/photo-1520974741920-56b77315bd2d?auto=format&fit=crop&w=900&q=80',
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(.55),
                                              Colors.transparent
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.white.withOpacity(.9),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                n.category,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              n.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  news.length > 3 ? 3 : news.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: _newsIndex == i ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _newsIndex == i
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),

              // GALLERY PREVIEW
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 20, isDesktop ? 24 : 16, 10),
                child: Row(
                  children: [
                    Container(width: 4, height: 22, color: primaryBlue),
                    const SizedBox(width: 8),
                    Text('Galeri Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
                child: _loading
                    ? _SkeletonGrid(controller: _shimmerCtrl, itemCount: 8, aspect: 0.8, columns: 2)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: galleries.length > 8 ? 8 : galleries.length,
                        itemBuilder: (context, i) {
                          final g = galleries[i];
                          return _HoverScale(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.06),
                                    blurRadius: 14,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: _CardShine(
                                  child: _GalleryCard(g: g),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (galleries.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(RoutePaths.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Lihat Semua Galeri'),
                    ),
                  ),
                ),
            ],
          ),
        ),
          ],
        );
      },
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final AnimationController controller;
  final double height;
  final double radius;
  const _ShimmerLine({required this.controller, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: [
                Container(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6)),
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    alignment: Alignment((-1 + 2 * controller.value), 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroMiniChip extends StatelessWidget {
  final String text;
  const _HeroMiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _NewsInlineDetail extends StatelessWidget {
  final dynamic item;
  const _NewsInlineDetail({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.category} • ${item.date.day}/${item.date.month}/${item.date.year}', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 12),
            Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(item.content),
          ],
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final dynamic g;
  const _GalleryCard({required this.g});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(g.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(.55), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('${g.date.day}/${g.date.month}/${g.date.year}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover && (kIsWeb || Theme.of(context).platform == TargetPlatform.windows || Theme.of(context).platform == TargetPlatform.linux || Theme.of(context).platform == TargetPlatform.macOS) ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _CardShine extends StatefulWidget {
  final Widget child;
  const _CardShine({required this.child});

  @override
  State<_CardShine> createState() => _CardShineState();
}

class _CardShineState extends State<_CardShine> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Stack(
        children: [
          widget.child,
          // Shine overlay
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _hover ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: LayoutBuilder(
                builder: (context, c) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOut,
                    left: _hover ? c.maxWidth : -c.maxWidth,
                    top: 0,
                    bottom: 0,
                    width: c.maxWidth / 2,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  final AnimationController controller;
  final int itemCount;
  final int columns;
  final double aspect;
  const _SkeletonGrid({required this.controller, required this.itemCount, required this.columns, required this.aspect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspect,
      ),
      itemCount: itemCount,
      itemBuilder: (context, i) => _ShimmerBox(controller: controller),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final AnimationController controller;
  const _ShimmerBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6)),
              Positioned.fill(
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  alignment: Alignment((-1 + 2 * controller.value), 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
