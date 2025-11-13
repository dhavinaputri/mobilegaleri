import 'package:flutter/material.dart';
import '../../routes.dart';
import '../login_guest_page.dart';

class RegisterGuestPage extends StatefulWidget {
  const RegisterGuestPage({super.key});

  @override
  State<RegisterGuestPage> createState() => _RegisterGuestPageState();
}

class _RegisterGuestPageState extends State<RegisterGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  InputDecoration _deco(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.outline)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                        radius: 30,
                        backgroundColor: const Color(0xFFEFF6FF),
                        child: const Icon(Icons.person_add_alt_1, size: 28, color: Color(0xFF1D4ED8)),
                      ),
                      const SizedBox(height: 16),
                      Text('Buat Akun Baru', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 6),
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
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _name,
                                  decoration: _deco(context, 'Nama Lengkap').copyWith(prefixIcon: const Icon(Icons.person_outline), hintText: 'Masukkan nama Anda'),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _deco(context, 'Email').copyWith(prefixIcon: const Icon(Icons.email_outlined), hintText: 'Masukkan email Anda'),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                                    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                    return re.hasMatch(v) ? null : 'Format email tidak valid';
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _pass,
                                  obscureText: _obscure1,
                                  decoration: _deco(context, 'Password').copyWith(
                                    hintText: 'Minimal 8 karakter',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      tooltip: _obscure1 ? 'Tampilkan' : 'Sembunyikan',
                                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                                      icon: Icon(_obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.length < 8) ? 'Minimal 8 karakter' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _confirm,
                                  obscureText: _obscure2,
                                  decoration: _deco(context, 'Konfirmasi Password').copyWith(
                                    hintText: 'Ulangi password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      tooltip: _obscure2 ? 'Tampilkan' : 'Sembunyikan',
                                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                                      icon: Icon(_obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                    ),
                                  ),
                                  validator: (v) => (v != _pass.text) ? 'Konfirmasi tidak cocok' : null,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: scheme.outline.withOpacity(.4)),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(value: false, onChanged: (_) {}),
                                      const Text("I'm not a robot"),
                                      const Spacer(),
                                      Container(
                                        width: 80,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: scheme.outline.withOpacity(.5)),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text('reCAPTCHA', style: TextStyle(fontSize: 10, color: Colors.black54)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
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
