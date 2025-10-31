import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sejarah Singkat', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Sekolah ini berdiri sejak tahun 1990 dan telah melahirkan lulusan terbaik di berbagai bidang.'),
          const SizedBox(height: 16),
          Text('Visi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(DummyData.visi),
          const SizedBox(height: 16),
          Text('Misi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...DummyData.misi.map((m) => ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(m))),
          const SizedBox(height: 16),
          Text('Program Keahlian', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...DummyData.programs.map((p) => Card(
                child: ListTile(
                  leading: const Icon(Icons.star_border),
                  title: Text(p.name),
                  subtitle: Text(p.description),
                ),
              )),
          const SizedBox(height: 16),
          Text('Tim Pengajar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...DummyData.teachers.map((t) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(t.name),
                subtitle: Text(t.subject),
              )),
          const SizedBox(height: 16),
          Text('Fasilitas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...DummyData.facilities.map((f) => Card(
                child: ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(f.name),
                  subtitle: Text(f.description),
                ),
              )),
        ],
      ),
    );
  }
}
