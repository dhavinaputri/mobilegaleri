import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/news_item.dart';

class NewsDetailPage extends StatefulWidget {
  final String slug;
  const NewsDetailPage({super.key, required this.slug});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final List<String> comments = [
    'Terima kasih informasinya!',
    'Sangat bermanfaat.',
  ];
  final _commentCtrl = TextEditingController();

  NewsItem? get item => DummyData.news.firstWhere(
        (n) => n.title.toLowerCase().replaceAll(' ', '-') == widget.slug,
        orElse: () => DummyData.news.first,
      );

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = item;
    return Scaffold(
      appBar: AppBar(title: Text(n?.title ?? 'Berita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              n?.title ?? '-',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(n?.category ?? '-')),
                const SizedBox(width: 8),
                Text(_fmt(n?.date)),
              ],
            ),
            const SizedBox(height: 12),
            if (n?.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(n!.imageUrl!, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text(
              n?.content ?? '-',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
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
      ),
    );
  }

  String _fmt(DateTime? d) => d == null ? '-' : '${d.day}/${d.month}/${d.year}';
}
