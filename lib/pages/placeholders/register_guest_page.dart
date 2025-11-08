import 'package:flutter/material.dart';
import '../../routes.dart';
import '../login_guest_page.dart';

class RegisterGuestPage extends StatelessWidget {
  const RegisterGuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final email = TextEditingController();
    final pass = TextEditingController();
    final confirm = TextEditingController();

    InputDecoration deco(String label) => InputDecoration(
          labelText: label,
          filled: true,
          fillColor: scheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.outline)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.primary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F5FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (_, c) {
            final isWide = c.maxWidth > 700;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 420 : 380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: scheme.primary.withOpacity(0.12),
                        child: Icon(Icons.person_add_alt_1, size: 36, color: scheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text('Buat Akun Baru', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text('Sudah punya akun? ', style: theme.textTheme.bodyMedium),
                          InkWell(
                            onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginGuestPage())),
                            child: Text('Masuk di sini', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Card(
                        elevation: 10,
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: name,
                                  decoration: deco('Nama Lengkap').copyWith(prefixIcon: const Icon(Icons.person_outline), hintText: 'Masukkan nama Anda'),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: deco('Email').copyWith(prefixIcon: const Icon(Icons.email_outlined), hintText: 'Masukkan email Anda'),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                                    final re = RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$');
                                    return re.hasMatch(v) ? null : 'Format email tidak valid';
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: pass,
                                  obscureText: true,
                                  decoration: deco('Password (min. 8 karakter)').copyWith(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    hintText: 'Minimal 8 karakter',
                                  ),
                                  validator: (v) => (v == null || v.length < 8) ? 'Minimal 8 karakter' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: confirm,
                                  obscureText: true,
                                  decoration: deco('Konfirmasi Password').copyWith(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    hintText: 'Ulangi password',
                                  ),
                                  validator: (v) => (v != pass.text) ? 'Konfirmasi tidak cocok' : null,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ?? false) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil (dummy)')));
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginGuestPage()));
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: const StadiumBorder(),
                                      backgroundColor: Color(0xFF1D4ED8),
                                    ),
                                    icon: const Icon(Icons.person_add_alt_1),
                                    label: const Text('Daftar'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context).pushNamed(RoutePaths.home),
                                    child: const Text('Lanjut sebagai Tamu'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Dengan mendaftar, Anda setuju dengan ketentuan layanan dan kebijakan privasi.',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
