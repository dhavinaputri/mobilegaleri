import 'package:flutter/material.dart';
import '../../data/app_services.dart';
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

  GalleryItem? item;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final raw = await apiService.galleryDetail(widget.id);
      if (raw is Map<String, dynamic>) {
        setState(() {
          item = GalleryItem.fromApi(raw);
        });
      }
    } catch (_) {
      // Biarkan UI menampilkan keadaan kosong jika gagal memuat
    }
  }

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
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(.9),
        pageBuilder: (ctx, _, __) {
          return GestureDetector(
            onTap: () => Navigator.of(ctx).pop(),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(.9),
              body: Center(
                child: Hero(
                  tag: 'gallery-full-${current.id}',
                  child: InteractiveViewer(
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Image.network(
                        current.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
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
                        // Aksi seperti Instagram: like, komentar, simpan
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: liked ? Colors.redAccent : scheme.onSurface,
                              ),
                              onPressed: () => setState(() => liked = !liked),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.mode_comment_outlined, color: scheme.onSurface),
                              onPressed: () {
                                // Arahkan pengguna untuk menggulir ke bagian komentar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Scroll ke bawah untuk melihat dan menulis komentar.')),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(
                                favorited ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: favorited ? scheme.primary : scheme.onSurface,
                              ),
                              onPressed: () => setState(() => favorited = !favorited),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fitur unduh akan segera hadir.')),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: const Text('Unduh Foto'),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            ),
                          ),
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
            // Untuk saat ini, daftar "Galeri Lainnya" belum diambil dari API secara terpisah.
            // Bagian ini bisa diisi kemudian dengan pemanggilan API tambahan jika dibutuhkan.
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime? d) => d == null ? '-' : '${d.day}/${d.month}/${d.year}';
}
