import 'package:flutter/material.dart';
import '../data/app_services.dart';
import '../models/news_item.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final categories = const [
    'Semua',
    'Pengumuman',
    'Kegiatan Sekolah',
    'Prestasi',
    'Artikel',
    'Edukasi',
  ];
  String selected = 'Semua';
  String query = '';

  late Future<List<NewsItem>> _futureNews;

  String _mapToDataCategory(String chip) {
    if (chip == 'Kegiatan Sekolah') return 'Kegiatan';
    if (chip == 'Edukasi') return 'Artikel';
    return chip;
  }

  @override
  void initState() {
    super.initState();
    _futureNews = _loadNews();
  }

  Future<List<NewsItem>> _loadNews() async {
    final raw = await apiService.listNews(page: 1);
    // Laravel pagination: data biasanya berisi { data: [...], ... }
    if (raw is Map<String, dynamic> && raw['data'] is List) {
      final list = raw['data'] as List;
      return list.map((e) => NewsItem.fromApi(e as Map<String, dynamic>)).toList();
    }
    if (raw is List) {
      return raw.map((e) => NewsItem.fromApi(e as Map<String, dynamic>)).toList();
    }
    return <NewsItem>[];
  }

  List<NewsItem> _applyFilter(List<NewsItem> source) {
    final base = selected == 'Semua'
        ? source
        : source.where((n) => n.category == _mapToDataCategory(selected)).toList();
    if (query.isEmpty) return base;
    final q = query.toLowerCase();
    return base
        .where((n) => n.title.toLowerCase().contains(q) || n.summary.toLowerCase().contains(q))
        .toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Filter Berita'),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const Divider(height: 0),
              ...categories.map((c) {
                final active = c == selected;
                return ListTile(
                  title: Text(c),
                  trailing: active ? const Icon(Icons.check_rounded) : null,
                  onTap: () => setState(() {
                    selected = c;
                    Navigator.of(context).pop();
                  }),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selected == 'Semua' ? 'Semua Berita' : 'Berita: $selected',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: scheme.surface,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: _showFilterSheet,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<NewsItem>>(
                future: _futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Gagal memuat berita',
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
                      ),
                    );
                  }

                  final all = snapshot.data ?? <NewsItem>[];
                  final items = _applyFilter(all);

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada berita.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      final crossAxisCount = isWide ? 3 : 2;

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          // Dibuat sedikit lebih tinggi agar konten kartu tidak overflow
                          childAspectRatio: 0.62,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final n = items[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => _openDetail(context, n),
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
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          if (n.imageUrl != null)
                                            Image.network(n.imageUrl!, fit: BoxFit.cover)
                                          else
                                            Container(color: scheme.surfaceVariant),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: scheme.primary,
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.event_rounded, color: Colors.white, size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    _fmt(n.date),
                                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: scheme.primary.withOpacity(.08),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        n.category,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                              color: scheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      n.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                                    child: Text(
                                      n.summary,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Baca selengkapnya',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                                color: scheme.primary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.arrow_right_alt_rounded, color: scheme.primary, size: 18),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, NewsItem item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _NewsDetail(item: item)));
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _NewsDetail extends StatelessWidget {
  final NewsItem item;
  const _NewsDetail({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header gradien dengan judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event_rounded, size: 16, color: Colors.white.withOpacity(.9)),
                      const SizedBox(width: 4),
                      Text(
                        _fmt(item.date),
                        style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withOpacity(.9)),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.person_rounded, size: 16, color: Colors.white.withOpacity(.9)),
                      const SizedBox(width: 4),
                      Text(
                        'Admin',
                        style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withOpacity(.9)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Kartu isi berita
            Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imageUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(item.imageUrl!, fit: BoxFit.cover),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                item.category,
                                style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _fmt(item.date),
                              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Admin',
                              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.summary,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: scheme.outlineVariant.withOpacity(.6)),
                        const SizedBox(height: 8),
                        Text(item.content, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Bagikan:', style: theme.textTheme.labelMedium),
                            const SizedBox(width: 8),
                            Icon(Icons.share_rounded, color: scheme.primary),
                            const SizedBox(width: 6),
                            Icon(Icons.chat_rounded, color: Colors.green.shade600),
                            const SizedBox(width: 6),
                            const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2)),
                            const SizedBox(width: 6),
                            const Icon(Icons.telegram_rounded, color: Color(0xFF27A5E7)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Komentar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.primary.withOpacity(.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login Diperlukan', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    'Silakan login terlebih dahulu untuk dapat memberikan komentar.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Login Sekarang'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada komentar. Jadilah yang pertama berkomentar!',
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Berita Terkait', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Lihat semua berita'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Untuk saat ini, data berita terkait belum diambil dari API secara terpisah.
            // Bagian ini bisa diisi kemudian dengan pemanggilan API tambahan jika dibutuhkan.
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
