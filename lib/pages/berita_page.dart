import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/news_item.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final categories = const ['Semua', 'Pengumuman', 'Kegiatan', 'Prestasi', 'Artikel', 'Event'];
  String selected = 'Semua';

  List<NewsItem> get filtered {
    if (selected == 'Semua') return DummyData.news;
    return DummyData.news.where((n) => n.category == selected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 52,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final c = categories[i];
              final active = c == selected;
              return ChoiceChip(
                label: Text(c),
                selected: active,
                onSelected: (_) => setState(() => selected = c),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: categories.length,
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final n = filtered[i];
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: n.imageUrl == null
                        ? const Icon(Icons.article_outlined)
                        : Image.network(
                            n.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(n.title),
                  subtitle: Text('${n.category} • ${_fmt(n.date)}\n${n.summary}'),
                  isThreeLine: true,
                  onTap: () => _openDetail(context, n),
                ),
              );
            },
          ),
        ),
      ],
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
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.category} • ${_fmt(item.date)}', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 12),
            Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(item.content),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
