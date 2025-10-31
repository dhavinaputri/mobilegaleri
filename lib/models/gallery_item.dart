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
}
