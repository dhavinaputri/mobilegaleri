import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Alamat'),
            subtitle: Text(DummyData.address),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Telepon'),
            subtitle: Text(DummyData.phone),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(DummyData.email),
          ),
          const SizedBox(height: 16),
          Text('Kirim Pesan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const _ContactForm(),
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('Map Placeholder')),
          )
        ],
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nama'),
            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v == null || !v.contains('@') ? 'Email tidak valid' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _message,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Pesan'),
            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Placeholder: integrate with backend later
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesan terkirim (dummy).')));
              }
            },
            icon: const Icon(Icons.send),
            label: const Text('Kirim'),
          )
        ],
      ),
    );
  }
}
