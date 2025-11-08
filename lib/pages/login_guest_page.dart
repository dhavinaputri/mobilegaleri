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
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GridBgPainter(color: const Color(0xFF0F172A).withOpacity(0.035)),
                ),
              ),
            ),
            LayoutBuilder(
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
                      // Header arc
                      ClipPath(
                        clipper: _HeaderArcClipper(),
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.security_rounded, size: 32, color: const Color(0xFF1D4ED8)),
                              ),
                              const SizedBox(height: 12),
                              Text('Masuk Sekarang', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 0),
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Column(
                          children: [
                            Card(
                              elevation: 10,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            'Masuk ke Dashboard',
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ),
                                      Text('Email', style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface.withOpacity(0.7))),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: _fieldDecoration('Masukkan email Anda').copyWith(
                                          prefixIcon: const Icon(Icons.email_outlined),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                                          final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                          if (!re.hasMatch(v)) return 'Format email tidak valid';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Text('Password', style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface.withOpacity(0.7))),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscure,
                                        decoration: _fieldDecoration('Password').copyWith(
                                          prefixIcon: const Icon(Icons.lock_outline),
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
                                          Switch.adaptive(
                                            value: _remember,
                                            onChanged: (v) => setState(() => _remember = v),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text('Ingat saya'),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.guestForgot),
                                            child: const Text('Lupa kata sandi?'),
                                          ),
                                        ],
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
                                          label: const Text('Masuk ke Dashboard'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pushNamed(RoutePaths.guestForgot),
                            child: const Text('Lupa password? Reset di sini.'),
                          ),
                          Text(
                            'Jika mengalami kendala, Anda dapat tetap menghubungi administrator.',
                            style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: _loginAsGuest,
                        child: const Text('Lanjut sebagai Tamu'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
          ],
        ),
      ),
    );
  }
}

class _GridBgPainter extends CustomPainter {
  final Color color;
  const _GridBgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const gap = 24.0;
    // vertical lines
    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // horizontal lines
    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridBgPainter oldDelegate) => oldDelegate.color != color;
}

class _HeaderArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
