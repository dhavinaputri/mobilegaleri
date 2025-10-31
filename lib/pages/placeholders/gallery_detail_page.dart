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

  @override
  Widget build(BuildContext context) {
    final g = item;
    return Scaffold(
      appBar: AppBar(title: Text(g?.title ?? 'Galeri')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: g == null
                  ? const SizedBox.shrink()
                  : Image.network(g.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g?.title ?? '-', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Chip(label: Text(g?.category ?? '-')),
                      const SizedBox(width: 8),
                      Text(_fmt(g?.date)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () => setState(() => liked = !liked),
                        icon: Icon(liked ? Icons.thumb_up : Icons.thumb_up_outlined),
                        label: Text(liked ? 'Disukai' : 'Suka'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => setState(() => favorited = !favorited),
                        icon: Icon(favorited ? Icons.favorite : Icons.favorite_border),
                        label: const Text('Favorit'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Komentar', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (_, i) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(child: Icon(Icons.person, size: 18)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(comments[i])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentCtrl,
                          decoration: const InputDecoration(hintText: 'Tulis komentar…'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          final t = _commentCtrl.text.trim();
                          if (t.isEmpty) return;
                          setState(() {
                            comments.add(t);
                            _commentCtrl.clear();
                          });
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime? d) => d == null ? '-' : '${d.day}/${d.month}/${d.year}';
}
