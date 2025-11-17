import '../models/models.dart';

class DummyData {
  static const schoolName = 'SMKN 4 Bogor';
  static const tagline = 'Pendidikan Berkualitas';
  static const address = 'Jl. Contoh No. 123, Bogor';
  static const phone = '(0251) 123456';
  static const email = 'info@smkn4bogor.sch.id';

  static final visi = 'Menjadi sekolah kejuruan unggul yang menghasilkan lulusan berkarakter, kompeten, dan berdaya saing.';
  static final misi = [
    'Menyelenggarakan pendidikan dan pelatihan berbasis kompetensi.',
    'Mengembangkan budaya kerja, disiplin, dan etos profesional.',
    'Menjalin kemitraan dengan dunia usaha dan industri.'
  ];

  static final programs = <ProgramKeahlian>[
    ProgramKeahlian(
      id: 'pplg',
      name: 'PPLG (Pengembangan Perangkat Lunak dan Gim)',
      description: 'Fokus pada pemrograman web, mobile, dan pengembangan gim dengan teknologi terkini.',
    ),
    ProgramKeahlian(
      id: 'tkjt',
      name: 'TKJT (Teknik Komputer dan Jaringan Telekomunikasi)',
      description: 'Jaringan komputer, sistem server, dan infrastruktur jaringan untuk dunia industri.',
    ),
    ProgramKeahlian(
      id: 'tpfl',
      name: 'TPFL (Teknik Pengelasan Fabrikasi Logam)',
      description: 'Keahlian pengelasan dan fabrikasi logam untuk kebutuhan manufaktur.',
    ),
    ProgramKeahlian(
      id: 'tkro',
      name: 'TKRO (Teknik Kendaraan Ringan Otomotif)',
      description: 'Perawatan dan perbaikan kendaraan ringan dengan standar bengkel modern.',
    ),
  ];

  static final teachers = [
    Teacher(id: 't1', name: 'Budi Santoso, S.Kom', subject: 'RPL'),
    Teacher(id: 't2', name: 'Siti Aminah, S.Sn', subject: 'DKV'),
    Teacher(id: 't3', name: 'Andi Wijaya, S.T', subject: 'Listrik'),
  ];

  static final facilities = [
    Facility(id: 'f1', name: 'Lab Komputer', description: 'Komputer spesifikasi modern untuk pembelajaran.'),
    Facility(id: 'f2', name: 'Perpustakaan', description: 'Sumber literasi bagi siswa.'),
    Facility(id: 'f3', name: 'Workshop Listrik', description: 'Peralatan praktik instalasi listrik.'),
  ];

  static final news = <NewsItem>[
    NewsItem(
      id: 'n1',
      title: 'Pengumuman PPDB 2025',
      summary: 'Informasi pendaftaran peserta didik baru.',
      content: 'Detail persyaratan, jadwal, dan prosedur pendaftaran... ',
      category: 'Pengumuman',
      date: DateTime(2025, 1, 10),
      // Foto gerbang / suasana sekolah
      imageUrl: 'https://images.pexels.com/photos/256395/pexels-photo-256395.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    NewsItem(
      id: 'n2',
      title: 'Kegiatan OSIS: Bakti Sosial',
      summary: 'OSIS melaksanakan bakti sosial di lingkungan sekolah.',
      content: 'Laporan kegiatan bakti sosial... ',
      category: 'Kegiatan',
      date: DateTime(2025, 2, 5),
      // Foto siswa kegiatan di luar ruangan
      imageUrl: 'https://images.pexels.com/photos/1089079/pexels-photo-1089079.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    NewsItem(
      id: 'n3',
      title: 'Prestasi Juara LKS',
      summary: 'Siswa RPL raih juara LKS tingkat kota.',
      content: 'Cerita lengkap capaian siswa... ',
      category: 'Prestasi',
      date: DateTime(2025, 3, 2),
      // Foto piala / penghargaan
      imageUrl: 'https://images.pexels.com/photos/261909/pexels-photo-261909.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    NewsItem(
      id: 'n4',
      title: 'Artikel: Tips Belajar Efektif',
      summary: 'Artikel edukasi untuk siswa.',
      content: 'Beberapa tips dan teknik belajar... ',
      category: 'Artikel',
      date: DateTime(2025, 4, 20),
      // Foto siswa belajar di kelas
      imageUrl: 'https://images.pexels.com/photos/1720186/pexels-photo-1720186.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
  ];

  static final gallery = <GalleryItem>[
    GalleryItem(
      id: 'g1',
      title: 'Upacara Bendera',
      category: 'Kegiatan',
      // Lapangan sekolah / upacara
      imageUrl: 'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800',
      date: DateTime(2025, 1, 1),
    ),
    GalleryItem(
      id: 'g2',
      title: 'Lab Komputer',
      category: 'Fasilitas',
      // Siswa di lab komputer
      imageUrl: 'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&w=800',
      date: DateTime(2025, 1, 15),
    ),
    GalleryItem(
      id: 'g3',
      title: 'Piala Prestasi',
      category: 'Prestasi',
      // Piala penghargaan
      imageUrl: 'https://images.pexels.com/photos/1408355/pexels-photo-1408355.jpeg?auto=compress&cs=tinysrgb&w=800',
      date: DateTime(2025, 2, 1),
    ),
    GalleryItem(
      id: 'g4',
      title: 'Kelas DKV',
      category: 'Fasilitas',
      // Ruang kelas modern
      imageUrl: 'https://images.pexels.com/photos/1181395/pexels-photo-1181395.jpeg?auto=compress&cs=tinysrgb&w=800',
      date: DateTime(2025, 3, 9),
    ),
  ];
}
