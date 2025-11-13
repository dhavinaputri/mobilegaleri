import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
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

  String _mapToDataCategory(String chip) {
    if (chip == 'Kegiatan Sekolah') return 'Kegiatan';
    if (chip == 'Edukasi') return 'Artikel';
    return chip;
  }

  List<NewsItem> get filtered {
    final base = selected == 'Semua'
        ? DummyData.news
        : DummyData.news.where((n) => n.category == _mapToDataCategory(selected)).toList();
    if (query.isEmpty) return base;
    final q = query.toLowerCase();
    return base
        .where((n) => n.title.toLowerCase().contains(q) || n.summary.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          // Discover/Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: 'Cari berita di sini',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (q) => setState(() => query = q),
            ),
          ),
          const SizedBox(height: 8),
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.imageUrl != null)
                    Image.network(item.imageUrl!, fit: BoxFit.cover)
                  else
                    Container(color: Colors.grey.shade300),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(.6), Colors.transparent],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(.9), borderRadius: BorderRadius.circular(999)),
                            child: Text(item.category, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Trending • ${_fmt(item.date)}',
                            style: TextStyle(color: Colors.white.withOpacity(.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 14, child: Icon(Icons.newspaper_rounded, size: 16)),
                      const SizedBox(width: 8),
                      Text('SMKN 4 News', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 10),
                      const Icon(Icons.verified_rounded, color: Colors.blue, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.content, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
