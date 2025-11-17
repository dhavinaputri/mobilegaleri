import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/gallery_item.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  // Kategori mengikuti yang ada di beranda
  final List<String> categories = const [
    'Semua',
    'Kegiatan',
    'Fasilitas Sekolah',
    'Prestasi',
  ];

  String selected = 'Semua';

  // State interaksi sederhana di sisi UI saja
  final Set<String> _likedIds = {};
  final Set<String> _savedIds = {};

  List<GalleryItem> get filtered {
    if (selected == 'Semua') return DummyData.gallery;

    // Map label UI ke kategori data sebenarnya
    String dataCategory = selected;
    if (selected == 'Fasilitas Sekolah') {
      dataCategory = 'Fasilitas';
    }

    return DummyData.gallery.where((g) => g.category == dataCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.of(context).size.width > 800;
    final crossAxisCount = isWide ? 4 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Galeri Sekolah',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        const SizedBox(height: 4),
        // Kategori chips
        SizedBox(
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final c = categories[i];
              final active = c == selected;
              return ChoiceChip(
                label: Text(c),
                selected: active,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? scheme.primary : scheme.onSurfaceVariant,
                ),
                selectedColor: scheme.primary.withOpacity(.12),
                backgroundColor: scheme.surfaceVariant.withOpacity(.18),
                onSelected: (_) => setState(() => selected = c),
                side: BorderSide(
                  color: active ? scheme.primary : scheme.outlineVariant,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: categories.length,
          ),
        ),

        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final g = filtered[i];
              final liked = _likedIds.contains(g.id);
              final saved = _savedIds.contains(g.id);

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image + top overlay actions
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(g.imageUrl, fit: BoxFit.cover),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withOpacity(.85),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    g.category,
                                    style: TextStyle(
                                      color: scheme.onPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                        child: Text(
                          g.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${g.date.day}/${g.date.month}/${g.date.year}',
                          style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),

                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  icon: Icon(
                                    liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 20,
                                    color: liked ? Colors.redAccent : scheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (liked) {
                                        _likedIds.remove(g.id);
                                      } else {
                                        _likedIds.add(g.id);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  icon: Icon(
                                    saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                    size: 20,
                                    color: saved ? scheme.primary : scheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (saved) {
                                        _savedIds.remove(g.id);
                                      } else {
                                        _savedIds.add(g.id);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              icon: Icon(
                                Icons.download_rounded,
                                size: 20,
                                color: scheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                // Placeholder: aksi unduh bisa dihubungkan dengan logic sebenarnya nanti
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Fitur unduh akan segera hadir.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
