import 'package:flutter/material.dart';
import '../data/app_services.dart';
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

  bool _isGrid = true; // toggle tampilan seperti Google Drive

  // State interaksi sederhana di sisi UI saja
  final Set<String> _likedIds = {};
  final Set<String> _savedIds = {};

  late Future<List<GalleryItem>> _futureGallery;

  List<GalleryItem> _filtered(List<GalleryItem> all) {
    if (selected == 'Semua') return all;

    // Map label UI ke kategori data sebenarnya
    String dataCategory = selected;
    if (selected == 'Fasilitas Sekolah') {
      dataCategory = 'Fasilitas';
    }

    return all.where((g) => g.category == dataCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _futureGallery = _loadGallery();
  }

  Future<List<GalleryItem>> _loadGallery() async {
    final raw = await apiService.listGallery(page: 1);
    // Laravel pagination: data biasanya berisi { data: [...], ... }
    if (raw is Map<String, dynamic> && raw['data'] is List) {
      final list = raw['data'] as List;
      return list.map((e) => GalleryItem.fromApi(e as Map<String, dynamic>)).toList();
    }
    if (raw is List) {
      return raw.map((e) => GalleryItem.fromApi(e as Map<String, dynamic>)).toList();
    }
    return <GalleryItem>[];
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
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Galeri Sekolah',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant.withOpacity(.3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Tampilan grid',
                      icon: Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: _isGrid ? scheme.primary : scheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _isGrid = true),
                    ),
                    IconButton(
                      tooltip: 'Tampilan list',
                      icon: Icon(
                        Icons.view_list_rounded,
                        size: 20,
                        color: !_isGrid ? scheme.primary : scheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _isGrid = false),
                    ),
                  ],
                ),
              ),
            ],
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
          child: FutureBuilder<List<GalleryItem>>(
            future: _futureGallery,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat galeri',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
                  ),
                );
              }

              final all = snapshot.data ?? <GalleryItem>[];
              final items = _filtered(all);

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada data galeri.',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              return _isGrid
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final g = items[i];
                        final liked = _likedIds.contains(g.id);
                        final saved = _savedIds.contains(g.id);

                        return _GalleryCard(
                          item: g,
                          liked: liked,
                          saved: saved,
                          onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
                          onToggleLike: () {
                            setState(() {
                              if (liked) {
                                _likedIds.remove(g.id);
                              } else {
                                _likedIds.add(g.id);
                              }
                            });
                          },
                          onToggleSave: () {
                            setState(() {
                              if (saved) {
                                _savedIds.remove(g.id);
                              } else {
                                _savedIds.add(g.id);
                              }
                            });
                          },
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur unduh akan segera hadir.')),
                            );
                          },
                          isGrid: true,
                        );
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final g = items[i];
                        final liked = _likedIds.contains(g.id);
                        final saved = _savedIds.contains(g.id);

                        return _GalleryCard(
                          item: g,
                          liked: liked,
                          saved: saved,
                          onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
                          onToggleLike: () {
                            setState(() {
                              if (liked) {
                                _likedIds.remove(g.id);
                              } else {
                                _likedIds.add(g.id);
                              }
                            });
                          },
                          onToggleSave: () {
                            setState(() {
                              if (saved) {
                                _savedIds.remove(g.id);
                              } else {
                                _savedIds.add(g.id);
                              }
                            });
                          },
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur unduh akan segera hadir.')),
                            );
                          },
                          isGrid: false,
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final GalleryItem item;
  final bool liked;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleSave;
  final VoidCallback onDownload;
  final bool isGrid;

  const _GalleryCard({
    required this.item,
    required this.liked,
    required this.saved,
    required this.onTap,
    required this.onToggleLike,
    required this.onToggleSave,
    required this.onDownload,
    required this.isGrid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(item.imageUrl, fit: BoxFit.cover),
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
                item.category,
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
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
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
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: image,
                    ),
                  ),
                  _GalleryInfoSection(
                    item: item,
                    liked: liked,
                    saved: saved,
                    onToggleLike: onToggleLike,
                    onToggleSave: onToggleSave,
                    onDownload: onDownload,
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                      child: image,
                    ),
                  ),
                  Expanded(
                    child: _GalleryInfoSection(
                      item: item,
                      liked: liked,
                      saved: saved,
                      onToggleLike: onToggleLike,
                      onToggleSave: onToggleSave,
                      onDownload: onDownload,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GalleryInfoSection extends StatelessWidget {
  final GalleryItem item;
  final bool liked;
  final bool saved;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleSave;
  final VoidCallback onDownload;

  const _GalleryInfoSection({
    required this.item,
    required this.liked,
    required this.saved,
    required this.onToggleLike,
    required this.onToggleSave,
    required this.onDownload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            '${item.date.day}/${item.date.month}/${item.date.year}',
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Row(
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
                    onPressed: onToggleLike,
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
                    onPressed: onToggleSave,
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
                onPressed: onDownload,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
