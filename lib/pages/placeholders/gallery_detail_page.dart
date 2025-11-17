import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/gallery_item.dart';

class GalleryDetailPage extends StatefulWidget {
  final String id;
  const GalleryDetailPage({super.key, required this.id});

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  bool liked = false;
  bool favorited = false;
  final _commentCtrl = TextEditingController();
  final List<String> comments = [
    'Keren sekali!',
    'Fotonya bagus.',
  ];

  GalleryItem? get item =>
      DummyData.gallery.firstWhere((g) => g.id == widget.id, orElse: () => DummyData.gallery.first);

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Widget _buildIconAction({
    required BuildContext context,
    required IconData icon,
    required bool active,
    Color? activeColor,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final color = active
        ? (activeColor ?? scheme.primary)
        : scheme.primary.withOpacity(.85);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(.15) : scheme.primary.withOpacity(.06),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  void _openFullView(GalleryItem current) {
    final all = DummyData.gallery;
    final startIndex = all.indexWhere((g) => g.id == current.id).clamp(0, all.length - 1);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(.9),
        pageBuilder: (ctx, _, __) {
          final controller = PageController(initialPage: startIndex);
          return GestureDetector(
            onTap: () => Navigator.of(ctx).pop(),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(.9),
              body: SafeArea(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller,
                      itemCount: all.length,
                      itemBuilder: (context, index) {
                        final gi = all[index];
                        return Center(
                          child: Hero(
                            tag: 'gallery-full-${gi.id}',
                            child: InteractiveViewer(
                              child: AspectRatio(
                                aspectRatio: 3 / 2,
                                child: Image.network(
                                  gi.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final g = item;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(g?.title ?? 'Galeri')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu utama
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
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: g == null
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () => _openFullView(g),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              child: Image.network(g.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g?.title ?? '-',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                g?.category ?? '-',
                                style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _fmt(g?.date),
                              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIconAction(
                              context: context,
                              icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              active: liked,
                              activeColor: Colors.redAccent,
                              onTap: () => setState(() => liked = !liked),
                            ),
                            _buildIconAction(
                              context: context,
                              icon: favorited ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              active: favorited,
                              onTap: () => setState(() => favorited = !favorited),
                            ),
                            _buildIconAction(
                              context: context,
                              icon: Icons.download_rounded,
                              active: false,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Fitur unduh akan segera hadir.')),
                                );
                              },
                            ),
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
            if (comments.isEmpty)
              Text('Belum ada komentar. Jadilah yang pertama berkomentar!', style: theme.textTheme.bodySmall)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (_, i) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: scheme.primary.withOpacity(.08),
                      child: Icon(Icons.person, size: 18, color: scheme.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: scheme.surfaceVariant.withOpacity(.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(comments[i]),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar…',
                      filled: true,
                      fillColor: scheme.surfaceVariant.withOpacity(.2),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container
                  (
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final t = _commentCtrl.text.trim();
                      if (t.isEmpty) return;
                      setState(() {
                        comments.add(t);
                        _commentCtrl.clear();
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text('Galeri Lainnya', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: DummyData.gallery.where((x) => x.id != g?.id).length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final others = DummyData.gallery.where((x) => x.id != g?.id).toList();
                  final og = others[i];
                  return InkWell(
                    onTap: () => Navigator.of(context).pushReplacementNamed('/gallery/${og.id}'),
                    child: SizedBox(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(og.imageUrl, fit: BoxFit.cover, width: double.infinity),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            og.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            _fmt(og.date),
                            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime? d) => d == null ? '-' : '${d.day}/${d.month}/${d.year}';
}
