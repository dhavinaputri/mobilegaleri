import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

/// ---------------------------
/// Helper Widgets
/// ---------------------------

class _IconFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconFeature({required this.icon, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: scheme.primary.withOpacity(.20)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  const _ProgramCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outline.withOpacity(.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 16, color: iconColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// TentangPage (Full Page)
/// ---------------------------

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Sekolah'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // --------------------------
          // Sejarah Singkat
          // --------------------------
          _sectionTitle(context, 'Sejarah Singkat'),
          const SizedBox(height: 8),
          Text(
            'Sekolah ini berdiri sejak tahun 1990 dan terus berkembang menjadi sekolah vokasi unggulan di Kota Bogor. '
            'Selama puluhan tahun, sekolah aktif menjalin kerja sama dengan industri lokal dan menghasilkan lulusan yang siap kerja.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Profil Sekolah & Keunggulan
          // --------------------------
          _sectionTitle(context, 'Profil Sekolah'),
          const SizedBox(height: 8),
          Text(
            'SMKN 4 Bogor berkomitmen membentuk generasi unggul yang berkarakter, kreatif, dan siap kerja. '
            'Sekolah menyediakan pendidikan vokasi modern yang relevan dengan kebutuhan industri.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          // Keunggulan
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline.withOpacity(.08)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _IconFeature(icon: Icons.apps_rounded, text: 'Kompetensi keahlian beragam'),
                SizedBox(height: 8),
                _IconFeature(icon: Icons.handshake_rounded, text: 'Kolaborasi erat dengan industri'),
                SizedBox(height: 8),
                _IconFeature(icon: Icons.apartment_rounded, text: 'Fasilitas praktik dan laboratorium modern'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Visi
          // --------------------------
          _sectionTitle(context, 'Visi'),
          const SizedBox(height: 8),
          Text(
            DummyData.visi ?? '—',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Misi
          // --------------------------
          _sectionTitle(context, 'Misi'),
          const SizedBox(height: 8),
          Column(
            children: (DummyData.misi ?? <String>[]).map<Widget>((m) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check_circle_outline, color: scheme.primary),
                title: Text(m, style: theme.textTheme.bodyMedium),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Program Keahlian
          // --------------------------
          _sectionTitle(context, 'Program Keahlian'),
          const SizedBox(height: 8),
          Text(
            'Program keahlian yang tersedia di sekolah, dirancang untuk memenuhi kebutuhan industri dan keterampilan vokasi.',
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          // Cards for programs (choose one representation: cards)
          Column(
            children: (DummyData.programs ?? <dynamic>[]).map<Widget>((p) {
              // assume p has properties: name, description
              final String name = p.name ?? 'Program';
              final String desc = p.description ?? '';
              IconData icon = Icons.school;
              Color iconColor = scheme.primary;

              // choose icon/color by program name (optional)
              if (name.toLowerCase().contains('pplg')) {
                icon = Icons.code_rounded;
                iconColor = const Color(0xFF1D4ED8);
              } else if (name.toLowerCase().contains('tjkt')) {
                icon = Icons.router_rounded;
                iconColor = const Color(0xFF16A34A);
              } else if (name.toLowerCase().contains('tpfl')) {
                icon = Icons.handyman_rounded;
                iconColor = const Color(0xFFF59E0B);
              } else if (name.toLowerCase().contains('tkro')) {
                icon = Icons.directions_car_filled_rounded;
                iconColor = const Color(0xFFEF4444);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ProgramCard(
                  title: name,
                  description: desc,
                  icon: icon,
                  iconColor: iconColor,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Tim Pengajar
          // --------------------------
          _sectionTitle(context, 'Tim Pengajar'),
          const SizedBox(height: 8),
          Column(
            children: (DummyData.teachers ?? <dynamic>[]).map<Widget>((t) {
              final String name = t.name ?? 'Nama Guru';
              final String subject = t.subject ?? '';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(name),
                  subtitle: Text(subject),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // --------------------------
          // Fasilitas
          // --------------------------
          _sectionTitle(context, 'Fasilitas'),
          const SizedBox(height: 8),
          Column(
            children: (DummyData.facilities ?? <dynamic>[]).map<Widget>((f) {
              final String name = f.name ?? 'Fasilitas';
              final String desc = f.description ?? '';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(name),
                  subtitle: Text(desc),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          // Optional: Kontak singkat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline.withOpacity(.06)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Kontak Sekolah', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Expanded(child: Text(DummyData.address ?? 'Alamat sekolah belum diatur')),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.phone_outlined),
                  const SizedBox(width: 8),
                  Text(DummyData.phone ?? '-'),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.email_outlined),
                  const SizedBox(width: 8),
                  Text(DummyData.email ?? '-'),
                ],
              ),
            ]),
          ),

          const SizedBox(height: 36),
        ]),
      ),
    );
  }
}
