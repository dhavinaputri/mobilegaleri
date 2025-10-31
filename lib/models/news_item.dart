class NewsItem {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category; // Pengumuman, Kegiatan, Prestasi, Artikel
  final DateTime date;
  final String? imageUrl;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.date,
    this.imageUrl,
  });
}
