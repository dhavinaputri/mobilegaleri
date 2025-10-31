import 'package:flutter/material.dart';

class GalleryCategoryPage extends StatelessWidget {
  final String category;
  const GalleryCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kategori: $category')),
      body: Center(child: Text('Galeri kategori $category (placeholder)')),
    );
  }
}
