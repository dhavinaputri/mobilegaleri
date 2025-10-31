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
    ProgramKeahlian(id: 'rpl', name: 'Pengembangan Perangkat Lunak', description: 'Belajar pemrograman, mobile, web, dan basis data.'),
    ProgramKeahlian(id: 'dkv', name: 'Desain Komunikasi Visual', description: 'Desain grafis, multimedia, dan animasi.'),
    ProgramKeahlian(id: 'titl', name: 'Teknik Instalasi Tenaga Listrik', description: 'Instalasi listrik dan kelistrikan industri.'),
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
      imageUrl: null,
    ),
    NewsItem(
      id: 'n2',
      title: 'Kegiatan OSIS: Bakti Sosial',
      summary: 'OSIS melaksanakan bakti sosial di lingkungan sekolah.',
      content: 'Laporan kegiatan bakti sosial... ',
      category: 'Kegiatan',
      date: DateTime(2025, 2, 5),
      imageUrl: null,
    ),
    NewsItem(
      id: 'n3',
      title: 'Prestasi Juara LKS',
      summary: 'Siswa RPL raih juara LKS tingkat kota.',
      content: 'Cerita lengkap capaian siswa... ',
      category: 'Prestasi',
      date: DateTime(2025, 3, 2),
      imageUrl: null,
    ),
    NewsItem(
      id: 'n4',
      title: 'Artikel: Tips Belajar Efektif',
      summary: 'Artikel edukasi untuk siswa.',
      content: 'Beberapa tips dan teknik belajar... ',
      category: 'Artikel',
      date: DateTime(2025, 4, 20),
      imageUrl: null,
    ),
  ];

  static final gallery = <GalleryItem>[
    GalleryItem(id: 'g1', title: 'Upacara Bendera', category: 'Kegiatan', imageUrl: 'https://picsum.photos/seed/upacara/600/400', date: DateTime(2025, 1, 1)),
    GalleryItem(id: 'g2', title: 'Lab Komputer', category: 'Fasilitas', imageUrl: 'https://picsum.photos/seed/lab/600/400', date: DateTime(2025, 1, 15)),
    GalleryItem(id: 'g3', title: 'Piala Prestasi', category: 'Prestasi', imageUrl: 'https://picsum.photos/seed/piala/600/400', date: DateTime(2025, 2, 1)),
    GalleryItem(id: 'g4', title: 'Kelas DKV', category: 'Fasilitas', imageUrl: 'https://picsum.photos/seed/dkv/600/400', date: DateTime(2025, 3, 9)),
  ];
}
