class Teacher {
  final String id;
  final String name;
  final String subject;
  final String? photoUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    this.photoUrl,
  });

  factory Teacher.fromApi(Map<String, dynamic> json) {
    final image = json['image'] as String?;
    return Teacher(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '') as String,
      // API menggunakan field 'position' untuk jabatan/mata pelajaran.
      subject: (json['position'] ?? '') as String,
      photoUrl: image == null || image.isEmpty
          ? null
          : (image.startsWith('http://') || image.startsWith('https://'))
              ? image
              : 'https://eduspot.up.railway.app/storage/$image',
    );
  }
}
