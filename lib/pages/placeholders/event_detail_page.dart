import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String slug;
  const EventDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event: $slug')),
      body: Center(child: Text('Event detail for $slug (placeholder)')),
    );
  }
}
