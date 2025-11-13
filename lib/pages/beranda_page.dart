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

class _BerandaPageState extends State<BerandaPage> with SingleTickerProviderStateMixin {
  bool _loading = true;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
    // Simulasi loading singkat untuk menampilkan skeleton shimmer
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final news = DummyData.news.take(6).toList();
    final galleries = DummyData.gallery.take(8).toList();
    const primaryBlue = Color(0xFF1D4ED8);
    const accentYellow = Color(0xFFFACC15); // yellow-400

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isDesktop = w >= 1000;
        final isTablet = w >= 700 && w < 1000;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HERO SECTION
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 16, isDesktop ? 24 : 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: isDesktop ? 21 / 7 : 16 / 9,
                        child: Image.asset(
                          'assets/images/school_hero.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=1400&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xB31D4ED8), Color(0x991D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 28 : 18),
                          child: Align(
                            alignment: isDesktop ? Alignment.centerLeft : Alignment.bottomLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isDesktop ? 640 : 520),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EduSpot — Galeri Sekolah',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Eksplor kegiatan, berita, dan momen terbaik sekolah dalam satu aplikasi.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(.9)),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _HoverScale(
                                        child: FilledButton.icon(
                                          onPressed: () => Navigator.of(context).pushNamed(RoutePaths.gallery),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: primaryBlue,
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                            shape: const StadiumBorder(),
                                          ),
                                          icon: const Icon(Icons.photo_library_rounded),
                                          label: const Text('Lihat Galeri'),
                                        ),
                                      ),
                                      _HoverScale(
                                        child: OutlinedButton.icon(
                                          onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white),
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                            shape: const StadiumBorder(),
                                            backgroundColor: Colors.white.withOpacity(0.05),
                                          ),
                                          icon: const Icon(Icons.article_outlined),
                                          label: const Text('Baca Berita'),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: accentYellow,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.star_rounded, size: 18, color: Colors.black87),
                                            SizedBox(width: 6),
                                            Text('Modern • Clean • Responsif', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ],
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

              // LATEST NEWS
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 20, isDesktop ? 24 : 16, 8),
                child: Row(
                  children: [
                    Container(width: 4, height: 22, color: primaryBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Berita Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
                      child: const Text('Lihat semua'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
                child: _loading
                    ? _SkeletonGrid(controller: _shimmerCtrl, itemCount: 6, aspect: isDesktop ? 16 / 10 : isTablet ? 16 / 12 : 16 / 12, columns: isDesktop ? 3 : isTablet ? 2 : 1)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : isTablet ? 2 : 1,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: isDesktop ? 16 / 10 : isTablet ? 16 / 12 : 16 / 12,
                        ),
                        itemCount: news.length,
                        itemBuilder: (context, i) {
                          final n = news[i];
                          return _HoverScale(
                            child: _CardShine(
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _NewsInlineDetail(item: n))),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              n.imageUrl ?? 'https://images.unsplash.com/photo-1577896851231-70ef18881754?auto=format&fit=crop&w=800&q=80',
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              left: 8,
                                              top: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(color: accentYellow, borderRadius: BorderRadius.circular(8)),
                                                child: Text(n.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              n.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                                            ),
                                            const SizedBox(height: 6),
                                            Text('${n.date.day}/${n.date.month}/${n.date.year}', style: Theme.of(context).textTheme.labelSmall),
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
                    ? _SkeletonGrid(controller: _shimmerCtrl, itemCount: 8, aspect: 1, columns: isDesktop ? 4 : isTablet ? 3 : 2)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : isTablet ? 3 : 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: galleries.length,
                        itemBuilder: (context, i) {
                          final g = galleries[i];
                          return _HoverScale(
                            child: _CardShine(
                              child: _GalleryCard(g: g),
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
        );
      },
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
