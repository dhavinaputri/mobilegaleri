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

  factory NewsItem.fromApi(Map<String, dynamic> json) {
    final rawContent = (json['content'] ?? '') as String;
    String derivedSummary = (json['summary'] ?? '') as String;
    if (derivedSummary.isEmpty && rawContent.isNotEmpty) {
      final trimmed = rawContent.replaceAll(RegExp(r'\s+'), ' ').trim();
      derivedSummary = trimmed.length > 120 ? '${trimmed.substring(0, 117)}...' : trimmed;
    }

    final categoryName = json['news_category'] is Map<String, dynamic>
        ? (json['news_category']['name'] ?? 'Umum') as String
        : (json['category'] ?? 'Umum') as String;

    final dateString = (json['published_at'] ?? json['created_at'] ?? '') as String;
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(dateString);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final image = json['image'] as String?;

    return NewsItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '') as String,
      summary: derivedSummary,
      content: rawContent,
      category: categoryName,
      date: parsedDate,
      // Jika backend mengirim path relatif (mis. "news/xxx.jpg"), konversi ke URL penuh di public/images.
      imageUrl: image == null || image.isEmpty
          ? null
          : (image.startsWith('http://') || image.startsWith('https://'))
              ? image
              : 'https://eduspot.up.railway.app/images/$image',
    );
  }
}
