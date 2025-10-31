import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/gallery_item.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  final categories = const ['Semua', 'Kegiatan', 'Fasilitas', 'Prestasi'];
  String selected = 'Semua';

  List<GalleryItem> get filtered {
    if (selected == 'Semua') return DummyData.gallery;
    return DummyData.gallery.where((g) => g.category == selected).toList();
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    return Column(
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
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final g = filtered[i];
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(g.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(g.category),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(g.imageUrl, fit: BoxFit.cover),
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
