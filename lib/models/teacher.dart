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
}
