import 'package:flutter/material.dart';

class SubmitPhotoPage extends StatelessWidget {
  const SubmitPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Foto')),
      body: const Center(child: Text('Form pengajuan foto (placeholder)')),
    );
  }
}
