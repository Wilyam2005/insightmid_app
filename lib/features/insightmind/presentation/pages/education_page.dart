// lib/features/insightmind/presentation/pages/education_page.dart
import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  // Tambahkan field "content" untuk isi artikel
  final List<Map<String, String>> articles = const [
    {
      'title': '5 Cara Efektif Mengelola Stres Sehari-hari',
      'summary': 'Pelajari teknik sederhana untuk mengurangi stres...',
      'content':
          'Stres adalah respon tubuh yang wajar, namun jika dibiarkan dapat mengganggu kesehatan. '
          'Berikut lima cara yang bisa Anda terapkan:\n\n'
          '1) Atur napas 4-7-8 selama 2–3 menit.\n'
          '2) Batasi paparan berita/medsos yang memicu kecemasan.\n'
          '3) Tuliskan 3 hal yang bisa Anda kontrol hari ini.\n'
          '4) Lakukan micro-break setiap 60–90 menit.\n'
          '5) Tidur cukup dan konsisten (7–8 jam).\n\n'
          'Tips kecil: mulai dari langkah paling mudah agar konsisten. Catat progres mingguan Anda.'
    },
    {
      'title': 'Pentingnya Tidur Berkualitas untuk Kesehatan Mental',
      'summary': 'Mengapa tidur cukup sangat vital...',
      'content':
          'Tidur memengaruhi regulasi emosi, konsentrasi, dan memori. Kekurangan tidur meningkatkan risiko cemas '
          'dan depresi. Jaga sleep hygiene: hindari kafein 6 jam sebelum tidur, redupkan layar 1 jam sebelum tidur, '
          'dan buat rutinitas malam yang tenang. Jika sulit tidur, coba latihan relaksasi otot progresif selama 10 menit.'
    },
    {
      'title': 'Mengenal Teknik Mindfulness untuk Ketenangan',
      'summary': 'Latihan dasar mindfulness yang bisa Anda coba...',
      'content':
          'Mindfulness adalah kesadaran penuh pada momen kini, tanpa menghakimi. Latihan dasar: duduk nyaman, '
          'fokus pada napas masuk-keluar. Saat pikiran melayang, akui dengan lembut lalu kembali ke napas. '
          'Mulai 5 menit/hari dan tambah bertahap.'
    },
    {
      'title': 'Kapan Sebaiknya Mencari Bantuan Profesional?',
      'summary': 'Tanda-tanda Anda mungkin perlu konsultasi...',
      'content':
          'Pertimbangkan konsultasi jika: (1) gejala mengganggu aktivitas harian >2 minggu, '
          '(2) pola tidur/nafsu makan sangat berubah, (3) pikiran menyakiti diri, atau (4) konflik memanjang. '
          'Mencari bantuan adalah langkah berani, bukan kelemahan.'
    },
    {
      'title': 'Manfaat Olahraga Rutin bagi Mood Anda',
      'summary':
          'Bagaimana aktivitas fisik memengaruhi kondisi mental...',
      'content':
          'Aktivitas fisik memicu pelepasan endorfin dan mengurangi hormon stres. Target minimal 150 menit/minggu '
          'intensitas sedang (jalan cepat, bersepeda santai). Mulai perlahan: 10–15 menit/hari lalu tingkatkan.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Edukasi'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.teal.shade900.withOpacity(0.3),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final a = articles[index];
            return Card(
              color: scheme.surface,
              elevation: 0,
              surfaceTintColor: scheme.primary.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  a['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(a['summary']!),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(
                        title: a['title']!,
                        summary: a['summary']!,
                        content: a['content']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Halaman detail artikel
class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String summary;
  final String content;

  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.summary,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        actions: [
          IconButton(
            tooltip: 'Bagikan',
            onPressed: () {
              // Implementasi share bisa ditambahkan sesuai kebutuhan/package
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur bagikan coming soon')),
              );
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.teal.shade900.withOpacity(0.15),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            const Divider(height: 24),
            const SizedBox(height: 4),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Selesai Membaca'),
            ),
          ],
        ),
      ),
    );
  }
}
