import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/gallery_item.dart';

class GalleryCategoryPage extends StatelessWidget {
  final String category;
  const GalleryCategoryPage({super.key, required this.category});

  List<GalleryItem> _filteredItems() {
    if (category == 'Semua') return DummyData.gallery;

    String dataCategory = category;
    if (category == 'Fasilitas Sekolah') {
      dataCategory = 'Fasilitas';
    }
    return DummyData.gallery.where((g) => g.category == dataCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final items = _filteredItems();
    final isWide = MediaQuery.of(context).size.width > 800;
    final crossAxisCount = isWide ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final g = items[i];
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.of(context).pushNamed('/gallery/${g.id}'),
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(g.imageUrl, fit: BoxFit.cover),
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
                                g.category,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: Text(
                      g.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${g.date.day}/${g.date.month}/${g.date.year}',
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
