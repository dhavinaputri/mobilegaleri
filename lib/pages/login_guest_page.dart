import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import '../routes.dart';
import 'placeholders/register_guest_page.dart';

class LoginGuestPage extends StatefulWidget {
  const LoginGuestPage({super.key});

  @override
  State<LoginGuestPage> createState() => _LoginGuestPageState();
}

class _LoginGuestPageState extends State<LoginGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@test.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      
      if (!mounted) return;
      
      // Navigasi ke halaman home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  Future<void> _loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    InputDecoration _fieldDecoration(String hint) => InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: scheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: scheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: scheme.primary),
          ),
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
          builder: (_, constraints) {
            final isWide = constraints.maxWidth > 700;
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 420 : 380),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: const Icon(Icons.person, size: 28, color: Color(0xFF1D4ED8)),
                        ),
                        const SizedBox(height: 16),
                        Text('Masuk ke Akun', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                        const SizedBox(height: 6),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text('Belum punya akun? ', style: theme.textTheme.bodyMedium),
                            InkWell(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterGuestPage())),
                              child: Text('Daftar di sini', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Column(
                          children: [
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
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          const Icon(Icons.email_outlined, size: 18, color: Color(0xFF1D4ED8)),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Email',
                                            style: theme.textTheme.labelMedium?.copyWith(
                                              color: scheme.onSurface.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: _fieldDecoration('Masukkan email Anda'),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                                          final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                          if (!re.hasMatch(v)) return 'Format email tidak valid';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const Icon(Icons.lock_outline, size: 18, color: Color(0xFF1D4ED8)),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Password',
                                            style: theme.textTheme.labelMedium?.copyWith(
                                              color: scheme.onSurface.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscure,
                                        decoration: _fieldDecoration('Password').copyWith(
                                          suffixIcon: IconButton(
                                            tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                                            onPressed: () => setState(() => _obscure = !_obscure),
                                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                          ),
                                        ),
                                        validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _remember,
                                            onChanged: (v) => setState(() => _remember = v ?? false),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text('Ingat saya'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
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
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FilledButton.icon(
                                          onPressed: _submit,
                                          style: FilledButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: const StadiumBorder(),
                                            backgroundColor: Color(0xFF1D4ED8),
                                          ),
                                          icon: const Icon(Icons.login_rounded),
                                          label: const Text('Masuk'),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          onPressed: _loginAsGuest,
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: const StadiumBorder(),
                                            side: BorderSide(color: scheme.outline),
                                          ),
                                          icon: const Icon(Icons.person_outline),
                                          label: const Text('Lanjut sebagai Tamu'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(RoutePaths.guestForgot),
                              child: const Text('Lupa password? Reset di sini.'),
                            ),
                            Text(
                              'Jika mengalami kendala, Anda dapat tetap menghubungi administrator.',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ],
                    ),
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
