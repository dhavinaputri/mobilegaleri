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

        return SingleChildScrollView(
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
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
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
                            const SizedBox(width: 10),
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

              // HERO SECTION
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 16, isDesktop ? 24 : 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: isDesktop ? 21 / 7 : 16 / 12,
                        child: Image.asset(
                          'assets/images/smkn4_hero.JPG',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1D4ED8), Color(0xFF6625AC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
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
                              colors: [Color(0xB31D4ED8), Color(0xB36625AC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
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
                                              : 24,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Eksplor kegiatan, berita, dan momen terbaik sekolah dalam satu aplikasi.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.white.withOpacity(.9),
                                          fontSize: isDesktop ? null : 14,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                                    ),
                                    child: Wrap(
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
                                              backgroundColor: Colors.white.withOpacity(0.06),
                                            ),
                                            icon: const Icon(Icons.article_outlined),
                                            label: const Text('Baca Berita'),
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
                      ),
                    ],
                  ),
                ),
              ),

              // SCHOOL BRIEF DESCRIPTION
              Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 16, isDesktop ? 24 : 16, 0),
                child: Card(
                  elevation: 8,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.school_outlined, color: Color(0xFF1D4ED8)),
                            SizedBox(width: 8),
                            Text('Profil Singkat', style: TextStyle(fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'SMKN 4 Bogor berkomitmen membentuk generasi unggul yang berkarakter, kreatif, dan siap kerja. Visi kami adalah menghadirkan pendidikan vokasi yang modern, relevan dengan industri, dan berdampak bagi masyarakat.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 6),
                        Column(
                          children: [
                            _IconFeature(icon: Icons.apps_rounded, text: 'Kompetensi keahlian beragam'),
                            const SizedBox(height: 8),
                            _IconFeature(icon: Icons.handshake_rounded, text: 'Kolaborasi dengan industri'),
                            const SizedBox(height: 8),
                            _IconFeature(icon: Icons.apartment_rounded, text: 'Fasilitas modern'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            Icon(Icons.category_outlined, color: Color(0xFF1D4ED8)),
                            SizedBox(width: 8),
                            Text('Program Keahlian', style: TextStyle(fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pilihan jurusan yang siap membekali siswa dengan keterampilan sesuai kebutuhan industri',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: const [
                            _ProgramCard(
                              title: 'PPLG',
                              description: 'Pengembangan Perangkat Lunak dan Gim: fokus pada pemrograman, UI/UX, basis data, dan pembuatan gim.',
                              icon: Icons.code_rounded,
                              iconColor: Color(0xFF1D4ED8),
                            ),
                            SizedBox(height: 8),
                            _ProgramCard(
                              title: 'TJKT',
                              description: 'Teknik Jaringan Komputer dan Telekomunikasi: perakitan, administrasi jaringan, server, dan keamanan jaringan.',
                              icon: Icons.router_rounded,
                              iconColor: Color(0xFF16A34A),
                            ),
                            SizedBox(height: 8),
                            _ProgramCard(
                              title: 'TPFL',
                              description: 'Teknik Pengelasan dan Fabrikasi Logam: proses pengelasan, fabrikasi, keselamatan kerja, dan gambar teknik.',
                              icon: Icons.handyman_rounded,
                              iconColor: Color(0xFFF59E0B),
                            ),
                            SizedBox(height: 8),
                            _ProgramCard(
                              title: 'TKRO',
                              description: 'Teknik Kendaraan Ringan Otomotif: perawatan dan perbaikan sistem mesin, chassis, kelistrikan, dan diagnosa.',
                              icon: Icons.directions_car_filled_rounded,
                              iconColor: Color(0xFFEF4444),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    ? Column(
                        children: List.generate(3, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _ShimmerLine(height: 96, radius: 16, controller: _shimmerCtrl))),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: news.take(3).length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final n = news[i];
                          return _CardShine(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _NewsInlineDetail(item: n))),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          n.imageUrl ?? 'https://images.unsplash.com/photo-1577896851231-70ef18881754?auto=format&fit=crop&w=400&q=80',
                                          width: 110,
                                          height: 74,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(n.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                                            const SizedBox(height: 4),
                                            Text('${n.date.day}/${n.date.month}/${n.date.year}', style: Theme.of(context).textTheme.labelSmall),
                                            const SizedBox(height: 4),
                                            Text(
                                              n.content,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      )
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

class _ChipInfo extends StatelessWidget {
  final String text;
  const _ChipInfo({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF1D4ED8),
              fontWeight: FontWeight.w700,
            ),
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
