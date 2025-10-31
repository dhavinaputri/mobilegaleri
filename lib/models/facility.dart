class Facility {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;

  Facility({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });
}
