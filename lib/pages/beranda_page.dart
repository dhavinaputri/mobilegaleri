import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../routes.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final news = DummyData.news;
    final galleries = DummyData.gallery;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF6625AC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.school, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text('SELAMAT DATANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Membangun Masa Depan di ${DummyData.schoolName}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(DummyData.visi,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.gallery),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1D4ED8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Lihat Galeri'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(.7)), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                            icon: const Icon(Icons.newspaper_outlined),
                            label: const Text('Baca Berita'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('Berita Terpopuler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ...news.take(2).map((n) {
                  return Card(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _NewsInlineDetail(item: n))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                            child: Image.network(
                              n.imageUrl ?? 'https://images.unsplash.com/photo-1577896851231-70ef18881754?auto=format&fit=crop&w=600&q=80',
                              width: 110,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
                                        child: Text('${n.date.day}/${n.date.month}/${n.date.year}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(n.category, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[600])),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(n.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text(n.summary, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _NewsInlineDetail(item: n))),
                                      icon: const Icon(Icons.arrow_forward, size: 16),
                                      label: const Text('Baca Selengkapnya'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                if (news.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(RoutePaths.news),
                        icon: const Icon(Icons.newspaper),
                        label: const Text('Lihat Semua Berita'),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 20, color: const Color(0xFF1D4ED8)),
                    const SizedBox(width: 8),
                    Text('Galeri Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                if (galleries.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: galleries.take(9).length,
                    itemBuilder: (context, i) {
                      final g = galleries[i];
                      return _GalleryCard(g: g);
                    },
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 48, color: Color(0xFF1D4ED8)),
                          const SizedBox(height: 8),
                          Text('Galeri Foto Segera Hadir', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text('Koleksi foto kegiatan sekolah akan segera ditampilkan di sini.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
                if (galleries.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(RoutePaths.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Lihat Semua Galeri'),
                      ),
                    ),
                  ),
              ],
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
      onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}') ,
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
                  colors: [Colors.black.withOpacity(.6), Colors.transparent],
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
