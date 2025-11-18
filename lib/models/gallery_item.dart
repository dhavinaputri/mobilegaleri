class GalleryItem {
  final String id;
  final String title;
  final String category; // Kegiatan, Fasilitas, Prestasi
  final String imageUrl;
  final DateTime date;

  GalleryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.date,
  });

  factory GalleryItem.fromApi(Map<String, dynamic> json) {
    final kategoriName = json['kategori'] is Map<String, dynamic>
        ? (json['kategori']['nama'] ?? 'Umum') as String
        : (json['category'] ?? 'Umum') as String;

    final dateString = (json['created_at'] ?? '') as String;
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(dateString);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final image = (json['image'] ?? '') as String;

    return GalleryItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '') as String,
      category: kategoriName,
      // Backend menyimpan gambar di public/images (mis. "galleries/...", "news/...").
      imageUrl: image.isEmpty
          ? image
          : (image.startsWith('http://') || image.startsWith('https://'))
              ? image
              : 'https://eduspot.up.railway.app/images/$image',
      date: parsedDate,
    );
  }
}
